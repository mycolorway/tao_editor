import CommandItem from './command'
import Commands from '../../commands'

class MarkItem extends CommandItem

  @tag 'tao-editor-toolbar-mark-item'

  @attribute 'markName'

  @attribute 'markAttrs', type: 'hash'

  setEditorView: (editorView) ->
    super editorView
    @markType = editorView.state.schema.marks[@markName]
    @command = Commands.toggleMark @markType, @markAttrs

  reset: ->
    super()
    @markType = null

  _updateActive: ->
    {from, $from, to, empty} = @editorView.state.selection
    @active = if empty
      @markType.isInSet(@editorView.state.storedMarks || $from.marks())
    else
      @editorView.state.doc.rangeHasMark(from, to, @markType)

export default MarkItem.register()
