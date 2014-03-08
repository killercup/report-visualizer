###!
# # Reporter Visualizer
#
# @copyright 2014 Pascal Hertleif
# @license MIT
###

React = require('react')
{section, div, h1, p, a} = React.DOM

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
    views = [
      (div {key: 'top-bar', className: 'top-bar'}, [
        (h1 {key: 'title'}, "Reporter Report Analyser")
      ])
    ]

    if @state.hasData
      views = views.concat [
        (section {key: 'meta', className: 'box meta'}, [
          (p {}, [
            "#{@props.snapshots.length} snapshots loaded. "
            (a {key: "clearCache", href: '#clear', onClick: @clearCache}, "Clear Cache")
          ])
        ])
        (require('./views/charts') {key: 'charts', snapshots: @props.snapshots})
      ]
    else
      views = views.concat [
        (require('./loadFiles') {key: 'loadFiles', gotData: @gotData})
      ]

    (section {className: 'main'}, views)

renderMain = ->
  React.renderComponent(
    layout({snapshots: data.snapshots}),
    document.getElementById('container')
  )

renderMain()
