l = require('lodash')
React = require('react')

{g, text} = React.DOM

Chart = require('../charts/chart')
Bar = require('../charts/bar')

module.exports = React.createClass
  getDefaultProps: ->
    width: 200
    height: 300
    fills: ['#042d42', '#0b84c2', '#075075', '#57bef2', '#326e8c']

  render: ->
    answerCount = l(@props.distribution)
      .reduce ((memo, x) -> memo + x), 0

    getFill = do =>
      i = 0
      =>
        i += 1
        @props.fills[i % @props.fills.length]

    offset = 0

    bars = l(@props.distribution)
      .pairs()
      .sortBy ([title, num]) -> -1 * num
      .map ([title, num]) =>
        height = @props.height * (num / answerCount)

        label = (text {x: 5, y: offset + 15}, title)

        bar = (Bar {
          width: @props.width
          height: height
          title: title
          fill: getFill()
          y: offset
        }, [])
        offset += height

        return (g {}, [
          bar
          label
        ])

    (Chart {
      width: @props.width, height: @props.height,
      className: "chart chart-stacked"
    },
      bars
    )
