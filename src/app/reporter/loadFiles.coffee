l = require('lodash')
Q = require('q')
React = require('react')

{input, em} = React.DOM

data = require('../data')

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

  getInitialState: ->
    working: false

  loadFiles: (event) ->
    event.preventDefault()
    files = event.target.files
    return console.log("No files") unless files?.length

    @setState working: true

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
    if @state.working
      (em {className: 'loading'}, "Processing files...")
    else
      (input {type: 'file', multiple: true, onChange: @loadFiles})
