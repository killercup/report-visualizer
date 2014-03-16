l = require('lodash')
React = require('react')

{g, text, circle, rect, line} = React.DOM

Chart = require('./chart')
Tooltip = require('./tooltip')

###
# @method Get Unique Values, Sorted
# @param {Array}    items
# @param {Function} [select] Mapping method
# @param {Function} [sort]   Sorting method
###
uniqValues = (items, select=l.identity, sort) ->
  l(items)
  .map select
  .unique()
  .sortBy(sort)
  .value()

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
    punchStyle: 'dots'
    width: 200
    height: 300
    padding:
      t: 0
      r: 0
      b: 40
      l: 40

  render: ->
    xValues = @props.xValues or uniqValues(@props.distribution, ([x, y, a]) -> x)
    yValues = @props.yValues or uniqValues(@props.distribution, ([x, y, a]) -> y)

    amountMin = l.min(@props.distribution, ([x, y, a]) -> a)[2]
    amountMax = l.max(@props.distribution, ([x, y, a]) -> a)[2]

    pad = @props.padding
    inner =
      height: @props.height - pad.t - pad.b
      width: @props.width - pad.l - pad.r

    heightPerItem = Math.floor (inner.height / yValues.length)
    withPerItem   = Math.floor (inner.width / xValues.length)
    maxRadius     = Math.floor(
      (Math.max 0, (Math.min heightPerItem, withPerItem) / 2) * 0.9
    )

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

    if @props.punchStyle is 'bars'
      dots = @props.distribution.map ([xVal, yVal, amount], index) ->
        return unless amount > 0
        h = heightPerItem - 4
        w = Math.max 2, (Math.floor (withPerItem - 4) * ((amount - amountMin) / amountMax))
        x = (withPerItem / 2) + xScale l.indexOf(xValues, xVal)
        y = (h           / 2) + yScale l.indexOf(yValues, yVal)

        (g {key: "#{xVal}-#{yVal}", className: 'dot'}, [
          (rect {
            key: 'bar'
            height: h
            width: w
            transform: "translate(#{x - Math.floor(w / 2)}, #{y - 0.5})"
            title: "#{amount}"
          })
          (Tooltip {
            key: 'tip',
            x: x, y: (y + h / 2),
            label: "#{amount}"
          })
        ])
    else
      dots = @props.distribution.map ([xVal, yVal, amount], index) ->
        return unless amount > 0
        r = Math.max 5,
          (maxRadius * (amount - amountMin) /
            Math.max(1, (amountMax - amountMin)))

        r = 5 if isNaN(r)

        x = (withPerItem   / 2) + xScale l.indexOf(xValues, xVal)
        y = (heightPerItem / 2) + yScale l.indexOf(yValues, yVal)

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
