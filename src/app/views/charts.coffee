l = require('lodash')
s = require('underscore.string')
React = require('react')

{section, p} = React.DOM

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
        if sam = l.find(snap.responses, questionPrompt: question)
          sample = sam
          sampleSnap = snap
          break

      chartSettings = @state.chartSettings[question] or {}

      slug = s.slugify question

      (ChartContainer {
        key: slug, id: slug,
        snapshots: @props.snapshots, aspect: question,
        responses: responses, sample: sample, sampleSnap: sampleSnap,
        chartType: chartSettings.chartType, punchStyle: chartSettings.punchStyle
      })

    do =>
      question = "What's your internet connection?"
      slug = s.slugify question

      charts.push (extras.ConnectionChart {
        key: charts.length, id: slug
        snapshots: @props.snapshots
        aspect: question
      }, [])

    @charts = charts

    res = (section {className: 'charts'}, [
      (p {key: 'charts-headline', className: 'subtitle'}, [
        "#{responses.length} Answers"
      ])
    ].concat(charts))
    res
