###!
# # Reporter Visualizer
#
# @copyright 2014 Pascal Hertleif
# @license MIT
###

React = require('react')
{section, div, h1, h2, p, a, code, img} = React.DOM

data = require('./data')

layout = React.createClass
  displayName: "Layout"
  getInitialState: ->
    hasData: !!data.hasData

  gotData: ->
    @replaceProps snapshots: data.snapshots
    @setState hasData: true

  clearCache: (event) ->
    event.preventDefault()
    data._clear()
    window.location.reload()

  render: ->
    (section {className: 'main'}, [
      (require('./views/header') {key: 'header'})
      if @state.hasData then [
        (section {key: 'meta', className: 'box meta'}, [
          (p {key: 'meta-p'}, [
            "#{@props.snapshots.length} snapshots loaded. "
            (a {key: "clearCache", href: '#clear', onClick: @clearCache}, "Clear Cache")
          ])
        ])
        (require('./views/charts') {key: 'charts', snapshots: @props.snapshots})
      ] else [
        (require('./views/start') {key: 'start', gotData: @gotData})
      ]
    ])

renderMain = ->
  React.renderComponent(
    (layout {snapshots: data.snapshots}),
    document.getElementById('container')
  )

renderMain()
