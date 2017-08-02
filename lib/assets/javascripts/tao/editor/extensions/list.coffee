{ Schema } = ProseMirrorModel
{ addListNodes, splitListItem, sinkListItem, liftListItem } = ProseMirrorSchemaList
{ chainCommands } = Tao.Editor.Helpers

Tao.Editor.ListExtension = ->

  @extendSchema (schema) ->
    new Schema
      nodes: addListNodes(schema.spec.nodes, 'paragraph block*', 'block')
      marks: schema.spec.marks

  @extendKeymaps ->
    'Enter': chainCommands(
      keymaps['Enter'],
      splitListItem('bullet_list'),
      splitListItem('ordered_list')
    )
    'Tab': chainCommands(keymaps['Tab'], sinkListItem)
    'Shift-Tab': chainCommands(keymaps['Tab'], liftListItem)
