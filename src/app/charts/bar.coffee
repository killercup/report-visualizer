React = require('react')
l = require('lodash')

{rect} = React.DOM

module.exports = React.createClass
  displayName: "Bar"

  getDefaultProps: ->
    width: 0
    height: 0
    availableHeight: 0
    offset: 0
    title: ''
    fill: '#ccc'

  render: ->
    (rect {
      width: @props.width
      height: @props.height
      x: if l.isUndefined(@props.x) then @props.offset else @props.x
      y: if l.isUndefined(@props.y) then (@props.availableHeight - @props.height) else @props.y
      title: @props.title
      fill: @props.fill
    }, [])
