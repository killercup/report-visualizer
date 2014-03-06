###
# # Transform ReporterApp Data
#
# cf. [Reporter Save File Schema](https://gist.github.com/dbreunig/9315705)
###
l = require('lodash')

exports = module.exports

exports.getAnswersFromResponse = (r) ->
  val = r.answeredOptions or r.tokens
  val or= r.numericResponse or r.textResponse or r.locationResponse?.text
  val = [val] unless l.isArray(val)
  return val

exports.getAnswerCount = (responses, filter=_.identity) ->
  l(responses)
  .reduce ((memo, response) ->
    for answer in exports.getAnswersFromResponse(response)
      continue unless filter(answer)
      memo[answer] or= 0
      memo[answer] += 1
    return memo
  ), {}

exports.getDistribution = (responses, aspect) ->
  aspect: aspect
  distribution: exports.getAnswerCount l(responses).where questionPrompt: aspect

exports.connectionsDistribution = (snapshots, aspect) ->
  aspect: aspect
  distribution: l(snapshots)
    .pluck "connection"
    .map (val) ->
      return 'Cell' if val is 0
      return 'WiFi' if val is 1
      return 'Offline'
    .reduce ((memo, value) ->
      memo[value] or= 0
      memo[value] += 1
      return memo
    ), {}

exports.aggregateWithIndex = (snapshots, getIndex, getValues, reduceValues) ->
  l(snapshots)
  .reject (item) -> not getValues(item)
  .groupBy (item) -> JSON.stringify getIndex(item)
  .pairs()
  .map ([key, items]) ->
    index = getIndex items[0]
    items = reduceValues _.map items, (item) -> getValues(item)
    _.flatten [index, items]
  .value()

exports.aggregatePunch = (snapshots, getIndex, aspect, answerFilter) ->
  getValues = (snap) ->
    res = _.where snap.responses, questionPrompt: aspect
    # _.find getAnswersFromResponse(res), answerFilter
    res?[0]?.answeredOptions?[0]

  reduceValues = (vals) ->
    l(vals)
    .reduce ((memo, item) ->
      return memo + 1 if answerFilter(item)
      return memo
    ), 0

  exports.aggregateWithIndex(snapshots, getIndex, getValues, reduceValues)
