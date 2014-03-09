###
# # Stacked Bar Chart
###
React = require('react')

Chart = require('../charts/chart')
Stacked = require('../charts/stacked')

module.exports = React.createClass
  displayName: "StackedBarChart"
  getDefaultProps: ->
    width: 200
    height: 300

  render: ->
    (Chart {
      width: @props.width, height: @props.height,
      className: "chart chart-stacked chart-stacked-bar"
    },
      (Stacked @props, [])
    )
