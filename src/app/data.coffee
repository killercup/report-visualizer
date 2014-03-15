###
# # Singleton Holding ALL the Data
###

###
# ## Generic Data Saving Mechanism
###
savingBucket = (name, storage='localStorage', initial={}) ->
  try
    data = JSON.parse(window[storage][name])
  catch e
    data = initial

  # Saving new data is throttled
  save = do ->
    update = null
    _save = ->
      window[storage][name] = JSON.stringify(data)

    return ->
      window.clearTimeout(update)
      update = window.setTimeout _save, 16

  get = ->
    data

  set = (key, val) ->
    data[key] = val
    save()

  setAll = (values) ->
    data = values
    save()

  clear = ->
    delete window[storage][name]

  return {
    get:    get
    set:    set
    setAll: setAll
    clear:  clear
  }


module.exports = window.data =
  snapshots: savingBucket('snapshots', 'sessionStorage', [])
  chartSettings: savingBucket('chartSettings', 'localStorage', {})

module.exports.hasData = module.exports.snapshots.get().length
