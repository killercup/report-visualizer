React = require('react')

{g, rect, text} = React.DOM

module.exports = React.createClass
  displayName: "Tooltip"
  getDefaultProps: ->
    x: 0
    y: 0
    label: ""

  render: ->
    (g {
      className: 'tooltip',
      transform: "translate(#{@props.x},#{@props.y})"
    }, [
      (rect {
        key: 'bg',
        className: "tooltip-bg",
        x: -13, y: -14,
        rx: 5, ry: 5,
        height: 20,
        width: 10 + (@props.label.length * 6) + 10
      })
      (text {
        key: 'label',
        className: "tooltip-label",
        ref: "label",
        children: @props.label
      })
    ])
