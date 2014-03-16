l = require('lodash')
s = require('underscore.string')
React = require('react')

{nav, a, p} = React.DOM

module.exports = React.createClass
  displayName: 'TOCView'
  render: ->
    questions = l(@props.snapshots)
      .pluck('responses')
      .flatten()
      .pluck('questionPrompt')
      .unique()
      .sort()
      .value()

    (nav {className: 'toc'}, [
      (p {key: 'h', className: 'subtitle'},
        "#{questions.length} Questions"
      )
      questions.map (q) ->
        slug = s.slugify q
        (a {key: slug, href: "##{slug}"}, q)
    ])
