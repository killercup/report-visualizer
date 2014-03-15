React = require('react')
{div, h1, a, img} = React.DOM

module.exports = React.createClass
  displayName: 'TopBar'
  render: ->
    (div {key: 'top-bar', className: 'top-bar'}, [
      (div {key: 'r', className: 'right'}, [
        (a {
          key: 'flattr', className: 'flattr',
          href: 'http://flattr.com/thing/2729835/'
        }, [
          (img {
            key: 'img',
            src: 'http://api.flattr.com/button/flattr-badge-large.png'
          })
        ])
        (a {
          key: 'gh', className: 'gh',
          href: 'https://github.com/killercup/report-visualizer'
        }, "Fork this on Github")
      ])
      (h1 {key: 'title'}, "Report Visualizer")
    ])
