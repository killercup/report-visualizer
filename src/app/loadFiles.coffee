_ = require('highland')
React = require('react')

{div, p, input} = React.DOM

data = require('./data')

loadJSONViaFileAPI = (err, file, push, next) ->
  if err
    push(err)
    return next()

  if file is _.nil
    return push(null, file)

  reader = new window.FileReader()
  reader.onload = (event) ->
    try
      fileContent = JSON.parse event.target.result
      push(null, fileContent)
      next()
    catch e
      next new Error('Error parsing', file.name)

  reader.onerror = ->
    next new Error('Error reading file', file.name)

  reader.onabort = ->
    next new Error('Aborted reading file', file.name)

  reader.readAsText(file)
  return

module.exports = React.createClass
  loadFiles: (event) ->
    event.preventDefault()
    files = event.target.files
    return console.log("No files") unless files?.length

    _(Array.prototype.slice.call(files))
    .consume loadJSONViaFileAPI
    .reduce [], (memo, val) ->
      memo.concat val.snapshots
    .errors (err, push) ->
      console.error err
    .toArray ([items]) =>
      try
        data.hasData = true
        data.snapshots = items
        data._save()
        @props.gotData()
      catch e
        console.error e.stack

  render: ->
    (div {className: 'load-files'},
      (p {},
        (input {type: 'file', multiple: true, onChange: @loadFiles})
      )
    )
