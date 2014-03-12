###
# # Transform ReporterApp Data
#
# cf. [Reporter Save File Schema](https://gist.github.com/dbreunig/9315705)
###
L = require('lazy')

exports = module.exports

exports.getAnswersFromResponse = (r) ->
  val = r.answeredOptions or r.tokens
  val or= r.numericResponse or r.textResponse or r.locationResponse?.text
  val = [val] unless Array.isArray(val)
  return val

exports.getAnswerCount = (responses, filter=L.identity) ->
  L(responses)
  .reduce ((memo, response) ->
    for answer in exports.getAnswersFromResponse(response)
      continue unless filter(answer)
      memo[answer] or= 0
      memo[answer] += 1
    return memo
  ), {}

exports.getDistribution = (responses, aspect) ->
  aspect: aspect
  distribution: exports.getAnswerCount L(responses).where(questionPrompt: aspect)

exports.getGroupedDistribution = (snapshots, grouping, aspect) ->
  L(snapshots)
  .map (snap) ->
    date: snap.date
    response: L(snap.responses).findWhere(questionPrompt: aspect)
  .reject (snap) -> not snap.date or not snap.response
  .groupBy grouping
  .pairs()
  .map ([key, responses]) ->
    return [
      key
      exports.getAnswerCount L(responses).pluck('response').toArray()
    ]
  .toArray()

exports.connectionsDistribution = (snapshots, aspect) ->
  distribution = L(snapshots)
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

  return {
    aspect: aspect
    distribution: distribution
  }

exports.aggregateWithIndex = (snapshots, getIndex, getValues, reduceValues) ->
  L(snapshots)
  .reject (item) -> not getValues(item)
  .groupBy (item) -> JSON.stringify getIndex(item)
  .pairs()
  .map ([key, items]) ->
    index = getIndex items[0]
    items = reduceValues items.map (item) -> getValues(item)
    L([index, items]).flatten().toArray()
  .toArray()

exports.aggregatePunch = (snapshots, getIndex, aspect, answerFilter) ->
  getValues = (snap) ->
    res = L(snap.responses).findWhere(questionPrompt: aspect)
    res?.answeredOptions?[0]

  reduceValues = (vals) ->
    L(vals)
    .reduce ((memo, item) ->
      return memo + 1 if answerFilter(item)
      return memo
    ), 0

  exports.aggregateWithIndex(snapshots, getIndex, getValues, reduceValues)
