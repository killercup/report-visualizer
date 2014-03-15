React = require('react')
{div, h2, p, a, code} = React.DOM

LoadFiles = require('../reporter/loadFiles')

module.exports = React.createClass
  displayName: 'StartView'
  render: ->
    (div {className: 'box text-box load-files'}, [
      (h2 {key: 'headline'}, "Display your reports")
      (p {key: 'info'}, [
        """This tool can display the data exported by """
        (a {key: 'rep', href: 'http://www.reporter-app.com/'}, "Reporter App")
        """ in your browser."""
      ])
      (p {key: 'help'}, [
        """Just select all the files Reporter saved to your Dropbox. They are probably
        in a folder called """
        (code {key: 'code'}, "~/Dropbox/Apps/Reporter-App")
        "."
      ])
      (p {key: 'server-info'}, """
        Your data will not be uploaded to any server, it will only be
        stored and processed by the browser you are currently using.
      """)
      if window.FileReader
        (p {key: 'input', className: 'upload-area'}, [
          (LoadFiles {key: 'loadFiles', gotData: @props.gotData})
        ])
      else
        (p {key: 'input', className: 'no-chance'}, [
          "Looks like your browser doesn't support reading files directly. "
          "That's a shame. Maybe you can update it."
        ])
    ])
