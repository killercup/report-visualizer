###
# # Stacked Chart
###
L = require('lazy')
React = require('react')

{g, text} = React.DOM

Chart = require('../charts/chart')
Bar = require('../charts/bar')

###
# @method Stacked Bar Component
###
module.exports = React.createClass
  displayName: "StackedBar"

  propTypes:
    width: React.PropTypes.number
    height: React.PropTypes.number
    fills: React.PropTypes.arrayOf(React.PropTypes.string)
    barOrder: React.PropTypes.func
    distribution: React.PropTypes.object.isRequired

  getDefaultProps: ->
    width: 200
    height: 300
    fills: ['#042d42', '#0b84c2', '#075075', '#57bef2', '#326e8c']
    barOrder: ([title, num]) -> -1 * num

  render: ->
    answerCount = L(@props.distribution)
      .reduce ((memo, x) -> memo + x), 0

    getFill = do =>
      i = 0
      =>
        i += 1
        @props.fills[i % @props.fills.length]

    offset = 0

    bars = L(@props.distribution)
    .pairs()
    .sortBy @props.barOrder
    .map ([title, num], index) =>
      height = @props.height * (num / answerCount)

      label = (text {key: 'label', x: 5, y: offset + 15}, title)

      bar = (Bar {
        key: 'bar'
        width: @props.width
        height: height
        title: title
        fill: getFill()
        y: offset
      }, [])
      offset += height

      return (g {
        key: index
        className: if num is 0 then 'hidden' else ''
      }, [
        bar
        label
      ])
    .toArray()

    return (g {className: 'stacked-bar'}, bars)

