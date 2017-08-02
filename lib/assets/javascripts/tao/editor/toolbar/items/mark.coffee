class Tao.Editor.Toolbar.MarkItem extends Tao.Editor.Toolbar.CommandItem

  @tag 'tao-editor-toolbar-mark-item'

  @attribute 'markName'

  @attribute 'markAttrs', type: 'hash'

  setEditorView: (editorView) ->
    super
    @markType = editorView.state.marks[@markName]
    @command = Tao.Editor.Commands.toggleMark @markType, @markAttrs

  reset: ->
    super
    @markType = null

  _updateActive: ->
    {from, $from, to, empty} = @editorView.state.selection
    if empty
      @markType.isInSet(@editorView.state.storedMarks || $from.marks())
    else
      @editorView.state.doc.rangeHasMark(from, to, @markType)

TaoComponent.register Tao.Editor.Toolbar.MarkItem
