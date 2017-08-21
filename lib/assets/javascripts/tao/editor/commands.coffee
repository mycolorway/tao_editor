{ NodeSelection, TextSelection } = ProseMirrorState
{ insertPoint } = ProseMirrorTransform
{ Fragment } = ProseMirrorModel

Tao.Editor.Commands = _.extend {}, ProseMirrorCommands, {

  setBlockType: (nodeType, attrs) ->
    (state, dispatch) ->
      {$from, $to} = state.selection
      if state.selection instanceof NodeSelection
        depth = $from.depth
        target = state.selection.node
      else
        return false if !$from.depth || $to.pos > $from.end()
        depth = $from.depth - 1
        target = $from.parent

      return false if !target.isTextblock || target.hasMarkup(nodeType, attrs)
      index = $from.index(depth)
      return false if !$from.node(depth).canReplaceWith(index, index + 1, nodeType)

      if dispatch
        attrs = if target.type == nodeType
          _.extend {}, target.attrs, attrs
        else if target.isTextblock && nodeType.isTextblock
          _.extend {align: target.attrs.align}, attrs
        where = $from.before(depth + 1)
        tr = state.tr
          .clearNonMatching(where, nodeType.contentExpr.start(attrs))
          .setNodeType(where, nodeType, attrs)
          .scrollIntoView()
        dispatch tr

      return true

  insertHr: (state, dispatch) ->
    hrType = state.schema.nodes.horizontal_rule
    { $cursor } = state.selection
    return false unless $cursor
    insertPos = insertPoint(state.doc, $cursor.pos, hrType)
    return false unless _.isNumber insertPos

    if dispatch
      nodes = []
      nodes.push hrType.createAndFill()
      $insertPos = state.doc.resolve insertPos
      unless $insertPos.nodeAfter
        nodes.push state.schema.nodes.paragraph.createAndFill()

      tr = state.tr.insert insertPos, Fragment.from(nodes)
      tr = tr.setSelection TextSelection.create(tr.doc, insertPos + 2)
        .scrollIntoView()
      dispatch tr

    true

}
