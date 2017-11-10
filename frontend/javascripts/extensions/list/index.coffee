import './commands'
import { Schema } from 'prosemirror-model'
import { addListNodes, splitListItem, sinkListItem, liftListItem } from 'prosemirror-schema-list'
import { deleteSelection, joinBackward, joinForward, selectNodeBackward } from 'prosemirror-commands'
import { joinBackwardInList, joinForwardInList, liftEmptyListItem } from '../../commands'
import helpers from '../../helpers'

export default ->

  @extendSchema (schema) ->
    new Schema
      nodes: addListNodes(schema.spec.nodes, 'paragraph+ (bullet_list | ordered_list)?', 'block')
      marks: schema.spec.marks

  @extendKeymaps (keymaps) ->
    backspace = helpers.chainCommands(deleteSelection, joinBackwardInList, joinBackward, selectNodeBackward)
    del = helpers.chainCommands(deleteSelection, joinForwardInList, joinForward, selectNodeBackward)
    'Enter': helpers.chainCommands(
      splitListItem(@schema.nodes.list_item),
      liftEmptyListItem,
      keymaps['Enter']
    )
    'Backspace': backspace
    'Mod-Backspace': backspace
    'Delete': del
    'Mod-Delete': del
    'Tab': helpers.chainCommands(sinkListItem(@schema.nodes.list_item), keymaps['Tab'])
    'Shift-Tab': helpers.chainCommands(liftListItem(@schema.nodes.list_item), keymaps['Tab'])
