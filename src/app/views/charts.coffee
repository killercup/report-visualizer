l = require('lodash')
React = require('react')

{section, h2} = React.DOM

D = require('../reporter/distributions')
ChartContainer = require('./chartSwitch')
extras = require('./extraCharts')

data = require('../data')

module.exports = React.createClass
  displayName: "ChartsView"

  getInitialState: ->
    chartSettings: data.chartSettings.get()

  getChartSettings: ->
    settings = {}
    @charts.forEach (chart) ->
      settings[chart.props.aspect] =
        chartType:  chart.state?.chartType
        punchStyle: chart.state?.punchStyle

    return settings

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

      chartSettings = @state.chartSettings[question] or {}

      (ChartContainer {
        key: index,
        snapshots: @props.snapshots, aspect: question,
        responses: responses, sample: sample, sampleSnap: sampleSnap,
        chartType: chartSettings.chartType, punchStyle: chartSettings.punchStyle
      })

    charts.push (extras.ConnectionChart {
      key: charts.length
      snapshots: @props.snapshots
      aspect: "What's your internet connection?"
    }, [])

    @charts = charts

    res = (section {className: 'charts'}, [
      (h2 {key: 'charts-headline', className: 'box'},
        "Your #{questions.length} Questions"
      )
    ].concat(charts))
    res
