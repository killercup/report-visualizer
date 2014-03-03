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
  getInitialState: ->
    hasData: !!data.hasData

  gotData: ->
    @replaceProps snapshots: data.snapshots
    @setState hasData: true

  clearCache: ->
    data._clear()
    window.location.reload()

  render: ->
    if @state.hasData
      (section {id: 'main'}, [
        (p {}, "#{@props.snapshots?.length} snapshots loaded.")
        (require('./views/stacks') {snapshots: @props.snapshots})
        (p {}, [
          (a {onClick: @clearCache}, 'Clear Cache')
        ])
      ])
    else
      (section {id: 'main'},
        (require('./loadFiles') {gotData: @gotData})
      )

renderMain = ->
  React.renderComponent(
    layout({snapshots: data.snapshots}),
    document.getElementById('container')
  )

renderMain()
