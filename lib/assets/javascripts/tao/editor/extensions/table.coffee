{ Schema } = ProseMirrorModel
{ addTableNodes } = ProseMirrorSchemaTable

Tao.Editor.TableExtension = ->

  @extendSchema (schema) ->
    new Schema
      nodes: addTableNodes schema.spec.nodes, 'inline<_>*', 'block'
      marks: schema.spec.marks

_.extend Tao.Editor.Commands,

  addColumnBefore: ProseMirrorSchemaTable.addColumnBefore

  addColumnAfter: ProseMirrorSchemaTable.addColumnAfter

  removeColumn: ProseMirrorSchemaTable.removeColumn

  addRowBefore: ProseMirrorSchemaTable.addRowBefore

  addRowAfter: ProseMirrorSchemaTable.addRowAfter

  removeRow: ProseMirrorSchemaTable.removeRow

  selectNextCell: ProseMirrorSchemaTable.selectNextCell

  selectPreviousCell: ProseMirrorSchemaTable.selectPreviousCell
