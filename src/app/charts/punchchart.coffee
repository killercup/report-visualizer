L = require('lazy')
React = require('react')

{g, text, circle, line} = React.DOM

Chart = require('./chart')
Tooltip = require('./tooltip')

###
# @method Punchchart Component
# @param {Array} distribution `[xValue, yValue, amount]`
###
module.exports = React.createClass
  displayName: "PunchChart"

  propTypes:
    width: React.PropTypes.number
    height: React.PropTypes.number
    padding: React.PropTypes.shape
      t: React.PropTypes.number
      r: React.PropTypes.number
      b: React.PropTypes.number
      l: React.PropTypes.number
    distribution: React.PropTypes.arrayOf(React.PropTypes.array).isRequired
    xValues: React.PropTypes.array
    yValues: React.PropTypes.array

  getDefaultProps: ->
    width: 200
    height: 300
    padding:
      t: 0
      r: 0
      b: 40
      l: 40

  render: ->
    throw new Error("no distribution") unless @props.distribution.length

    xValues = @props.xValues or L(@props.distribution)
      .map ([xVal, yVal, amount]) -> xVal
      .uniq()
      .sortBy()
      .toArray()

    yValues = @props.yValues or L(@props.distribution)
      .map ([xVal, yVal, amount]) -> yVal
      .uniq()
      .sortBy()
      .toArray()

    amountMin = L(@props.distribution).min(([xVal, yVal, amount]) -> amount)[2]
    amountMax = L(@props.distribution).max(([xVal, yVal, amount]) -> amount)[2]

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

    yMarkers = yValues.map (name, index) ->
      (line {
        key: index
        x1: pad.l - 5, y1: yScale(index + 1) - (heightPerItem / 2)
        x2: pad.l + 5, y2: yScale(index + 1) - (heightPerItem / 2)
      })

    yLabels = yValues.map (name='', index) ->
      (text {
        key: index
        x: pad.l - 10
        y: yScale(index + 1) - (heightPerItem / 2) + 5
      }, name)

    xMarkers = xValues.map (name, index) =>
      (line {
        key: index
        x1: xScale(index) + (withPerItem / 2), y1: @props.height - pad.b - 5
        x2: xScale(index) + (withPerItem / 2), y2: @props.height - pad.b + 5
      })

    xLabels = xValues.map (name='', index) =>
      (text {
        key: index
        x: xScale(index) + (withPerItem / 2)
        y: @props.height - pad.b + 20
      }, name.replace(/^(\d*) /, ''))

    dots = @props.distribution.map ([xVal, yVal, amount], index) ->
      return unless amount > 0
      r = Math.max 5,
        (maxRadius * (amount - amountMin) /
          Math.max(1, (amountMax - amountMin)))

      r = 5 if isNaN(r)

      x = (withPerItem   / 2) + xScale xValues.indexOf(xVal)
      y = (heightPerItem / 2) + yScale yValues.indexOf(yVal)

      (g {key: "#{xVal}-#{yVal}", className: 'dot'}, [
        (circle {
          key: 'dot'
          r: r
          transform: "translate(#{x}, #{y})"
          title: "#{amount}"
        })
        (Tooltip {
          key: 'tip',
          x: x, y: y-r,
          label: "#{amount}"
        })
      ])

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
