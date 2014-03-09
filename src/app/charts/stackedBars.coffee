###
# # Stacked Bars Chart
#
# Display multiple stacked bars next to each other.
###
l = require('lodash')
React = require('react')

{line, g, text} = React.DOM

Chart = require('../charts/chart')
Stacked = require('../charts/stacked')

module.exports = React.createClass
  displayName: "StackedBarsChart"

  propTypes:
    width: React.PropTypes.number
    height: React.PropTypes.number
    padding: React.PropTypes.shape
      t: React.PropTypes.number
      r: React.PropTypes.number
      b: React.PropTypes.number
      l: React.PropTypes.number
    xValues: React.PropTypes.array
    distribution: React.PropTypes.arrayOf(React.PropTypes.array).isRequired

  getDefaultProps: ->
    width: 2 * 260 + 40
    height: 300
    padding:
      t: 0
      r: 0
      b: 30
      l: 0

  render: ->
    xValues = @props.xValues or l(@props.distribution)
      .map ([xVal, amount]) -> xVal
      .unique()
      .sortBy()
      .value()

    pad = @props.padding
    inner =
      height: @props.height - pad.t - pad.b
      width: @props.width - pad.l - pad.r

    withPerItem = Math.floor (inner.width) / xValues.length

    xScale = (index) -> pad.l + withPerItem * index

    xAxis = (line {
      key: 'xAxis',
      x1: 0, x2: @props.width,
      y1: inner.height + pad.t, y2: inner.height + pad.t,
      transform: "translate(0.5,0.5)"
    })

    xMarkers = l.map xValues, (name, index) =>
      (line {
        key: index
        x1: xScale(index) + (withPerItem / 2), y1: @props.height - pad.b - 5
        x2: xScale(index) + (withPerItem / 2), y2: @props.height - pad.b + 5
      })

    xLabels = l.map xValues, (name='', index) =>
      (text {
        key: index
        x: xScale(index) + (withPerItem / 2)
        y: @props.height - pad.b + 20
      }, name.replace(/^(\d*) /, ''))

    bars = l.map @props.distribution, ([xVal, distribution], index) ->
      (g {
        key: "#{xVal}"
        transform: "translate(#{xScale(index)},0)"
      }, [
        (Stacked {
          key: 'stack'
          width: withPerItem - 10
          height: inner.height
          distribution: distribution
          barOrder: ([title, num]) -> title
        }, [])
      ])

    (Chart {
      width: @props.width, height: @props.height,
      className: "chart chart-stacked chart-stacked-bars"
    }, [
      xAxis
      (g {key: 'labels-x', className: 'labels-x'}, xLabels)
      (g {key: 'markers-x', className: 'markers-x'}, xMarkers)
      bars
    ])
