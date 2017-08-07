#= require ./command

class Tao.Editor.Toolbar.BlockItem extends Tao.Editor.Toolbar.CommandItem

  @tag 'tao-editor-toolbar-block-item'

  @attribute 'blockName'

  @attribute 'blockAttrs', type: 'hash'

  setEditorView: (editorView) ->
    super
    @blockType = editorView.state.schema.nodes[@blockName]
    @command = Tao.Editor.Commands.setBlockType @blockType, @blockAttrs

  reset: ->
    super
    @blockType = null

  _updateActive: ->
    return if @blockName == 'paragraph'
    {$from, to, node} = @editorView.state.selection
    @active = if node
      node.hasMarkup(@blockType, @blockAttrs)
    else
      attrs = if @blockType == $from.parent.type
        _.extend {}, $from.parent.attrs, @blockAttrs
      else
        @blockAttrs
      to <= $from.end() && $from.parent.hasMarkup(@blockType, attrs)

TaoComponent.register Tao.Editor.Toolbar.BlockItem
