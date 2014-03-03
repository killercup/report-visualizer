l = require('lodash')
React = require('react')

{section, div, h2} = React.DOM

Stacked = require('../charts/stacked')
D = require('../reporter/distributions')

stack = React.createClass
  render: ->
    # console.log @props.aspect, @props.distribution
    (div {className: "chart chart-stacked"}, [
      (h2 {}, @props.aspect)
      (Stacked {
        distribution: @props.distribution,
        aspect: @props.aspect
        width: 260
      }, [])
    ])

module.exports = React.createClass
  render: ->
    responses = l(@props.snapshots)
      .pluck('responses')
      .flatten()
      .value()

    questions = l(responses)
      .pluck('questionPrompt')
      .unique()
      .sort()
      .value()

    stacks = questions.map (question) ->
      (stack D.getDistribution(responses, question), [])
    stacks.push (stack D.connectionsDistribution(@props.snapshots, "What's your internet connection?"), [])

    (section {}, stacks)
