l = require('lodash')
React = require('react')

{section} = React.DOM

D = require('../reporter/distributions')
ChartContainer = require('./chartSwitch')
extras = require('./extraCharts')

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

    charts.push (extras.ConnectionChart {
      key: charts.length
      snapshots: @props.snapshots
    }, [])

    (section {}, charts)
