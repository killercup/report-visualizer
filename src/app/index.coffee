###!
# # Reporter Visualizer
#
# @copyright 2014 Pascal Hertleif
# @license MIT
###

React = require('react')
{section, aside, div, h1, h2, p, a, code, img} = React.DOM

data = require('./data')

layout = React.createClass
  displayName: "Layout"
  getInitialState: ->
    hasData: !!data.hasData

  gotData: ->
    @replaceProps snapshots: data.snapshots.get()
    @setState hasData: true

  clearCache: (event) ->
    event.preventDefault()
    data.snapshots.clear()
    window.location.reload()

  render: ->
    (section {className: 'main'}, [
      (require('./views/header') {key: 'header'})
      if @state.hasData then [
        (require('./views/stats') {
          key: 'stats',
          snapshots: @props.snapshots, clearCache: @clearCache
        })
        (div {key: 'm', id: 'content'}, [
          (aside {key: 'a'}, [
            (require('./views/toc') {key: 'toc', snapshots: @props.snapshots})
          ])
          (require('./views/charts') {
            key: 'charts', snapshots: @props.snapshots
          })
        ])
      ] else [
        (require('./views/start') {
          key: 'start', gotData: @gotData
        })
      ]
    ])

renderMain = ->
  React.renderComponent(
    (layout {snapshots: data.snapshots.get()}),
    document.getElementById('container')
  )

renderMain()
