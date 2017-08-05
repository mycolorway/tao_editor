{ EditorState } = ProseMirrorState
{ EditorView } = ProseMirrorView
{ DOMParser, Node } = ProseMirrorModel
{ baseKeymap } = ProseMirrorCommands
{ keymap } = ProseMirrorKeymap

class Tao.Editor.Element extends Tao.Component

  @extend Tao.Editor.ExtensionBase
  @include Tao.Editor.AlignmentExtension
  @include Tao.Editor.HistoryExtension
  @include Tao.Editor.ListExtension
  @include Tao.Editor.ToolbarExtension

  @tag 'tao-editor'

  @get 'value', ->
    if val = @field.val()
      JSON.parse val
    else
      ''
  _connected: ->
    @field = @jq.find('> input:hidden')
    @schema = @_buildSchema()
    @keymaps = @_buildKeymaps()
    @plugins = @_buildPlugins()
    @state = @_buildState()
    @view = @_buildView()
    @body = $ @view.dom

  _disconnected: ->
    @view.destroy()

  _buildSchema: ->
    @schema = Tao.Editor.schema
    @constructor._schemaCallbacks.forEach (callback) =>
      @schema = callback.call(@, @schema)
    @schema

  _buildPlugins: ->
    @plugins = [keymap(@keymaps)]
    @constructor._pluginCallbacks.forEach (callback) =>
      @plugins = _.concat @plugins, callback.call(@)
    @plugins

  _buildKeymaps: ->
    @keymaps = _.extend {}, baseKeymap
    @constructor._keymapCallbacks.forEach (callback) =>
      _.extend @keymaps, callback.call(@, @keymaps)
    @keymaps

  _buildState: ->
    options = plugins: @plugins

    if value = @field.val()
      option.doc = Node.fromJSON schema, JSON.parse(value)
    else
      options.schema = @schema

    EditorState.create options

  _buildView: ->
    new EditorView @,
      state: @state
      dispatchTransaction: @_dispatchTransaction.bind(@)
      attributes:
        class: 'tao-editor-body'

  _dispatchTransaction: (transaction) ->
    @state = @state.apply(transaction)
    @view.updateState @state
    @_syncValue()
    @namespacedTrigger 'change'

  _syncValue: ->
    console.log @state.doc.toJSON()
    @field.val @state.doc.toJSON()

Tao.Component.register Tao.Editor.Element
