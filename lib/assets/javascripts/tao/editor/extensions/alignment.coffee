{ Schema } = ProseMirrorModel
{ orderedMapMerge } = Tao.Editor.Helpers

Tao.Editor.AlignmentExtension = ->

  @extendSchema (schema) ->
    nodes = orderedMapMerge schema.spec.nodes, 'paragraph',
      attrs:
        align:
          default: 'left'
      parseDOM: [{
        tag: 'p'
        getAttrs: (node) -> {align: node.style.textAlign || 'left'}
      }]
      toDOM: (node) -> ["p", {style: "text-align: #{node.attrs.align};"}, 0]

    nodes = orderedMapMerge nodes, 'heading',
      attrs:
        level:
          default: 1
        align:
          default: 'left'
      parseDOM: [1..6].map (i) ->
        tag: "h#{i}", attrs: {level: i}
        getAttrs: (node) -> {align: node.style.textAlign || 'left', level: i}
      toDOM: (node) -> ["h#{node.attrs.level}", {style: "text-align: #{node.attrs.align};"}, 0]

    new Schema
      nodes: nodes
      marks: schema.spec.marks


_.extend Tao.Editor.Commands,

  setAlignment: (align) ->
    (state, dispatch) ->
      {$from, $to} = state.selection
      range = $from.blockRange($to)
      textblocks = []
      state.doc.nodesBetween range.start, range.end, (node, pos) ->
        textblocks.push([node, pos]) if node.isTextblock
      return false unless textblocks.length > 0

      if dispatch
        tr = state.tr
        textblocks.forEach (textblock) ->
          [node, pos] = textblock
          attrs = _.extend {}, node.attrs, align: align
          tr = tr.setNodeType pos, node.type, attrs
        dispatch tr

      true
