import CommandItem from './command'
import Commands from '../../commands'

class ListItem extends CommandItem

  @tag 'tao-editor-toolbar-list-item'

  @attribute 'listName'

  setEditorView: (editorView) ->
    super editorView
    @listType = editorView.state.schema.nodes[@listName]
    @command = Commands.wrapInList @listType

  reset: ->
    super()
    @listType = null

  _updateActive: ->
    {$from, $to} = @editorView.state.selection
    blockRange = $from.blockRange $to, (node) =>
      node.type.name == @listName
    @active = !!blockRange

export default ListItem.register()
