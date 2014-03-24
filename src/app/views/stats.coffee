_ = require('lodash')
React = require('react')
{aside, p, a} = React.DOM

module.exports = React.createClass
  displayName: 'StatsView'
  render: ->
    days = _(@props.snapshots)
    .map (snap) ->
      return null unless _.isString snap.date
      # just the date, not the time
      return snap.date.replace(/T(.*)$/, '')
    .reject _.isNull
    .unique()
    .value()

    minDay = days.sort()[0]

    (aside {key: 'meta', className: 'box meta', id: @props.id}, [
      (p {key: 'meta-p'}, [
        "#{@props.snapshots.length} snapshots covering #{days.length} days loaded. "
        "Your first report was on #{minDay}. "
        (a {key: "clearCache", href: '#clear', onClick: @props.clearCache},
          "Load new data"
        )
      ])
    ])
