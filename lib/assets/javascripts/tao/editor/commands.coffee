{ NodeSelection } = ProseMirrorState

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
        attrs = _.extend {}, target.attrs, attrs if target.type == nodeType
        where = $from.before(depth + 1)
        tr = state.tr
          .clearNonMatching(where, nodeType.contentExpr.start(attrs))
          .setNodeType(where, nodeType, attrs)
          .scrollIntoView()
        dispatch tr

      return true
}
