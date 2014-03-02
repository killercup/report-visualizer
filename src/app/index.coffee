###!
# # Reporter Visualizer
#
# @copyright 2014 Pascal Hertleif
# @license MIT
###

React = require('react')
{section, div, p, a} = React.DOM

data = require('./data')

layout = React.createClass
  clearCache: ->
    data._clear()
    window.location.reload()

  render: ->
    if @props.hasData
      (section {id: 'main'},
        (div {}, 'data loaded')
        (require('./list') {snapshots: @props.snapshots})
        (p {}, [
          (a {onClick: @clearCache}, 'Clear Cache')
        ])
      )
    else
      (section {id: 'main'},
        (require('./loadFiles') {rerender: renderMain})
      )

renderMain = ->
  React.renderComponent(
    layout({snapshots: data.snapshots, hasData: data.hasData}),
    document.getElementById('container')
  )

renderMain()
