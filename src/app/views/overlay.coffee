React = require('react')

{div, a} = React.DOM

module.exports = React.createClass
  displayName: "OverlayContainer"
  getDefaultProps: ->
    active: false

  render: ->
    classes = React.addons.classSet
      'overlay-container': true,
      'active': @props.active

    (div {className: classes}, @props.children)
