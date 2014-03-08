l = require('lodash')
React = require('react')

{g, text, circle, line} = React.DOM

Chart = require('../charts/chart')

###
# @method Punchchart Component
# @param {Array} distribution `[xValue, yValue, amount]`
###
module.exports = React.createClass
  displayName: "PunchChart"
  getDefaultProps: ->
    width: 200
    height: 300
    padding:
      t: 0
      r: 0
      b: 40
      l: 40

  render: ->
    xValues = l(@props.distribution)
      .map ([xVal, yVal, amount]) -> xVal
      .unique()
      .sortBy()
      .value()

    yValues = l(@props.distribution)
      .map ([xVal, yVal, amount]) -> yVal
      .unique()
      .sortBy()
      .value()

    amountMin = l.min(@props.distribution, ([xVal, yVal, amount]) -> amount)[2]
    amountMax = l.max(@props.distribution, ([xVal, yVal, amount]) -> amount)[2]

    pad = @props.padding
    inner =
      height: @props.height - pad.t - pad.b
      width: @props.width - pad.l - pad.r

    heightPerItem = Math.floor (inner.height) / yValues.length
    withPerItem = Math.floor (inner.width) / xValues.length
    maxRadius = Math.floor(Math.max(0, Math.min(heightPerItem, withPerItem)/2) * 0.9)

    yScale = (index) -> pad.t + heightPerItem * index
    xScale = (index) -> pad.l + withPerItem * index

    xAxis = (line {
      key: 'xAxis',
      x1: 0, x2: @props.width,
      y1: inner.height + pad.t, y2: inner.height + pad.t,
      transform: "translate(0.5,0.5)"
    })
    yAxis = (line {
      key: 'yAxis',
      x1: pad.l, x2: pad.l,
      y1: 0, y2: @props.height,
      transform: "translate(0.5,0.5)"
    })

    yMarkers = l.map yValues, (name, index) ->
      (line {
        key: index
        x1: pad.l - 5, y1: yScale(index + 1) - (heightPerItem / 2)
        x2: pad.l + 5, y2: yScale(index + 1) - (heightPerItem / 2)
      })

    yLabels = l.map yValues, (name='', index) ->
      (text {
        key: index
        x: pad.l - 10
        y: yScale(index + 1) - (heightPerItem / 2) + 5
      }, name)

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

    dots = l.map @props.distribution, ([xVal, yVal, amount], index) ->
      r = Math.max 5, (maxRadius * (amount - amountMin) / Math.max(1, (amountMax - amountMin)))
      if isNaN(r)
        console.log amount, maxRadius, amountMin, amountMax
      return unless amount > 0
      (circle {
        key: index
        r: r
        transform: "translate(#{(withPerItem/2) + xScale _.indexOf(xValues, xVal)}, #{(heightPerItem/2) + yScale _.indexOf(yValues, yVal)})"
        title: "#{amount}"
      })

    (Chart {
      width: @props.width, height: @props.height,
      className: "chart chart-punchchart"
    }, [
      xAxis
      yAxis
      (g {key: 'labels-y', className: 'labels-y'}, yLabels)
      (g {key: 'markers-y', className: 'markers-y'}, yMarkers)
      (g {key: 'labels-x', className: 'labels-x'}, xLabels)
      (g {key: 'markers-x', className: 'markers-x'}, xMarkers)
      (g {key: 'values', className: 'values'}, dots)
    ])
