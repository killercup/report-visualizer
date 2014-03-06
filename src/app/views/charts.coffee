l = require('lodash')
React = require('react')

{section, div, h2} = React.DOM

ChartTypes = require('../charts')
D = require('../reporter/distributions')

ChartContainer = React.createClass
  getDefaultProps: ->
    chartType: 'VerticalBars'
    width: 260
    extraClasses: ''

  render: ->
    SpecificChart = ChartTypes[@props.chartType] or ChartTypes.VerticalBars

    (div {className: "chart-container #{@props.extraClasses}"}, [
      (h2 {}, @props.aspect)
      (div {className: 'chart-box'}, [
        (SpecificChart @props, [])
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

    weekdays = ['7 Sun', '1 Mon', '2 Tue', '3 Wed', '4 Thu', '5 Fri', '6 Sat']
    impetues = ['Tapped', 'Sleeping', 'Day', 'Dusk', 'Dawn']

    charts = questions.map (question) ->
      sample = l.find(responses, questionPrompt: question)

      if /^(Yes|No)$/.test sample.answeredOptions?[0]
        getIndex = (snap) ->
          d = new Date(snap.date)
          [d.getDay(), snap.reportImpetus]

        counting = ((i) -> i is "Yes")

        snaps = l.filter data.snapshots, (snap) ->
          snap.reportImpetus and _.isString(snap.date)

        dist = l D.aggregatePunch snaps, getIndex, question, counting
          .filter ([x, y, a]) -> a >= 0
          .map ([x, y, a]) ->
            [weekdays[x], impetues[y], a]
          .value()

        props =
          aspect: question
          distribution: dist
          chartType: 'PunchChart'
          width: 2 * 260 + 40
          extraClasses: 'double'
          padding: l: 60, b: 30, r: 0, t: 0
      else
        props = D.getDistribution(responses, question)

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
