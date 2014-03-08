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

    unless @props.chartType
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
      .map (key) -> (option {value: key}, key)
      .value()

    classes = React.addons.classSet
      'chart-container': true,
      'double': (isPunchChart @state.chartType)

    settingsButton = =>
      (button {
        className: 'toggle-settings'
        onClick: @toggleOverlay
      }, "Settings")

    (div {className: classes}, [
      (Overlay {active: @state.overlay}, [
        (div {className: 'main'}, [
          (settingsButton {})
          (h2 {}, @props.aspect)
          (div {className: 'chart-box'}, [
            (SpecificChart @props, [])
          ])
        ])
        (div {className: 'overlay'}, [
          (settingsButton {})
          (h2 {}, "Settings for #{@props.aspect}")
          (p {}, [
            (label {}, [
              "Chart Type ",
              (select {valueLink: @linkState('chartType')}, chartOptions)
            ])
          ])
        ])
      ])
    ])
