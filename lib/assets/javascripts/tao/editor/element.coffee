{ EditorState } = ProseMirrorState
{ EditorView, Decoration, DecorationSet } = ProseMirrorView
{ DOMParser, Node, DOMSerializer } = ProseMirrorModel
{ baseKeymap } = ProseMirrorCommands
{ keymap } = ProseMirrorKeymap

class Tao.Editor.Element extends Tao.Component

  @extend Tao.Editor.ExtensionBase
  @include Tao.Editor.AlignmentExtension
  @include Tao.Editor.HistoryExtension
  @include Tao.Editor.ListExtension
  @include Tao.Editor.TableExtension
  @include Tao.Editor.ToolbarExtension

  @tag 'tao-editor'

  @attribute 'placeholder'

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
      plugin = callback.call(@)
      @plugins = _.concat(@plugins, plugin) if plugin
    @plugins

  _buildKeymaps: ->
    @keymaps = _.extend {}, baseKeymap
    @constructor._keymapCallbacks.forEach (callback) =>
      _.extend @keymaps, callback.call(@, @keymaps)
    @keymaps

  _buildState: ->
    options = plugins: @plugins

    if value = @field.val()
      content = $('<div>').html(value).get(0)
      options.doc = DOMParser.fromSchema(@schema).parse(content)
    else
      options.schema = @schema

    EditorState.create options

  _buildView: ->
    new EditorView @,
      state: @state
      decorations: @_generateDecorations.bind(@)
      dispatchTransaction: @_dispatchTransaction.bind(@)
      attributes:
        class: 'tao-editor-body'

  _dispatchTransaction: (transaction) ->
    @state = @state.apply(transaction)
    @view.updateState @state
    @_syncValue()
    @namespacedTrigger 'change'

  _generateDecorations: (state) ->
    doc = state.doc
    decorations = []
    if @placeholder && doc.childCount == 1 && doc.firstChild.isTextblock &&
        doc.firstChild.content.size == 0
      placeholderNode = $('<span>', placeholder: @placeholder).get(0)
      decorations.push Decoration.widget(1, placeholderNode)
    DecorationSet.create(doc, decorations) if decorations.length > 0

  _syncValue: ->
    serializer = DOMSerializer.fromSchema(@schema)
    fragment = serializer.serializeFragment(@view.state.doc.content)
    @field.val $('<div>').append(fragment).html()

Tao.Component.register Tao.Editor.Element
