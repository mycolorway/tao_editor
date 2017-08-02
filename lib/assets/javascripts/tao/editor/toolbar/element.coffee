class Tao.Editor.Toolbar.Element extends TaoComponent

  @tag 'tao-editor-toolbar'

  @attribute 'floating', type: 'boolean'

  _connected: ->
    @items = @jq.find('.tao-editor-toolbar-item').get()

  _disconnected: ->
    @off()

  setEditorView: (editorView) ->
    @editorView = editorView
    @items.forEach (item) =>
      @constructor.componentReady item, ->
        item.setEditorView editorView

  # called by editor view
  update: (prevState) ->
    @items.forEach (item) -> item.update(prevState)

  # called by editor view
  reset: ->
    @editorView = null
    @items.forEach (item) -> item.reset()

TaoComponent.register Tao.Editor.Toolbar.Element
