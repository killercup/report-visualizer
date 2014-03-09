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
      for snap in @props.snapshots by -1
        if s = l.find(snap.responses, questionPrompt: question)
          sample = s
          sampleSnap = snap
          break

      (ChartContainer {
        key: index,
        snapshots: @props.snapshots, aspect: question,
        responses: responses, sample: sample, sampleSnap: sampleSnap
      })

    charts.push (extras.ConnectionChart {
      key: charts.length
      snapshots: @props.snapshots
    }, [])

    (section {}, charts)
