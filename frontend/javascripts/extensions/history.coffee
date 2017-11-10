import { history, undo, redo } from 'prosemirror-history'
import helpers from '../helpers'

export default ->

  @extendKeymaps ->
    maps =
      'Mod-z': undo
      'Shift-Mod-z': redo
    maps['Mod-y'] = redo unless helpers.isMac()
    maps

  @extendPlugins ->
    history()
