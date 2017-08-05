#= require ./command

class Tao.Editor.Toolbar.ListItem extends Tao.Editor.Toolbar.CommandItem

  @tag 'tao-editor-toolbar-list-item'

  @attribute 'listName'

  setEditorView: (editorView) ->
    super
    @listType = editorView.state.schema.nodes[@listName]
    @command = Tao.Editor.Commands.wrapInList @listType

  reset: ->
    super
    @listType = null

  _updateActive: ->
    {$from, $to} = @editorView.state.selection
    blockRange = $from.blockRange $to, (node) =>
      node.type.name == @listName
    @active = !!blockRange

TaoComponent.register Tao.Editor.Toolbar.ListItem
