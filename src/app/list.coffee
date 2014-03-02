_ = require('highland')
React = require('react')

{ul, li} = React.DOM

module.exports = React.createClass
  render: ->
    (ul {},
      (for snap in @props.snapshots
        (li {}, snap.day or snap.date)
      )
    )
