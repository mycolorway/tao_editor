{ Schema } = ProseMirrorModel

Tao.Editor.AlignmentExtension = ->

  @extendSchema (schema) ->
    nodes = schema.spec.nodes.update 'paragraph',
      content: 'inline<_>*'
      attrs: {align: {default: 'left'}}
      group: 'block'
      parseDOM: [{
        tag: 'p',
        getAttrs: (node) -> {align: node.style.textAlign || 'left'}
      }]
      toDOM: (node) -> ["p", {style: "text-align: #{node.attrs.align};"}, 0]

    new Schema
      nodes: nodes
      marks: schema.spec.marks
