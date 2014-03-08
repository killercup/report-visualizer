l = require('lodash')
Q = require('q')
React = require('react')

{div, p, code, input} = React.DOM

data = require('./data')

loadJSONViaFileAPI = (file) ->
  deferred = Q.defer()

  reader = new window.FileReader()
  reader.onload = (event) ->
    try
      fileContent = JSON.parse event.target.result
      deferred.resolve fileContent
    catch e
      e.message = "Error parsing #{file.name}"
      deferred.reject(e)

  reader.onerror = ->
    deferred.reject new Error("Error reading file #{file.name}")

  reader.onabort = ->
    deferred.reject new Error("Aborted reading file #{file.name}")

  reader.readAsText(file)
  return deferred.promise

module.exports = React.createClass
  displayName: "LoadFiles"
  loadFiles: (event) ->
    event.preventDefault()
    files = event.target.files
    return console.log("No files") unless files?.length

    Q.all l.map files, loadJSONViaFileAPI
    .then (files) =>
      items = l(files)
        .map (file) -> file.snapshots
        .flatten()
        .value()
      try
        data.hasData = true
        data.snapshots = items
        data._save()
        @props.gotData()
      catch e
        console.error e.stack
    .fail (err) ->
      window.alert "Failed to load files."
      console.error err

  render: ->
    (div {className: 'box load-files'},
      (p {key: 'help'}, [
        """Just select all the files Reporter saved to your Dropbox. They are probably
        in a folder called """
        (code {}, "~/Dropbox/Apps/Reporter-App")
        "."
      ])
      (p {key: 'server-info'}, """
        Your data will not be uploaded to any server, it will only be
        stored and processed by the browser you are currently using.
      """)
      (p {key: 'input'},
        (input {type: 'file', multiple: true, onChange: @loadFiles})
      )
    )
