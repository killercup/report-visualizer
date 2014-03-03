l = require('lodash')
React = require('react')

{section, div, h2} = React.DOM

Stacked = require('../charts/stacked')

getDistribution = (responses, aspect) ->
  l(responses)
  .where questionPrompt: aspect
  .reduce ((memo, response) ->
    for answer in response.answeredOptions
      memo[answer] or= 0
      memo[answer] += 1
    return memo
  ), {}

stack = React.createClass
  render: ->
    (div {className: "chart chart-stacked"}, [
      (h2 {}, @props.aspect)
      (Stacked {
        distribution: getDistribution(@props.responses, @props.aspect),
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
      (stack {responses: responses, aspect: "Did you shower today?"})
      (stack {responses: responses, aspect: "How did you sleep?"})
      (stack {responses: responses, aspect: "Are you working?"})
    ])
