l = require('lodash')
React = require('react')

{div, h2, select, option} = React.DOM

ChartTypes = require('../charts')
D = require('../reporter/distributions')

SpecificCharts = {}

SpecificCharts.Stacked = React.createClass
  render: ->
    if @props.distribution
      props = @props
    else
      props = _.defaults(D.getDistribution(@props.responses, @props.aspect), @props)

    (ChartTypes.Stacked props, [])

SpecificCharts.VerticalBars = React.createClass
  render: ->
    if @props.distribution
      props = @props
    else
      props = _.defaults(D.getDistribution(@props.responses, @props.aspect), @props)

    (ChartTypes.VerticalBars props, [])

SpecificCharts.PunchChart = React.createClass
  getDefaultProps: ->
    weekdays: ['7 Sun', '1 Mon', '2 Tue', '3 Wed', '4 Thu', '5 Fri', '6 Sat']
    impetues: ['Tapped', 'Sleeping', 'Day', 'Dusk', 'Dawn']

  render: ->
    getIndex = (snap) ->
      d = new Date(snap.date)
      [d.getDay(), snap.reportImpetus]

    counting = ((i) -> i is "Yes")

    snaps = l.filter @props.snapshots, (snap) ->
      snap.reportImpetus and _.isString(snap.date)

    dist = l D.aggregatePunch snaps, getIndex, @props.aspect, counting
      .filter ([x, y, a]) -> a >= 0
      .map ([x, y, a]) =>
        [@props.weekdays[x], @props.impetues[y], a]
      .value()

    (ChartTypes.PunchChart {
      aspect: @props.aspect
      distribution: dist
      width: 2 * 260 + 40
      padding: l: 60, b: 30, r: 0, t: 0
    })

module.exports = React.createClass
  getDefaultProps: ->
    width: 260
    extraClasses: ''

  getInitialState: ->
    chartType: @props.chartType

  componentWillMount: ->
    unless @state.chartType?
      if /^(Yes|No)$/.test @props.sample?.answeredOptions?[0]
        @setState chartType: 'PunchChart'
      else if @props.sample.answeredOptions
        @setState chartType: 'Stacked'
      else
        @setState chartType: 'VerticalBars'

  handleChartTypeChange: ->
    @setState
      chartType: event.target.value

  render: ->
    SpecificChart = SpecificCharts[@state.chartType] or SpecificCharts.VerticalBars

    (div {className: "chart-container#{if @state.chartType is 'PunchChart' then ' double' else ''}"}, [
      (h2 {}, [
        "#{@props.aspect} "
        (select {value: @state.chartType, onChange: @handleChartTypeChange},
          _(SpecificCharts).keys()
          .reject (i) => i is 'PunchChart' and not /^(Yes|No)$/.test @props.sample?.answeredOptions?[0]
          .map (key) -> (option {value: key}, key)
          .value()
        )
      ])
      (div {className: 'chart-box'}, [
        (SpecificChart @props, [])
      ])
    ])
