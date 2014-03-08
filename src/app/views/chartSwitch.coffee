l = require('lodash')
React = require('react')

{div, h2, p, button, select, option, label} = React.DOM

SpecificCharts = require('./specificCharts')
Overlay = require('./overlay')

isPunchChart = (chartType) ->
  /^Punch/.test chartType

module.exports = React.createClass
  displayName: "ChartContainer"
  mixins: [React.addons.LinkedStateMixin]

  getDefaultProps: ->
    width: 260
    extraClasses: ''
    overlay: false

  getInitialState: ->
    punchChartAble = /^(Yes|No)$/.test @props.sample?.answeredOptions?[0]

    if @props.chartType
      chartType = @props.chartType
    else
      if punchChartAble
        chartType = 'PunchImpetusWeekday'
      else if @props.sample.answeredOptions
        chartType = 'Stacked'
      else
        chartType = 'VerticalBars'

    chartType: chartType
    punchChartAble: punchChartAble

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
      'double': (isPunchChart @state.chartType)

    (div {className: classes}, [
      (Overlay {key: 'overlay', active: @state.overlay}, [
        (div {key: 'main', className: 'main'}, [
          (button {
            key: 'settings'
            className: 'toggle-settings'
            onClick: @toggleOverlay
          }, "Settings")
          (h2 {key: 'heading'}, @props.aspect)
          (div {key: 'chart', className: 'chart-box'}, [
            (SpecificChart @props, [])
          ])
        ])
        (div {key: 'overlay', className: 'overlay'}, [
          (button {
            key: 'settings'
            className: 'toggle-settings'
            onClick: @toggleOverlay
          }, "Done")
          (h2 {key: 'heading'}, @props.aspect)
          (p {key: 'settings-1'}, [
            (label {key: 'label'}, [
              "Chart Type ",
              (select {key: 'select', valueLink: @linkState('chartType')}, chartOptions)
            ])
          ])
        ])
      ])
    ])
