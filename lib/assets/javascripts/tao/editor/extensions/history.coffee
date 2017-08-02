{ history, undo, redo } = ProseMirrorHistory
{ isMac } = Tao.Editor.Helpers

Tao.Editor.HistoryExtension = ->

  @extendKeymaps ->
    maps =
      'Mod-z': undo
      'Shift-Mod-z': redo
    maps['Mod-y'] = redo unless isMac()
    maps

  @extendPlugins ->
    history()
