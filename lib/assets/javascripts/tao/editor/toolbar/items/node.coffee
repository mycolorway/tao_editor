class Tao.Editor.Toolbar.BlockItem extends Tao.Editor.Toolbar.CommandItem

  @tag 'tao-editor-toolbar-block-item'

  @attribute 'blockName'

  @attribute 'blockAttrs', type: 'hash'

  setEditorView: (editorView) ->
    super
    @blockType = editorView.state.nodes[@blockName]
    @command = Tao.Editor.Commands.setBlockType @blockType, @blockAttrs

  reset: ->
    super
    @blockType = null

  _updateActive: ->
    {$from, to, node} = @editorView.state.selection
    if node
      node.hasMarkup(@blockType, @blockAttrs)
    else
      to <= $from.end() && $from.parent.hasMarkup(@blockType, @blockAttrs)

TaoComponent.register Tao.Editor.Toolbar.BlockItem
