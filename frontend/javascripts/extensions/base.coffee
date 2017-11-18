export default

  _schemaCallbacks: []
  extendSchema: (callback) ->
    @_schemaCallbacks.push callback

  _pluginCallbacks: []
  extendPlugins: (callback) ->
    @_pluginCallbacks.push callback

  _keymapCallbacks: []
  extendKeymaps: (callback) ->
    @_keymapCallbacks.push callback
