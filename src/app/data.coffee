# # Singleton Holding ALL the Data

try
  snaps = JSON.parse(window.sessionStorage.snapshots)
  console.log "Got #{snaps.length} snapshots from local storage."
catch e
  snaps = []

module.exports = window.data =
  hasData: !!snaps.length
  snapshots: snaps
  _save: ->
    window.sessionStorage.snapshots = JSON.stringify(@snapshots)
  _clear: ->
    delete window.sessionStorage.snapshots
