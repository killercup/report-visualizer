l = require('lodash')
React = require('react')

{div, article, header, h2, p, button, select, option, label} = React.DOM

SpecificCharts = require('./specificCharts')
Overlay = require('./overlay')

data = require('../data')

isPunchChart = (chartType) ->
  /^Punch/.test chartType

module.exports = React.createClass
  displayName: "ChartContainer"
  mixins: [React.addons.LinkedStateMixin]

  getDefaultProps: ->
    # width: 260

  getInitialState: ->
    punchChartAble = /^(Yes|No)$/.test @props.sample?.answeredOptions?[0]

    if @props.chartType
      chartType = @props.chartType
    else
      if punchChartAble
        if @props.sampleSnap?.reportImpetus is 2 #day
          chartType = 'PunchHourWeekday'
        else
          chartType = 'StackedByWeekday'
      else if @props.sample.answeredOptions
        chartType = 'Stacked'
      else
        chartType = 'VerticalBars'

    chartType: chartType
    punchStyle: @props.punchStyle
    punchChartAble: punchChartAble
    overlay: false

  handleChartTypeChange: ->
    @setState
      chartType: event.target.value

  toggleOverlay: ->
    @setState overlay: not @state.overlay

  render: ->
    SpecificChart = SpecificCharts[@state.chartType] or SpecificCharts.VerticalBars

    chartOptions = _(SpecificCharts).keys()
      .reject (i) => (isPunchChart i) and not @state.punchChartAble
      .map (key) -> (option {key: key, value: key}, key)
      .value()

    classes = React.addons.classSet
      'chart-container': true,
      'double': (isPunchChart @state.chartType) or (@state.chartType is 'StackedByWeekday')

    (div {className: classes, id: @props.id}, [
      (Overlay {key: 'over', active: @state.overlay}, [
        (article {key: 'main', className: 'main'}, [
          (header {key: 'h'}, [
            (button {
              key: 'settings'
              className: 'toggle-settings'
              onClick: @toggleOverlay
            }, "Settings")
            (h2 {key: 'heading'}, @props.aspect)
          ])
          (div {key: 'chart', className: 'chart-box'}, [
            (SpecificChart _.defaults({
              key: 'chart'
              punchStyle: @state.punchStyle
            }, @props), [])
          ])
        ])
        (div {key: 'overlay', className: 'overlay'}, [
          (header {key: 'h'}, [
            (button {
              key: 'settings'
              className: 'toggle-settings'
              onClick: @toggleOverlay
            }, "Done")
            (h2 {key: 'heading'}, @props.aspect)
          ])
          (p {key: 'settings-1'}, [
            (label {key: 'label'}, [
              "Chart Type ",
              (select {key: 'select', valueLink: @linkState('chartType')}, chartOptions)
            ])
          ])
          if (isPunchChart @state.chartType)
            (p {key: 'settings-punch'}, [
              (label {key: 'label'}, [
                "Punch Style ",
                (select {
                  key: 'select', valueLink: @linkState('punchStyle')
                }, ['dots', 'bars'].map (i) -> (option {key: i, value: i}, i))
              ])
            ])
        ])
      ])
    ])

  componentDidUpdate: ->
    data.chartSettings.set @props.aspect,
      chartType:  @state.chartType
      punchStyle: @state.punchStyle
