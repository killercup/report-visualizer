React = require('react')

{div, a} = React.DOM

module.exports = React.createClass
  getDefaultProps: ->
    active: false

  render: ->
    classes = React.addons.classSet
      'overlay-container': true,
      'active': @props.active

    (div {className: classes}, @props.children)
