#= require ./commands

{ Schema } = ProseMirrorModel
{ addListNodes, splitListItem, sinkListItem, liftListItem } = ProseMirrorSchemaList
{ deleteSelection, joinBackward, joinForward, selectNodeBackward } = ProseMirrorCommands
{ joinBackwardInList, joinForwardInList, liftEmptyListItem } = Tao.Editor.Commands
{ chainCommands } = Tao.Editor.Helpers

Tao.Editor.ListExtension = ->

  @extendSchema (schema) ->
    new Schema
      nodes: addListNodes(schema.spec.nodes, 'paragraph+ (bullet_list | ordered_list)?', 'block')
      marks: schema.spec.marks

  @extendKeymaps (keymaps) ->
    backspace = chainCommands(deleteSelection, joinBackwardInList, joinBackward, selectNodeBackward)
    del = chainCommands(deleteSelection, joinForwardInList, joinForward, selectNodeBackward)
    'Enter': chainCommands(
      splitListItem(@schema.nodes.list_item),
      liftEmptyListItem,
      keymaps['Enter']
    )
    'Backspace': backspace
    'Mod-Backspace': backspace
    'Delete': del
    'Mod-Delete': del
    'Tab': chainCommands(sinkListItem(@schema.nodes.list_item), keymaps['Tab'])
    'Shift-Tab': chainCommands(liftListItem(@schema.nodes.list_item), keymaps['Tab'])
