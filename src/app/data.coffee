# # Singleton Holding ALL the Data
try
  snaps = JSON.parse(window.localStorage.snapshots)
  console.log "Got #{snaps.length} snapshots from local storage."
catch e
  snaps = []

module.exports = window.data =
  hasData: !!snaps.length
  snapshots: snaps
  _save: ->
    window.localStorage.snapshots = JSON.stringify(@snapshots)
  _clear: ->
    delete window.localStorage.snapshots
