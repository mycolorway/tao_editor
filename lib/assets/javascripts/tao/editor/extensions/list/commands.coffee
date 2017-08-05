{ joinPoint } = ProseMirrorTransform
{ liftListItem, wrapInList } = ProseMirrorSchemaList
{ TextSelection } = ProseMirrorState
{ setBlockType } = ProseMirrorCommands

_.extend Tao.Editor.Commands,

  wrapInList: (listType) ->
    (state, dispatch) ->
      {$from, $to} = state.selection
      blockRange = $from.blockRange $to, (node) ->
        node.type.name in ['bullet_list', 'ordered_list']

      if blockRange
        if listType.name != blockRange.parent.type.name
          $listStart = state.doc.resolve(blockRange.start)
          tr = state.tr.setNodeType($listStart.before(), listType)
            .scrollIntoView()
          dispatch? tr
          true
        else
          # TODO: unwrap list
          true
      else
        wrapInList(listType)(state, dispatch)

  joinBackwardInList: (state, dispatch) ->
    { $from } = state.selection
    if $from.depth >= 3 && $from.parent.type.name == 'paragraph' &&
        (grandParent = $from.node(-1)).type.name == 'list_item' &&
        $from.parentOffset == 0
      if $from.node(-2).childCount < 2
        joinPos = $from.before(-2)
        tr = state.tr.delete joinPos, $from.after(-2)
      else
        joinPos = $from.before(-1)
        tr = state.tr.delete joinPos, $from.after(-1)

      $joinPos = tr.doc.resolve joinPos
      while (joinPos > 0 && $joinPos.nodeBefore?.type.name != 'paragraph')
        joinPos -= 1
        $joinPos = state.doc.resolve joinPos

      if joinPos > 0
        tr = tr.insert(joinPos, grandParent.content).join joinPos
        tr = tr.setSelection new TextSelection(tr.doc.resolve joinPos - 1)
          .scrollIntoView()
        dispatch? tr
        return true
    return false

  joinForwardInList: (state, dispatch) ->
    Tao.Editor.Commands.joinForward state, dispatch && (tr) ->
      {$from} = tr.selection
      grandParent = $from.node(-1)
      if $from.depth >= 3 && $from.parent.type.name == 'paragraph' &&
          grandParent.type.name == 'list_item' &&
          $from.parentOffset == $from.parent.content.size &&
          grandParent.childCount > $from.index()
        tr = tr.join $from.after()
      dispatch? tr

  liftEmptyListItem: (state, dispatch) ->
    {$cursor} = state.selection
    return false if _.isNull($cursor) || $cursor.parent.content.size > 0
    grandParent = $cursor.node(-1)
    return false unless $cursor.depth > 3 && $cursor.parent.type.name == 'paragraph' && grandParent.type.name == 'list_item'
    if $cursor.index(-2) + 1 == $cursor.node(-2).childCount
      return liftListItem(grandParent.type)(state, dispatch)
    else
      pos = $cursor.after(-1)
      tr = state.tr.insert pos, grandParent.type.createAndFill()
      tr.setSelection TextSelection.create(tr.doc, pos + 1)
      dispatch? tr.scrollIntoView()
      return true
