import { Schema } from 'prosemirror-model'
import { schema as basicSchema } from 'prosemirror-schema-basic'


nodes = basicSchema.spec.nodes

marks = basicSchema.spec.marks
marks = marks.addBefore 'em', 'u',
  parseDOM: [{ tag: 'u' }]
  toDOM: -> ['u']

export default new Schema {nodes, marks}
