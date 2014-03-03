l = require('lodash')
React = require('react')

{section, div, h2} = React.DOM

Stacked = require('../charts/stacked')

answeredOptionsDistribution = (responses, aspect) ->
  aspect: aspect
  distribution: l(responses)
    .where questionPrompt: aspect
    .reduce ((memo, response) ->
      for answer in response.answeredOptions
        memo[answer] or= 0
        memo[answer] += 1
      return memo
    ), {}

locationsDistribution = (responses, aspect) ->
  aspect: aspect
  distribution: l(responses)
    .where questionPrompt: aspect
    .reduce ((memo, response) ->
      answer = response.locationResponse?.text
      return memo unless answer
      memo[answer] or= 0
      memo[answer] += 1
      return memo
    ), {}

connectionsDistribution = (snapshots, aspect) ->
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

stack = React.createClass
  render: ->
    (div {className: "chart chart-stacked"}, [
      (h2 {}, @props.aspect)
      (Stacked {
        distribution: @props.distribution,
        aspect: @props.aspect
      }, [])
    ])

module.exports = React.createClass
  render: ->
    responses = l(@props.snapshots)
      .pluck('responses')
      .flatten()
      .value()

    (section {}, [
      (stack answeredOptionsDistribution(responses, "Are you working?"), [])
      (stack connectionsDistribution(@props.snapshots, "What's your internet connection?"), [])
      (stack locationsDistribution(responses, "Where are you?"), [])
      (stack answeredOptionsDistribution(responses, "Did you brush your teeth today?"), [])
      (stack answeredOptionsDistribution(responses, "Did you do 7min training today?"), [])
      (stack answeredOptionsDistribution(responses, "Did you drink any alcohol?"), [])
      (stack answeredOptionsDistribution(responses, "Did you have breakfast today?"), [])
      (stack answeredOptionsDistribution(responses, "Did you shower today?"), [])
      (stack answeredOptionsDistribution(responses, "How did you sleep?"), [])
      (stack answeredOptionsDistribution(responses, "How much water did you drink today?"), [])
      (stack answeredOptionsDistribution(responses, "Was today a significant day?"), [])
      (stack answeredOptionsDistribution(responses, "Were you as productive as you wanted to be today?"), [])
    ])
