l = require('lodash')
React = require('react')

{section} = React.DOM

D = require('../reporter/distributions')
ChartContainer = require('./chartSwitch')

module.exports = React.createClass
  displayName: "ChartsView"
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

    charts = questions.map (question, index) =>
      sample = l.find(responses, questionPrompt: question)
      (ChartContainer {
        key: index,
        snapshots: @props.snapshots, aspect: question,
        responses: responses, sample: sample
      })

    do =>
      aspect = "What's your internet connection?"
      distribution = D.connectionsDistribution(@props.snapshots, aspect).distribution
      props =
        key: charts.length
        aspect: aspect
        distribution: distribution
        chartType: 'Stacked'
      charts.push (ChartContainer props, [])

    (section {}, charts)
