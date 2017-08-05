class Tao.Editor.Toolbar.Element extends TaoComponent

  @tag 'tao-editor-toolbar'

  _connected: ->
    @items = @findComponent '.tao-editor-toolbar-item'

  _disconnected: ->
    @off()

  setEditorView: (editorView) ->
    @editorView = editorView
    @items.forEach (item) =>
      Tao.helpers.componentReady item, ->
        item.setEditorView editorView

  # called by editor view
  update: (prevState) ->
    @items.forEach (item) -> item.update(prevState)

  # called by editor view
  reset: ->
    @editorView = null
    @items.forEach (item) -> item.reset()

TaoComponent.register Tao.Editor.Toolbar.Element
