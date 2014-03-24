React = require('react')
{header, div, h1, a, img} = React.DOM

module.exports = React.createClass
  displayName: 'TopBar'
  render: ->
    (header {key: 'top-bar', className: 'top-bar'}, [
      (div {key: 'r', className: 'right'}, [
        (a {
          key: 'flattr', className: 'flattr',
          href: 'http://flattr.com/thing/2729835/'
        }, "Flattr this")
        (a {
          key: 'gh', className: 'gh',
          href: 'https://github.com/killercup/report-visualizer'
        }, "Source Code on Github")
      ])
      (h1 {key: 'title'}, "Report Visualizer")
    ])
