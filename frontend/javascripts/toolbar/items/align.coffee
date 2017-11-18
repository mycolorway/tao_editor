import CommandItem from './command'
import Commands from '../../commands'

class AlignItem extends CommandItem

  @tag 'tao-editor-toolbar-align-item'

  @attribute 'alignment'

  setEditorView: (editorView) ->
    super editorView
    @command = Commands.setAlignment @alignment

  _updateActive: ->
    return if @alignment == 'left'
    {$from, to, node} = @editorView.state.selection
    @active = to <= $from.end() && $from.parent.attrs?.align == @alignment

export default AlignItem.register()
