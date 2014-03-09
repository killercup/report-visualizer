l = require('lodash')
React = require('react')

ChartContainer = require('./chartSwitch')
D = require('../reporter/distributions')

module.exports = exports = {}

exports.ConnectionChart = React.createClass
  render: ->
    aspect = "What's your internet connection?"
    props = D.connectionsDistribution(@props.snapshots, aspect)
    props.chartType = 'Stacked'

    (ChartContainer props, [])
