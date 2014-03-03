###
# # Transform ReporterApp Data
#
# cf. [Reporter Save File Schema](https://gist.github.com/dbreunig/9315705)
###
l = require('lodash')

exports = module.exports

exports.getDistribution = (responses, aspect) ->
  aspect: aspect
  distribution: l(responses)
    .where questionPrompt: aspect
    .reduce ((memo, r) ->
      val = r.numericResponse or r.textResponse or r.locationResponse?.text
      val or= r.answeredOptions or r.tokens
      val = [val] unless l.isArray(val)
      for answer in val
        continue unless answer
        memo[answer] or= 0
        memo[answer] += 1
      return memo
    ), {}

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
