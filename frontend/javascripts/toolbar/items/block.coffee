import _ from 'lodash'
import CommandItem from './command'
import Commands from '../../commands'

class BlockItem extends CommandItem

  @tag 'tao-editor-toolbar-block-item'

  @attribute 'blockName'

  @attribute 'blockAttrs', type: 'hash'

  setEditorView: (editorView) ->
    super editorView
    @blockType = editorView.state.schema.nodes[@blockName]
    @command = Commands.setBlockType @blockType, @blockAttrs

  reset: ->
    super()
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

export default BlockItem.register()
