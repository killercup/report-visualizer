React = require('react')

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
      x: if typeof @props.x is 'undefined' then @props.offset else @props.x
      y: if typeof @props.y is 'undefined' then (@props.availableHeight - @props.height) else @props.y
      title: @props.title
      fill: @props.fill
    }, [])
