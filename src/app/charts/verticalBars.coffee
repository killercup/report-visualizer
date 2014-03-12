L = require('lazy')
React = require('react')

{div, p} = React.DOM

Chart = require('../charts/chart')
Bar = require('../charts/bar')

module.exports = React.createClass
  displayName: "VerticalBarChart"

  propTypes:
    width: React.PropTypes.number
    height: React.PropTypes.number
    lineHeight: React.PropTypes.number
    # distribution: React.PropTypes.arrayOf(React.PropTypes.array).isRequired

  getDefaultProps: ->
    width: 200
    height: 300
    lineHeight: 5

  render: ->
    maxNum = L(@props.distribution).max(L.identity)

    lines = L(@props.distribution)
    .pairs()
    .sortBy ([title, num]) -> -1 * num
    .map ([title, num], index) =>
      width = @props.width * (num / maxNum)

      label = (p {
        key: 'label'
        className: 'chart-vertical-label'
      }, "#{title} (#{num})")

      bar = (div {
        key: 'bar',
        className: 'chart-vertical-bar'
        style:
          width: width
          height: @props.lineHeight
      }, [])

      return (div {
        key: "#{title}"
        className: 'chart-vertical-line'
      }, [
        label
        bar
      ])
    .toArray()

    (div {
      className: 'chart chart-vertical-bars'
    },
      lines
    )