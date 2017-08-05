{ Schema } = ProseMirrorModel
{ schema: basicSchema } = ProseMirrorSchemaBasic


nodes = basicSchema.spec.nodes

marks = basicSchema.spec.marks
marks = marks.addBefore 'em', 'u',
  parseDOM: [{ tag: 'u' }]
  toDOM: -> ['u']

Tao.Editor.schema = new Schema {nodes, marks}
