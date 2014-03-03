React = require('react')

{svg} = React.DOM

module.exports = React.createClass
  getDefaultProps: ->
    width: 0
    height: 0

  render: ->
    (svg {width: @props.width, height: @props.height}, @props.children)
