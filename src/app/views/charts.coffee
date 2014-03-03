l = require('lodash')
React = require('react')

{section, div, h2} = React.DOM

ChartTypes = require('../charts')
D = require('../reporter/distributions')

ChartContainer = React.createClass
  getDefaultProps: ->
    chartType: 'VerticalBars'

  render: ->
    SpecificChart = ChartTypes[@props.chartType] or ChartTypes.VerticalBars    

    (div {className: "chart-container"}, [
      (h2 {}, @props.aspect)
      (div {className: 'chart-box'}, [
        (SpecificChart {
          distribution: @props.distribution,
          aspect: @props.aspect
          width: 260
        }, [])
      ])
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

    charts = questions.map (question) ->
      props = D.getDistribution(responses, question)
      sample = l.find(responses, questionPrompt: question)

      if sample.answeredOptions
        props.chartType = 'Stacked'
      else
        props.chartType = 'VerticalBars'

      (ChartContainer props, [])

    do =>
      props = D.connectionsDistribution(@props.snapshots, "What's your internet connection?")
      props.chartType = 'Stacked'
      charts.push (ChartContainer props, [])

    (section {}, charts)
