import _ from 'lodash'
import BaseItem from './base'
import Commands from '../../commands'

class CommandItem extends BaseItem

  @tag 'tao-editor-toolbar-command-item'

  @attribute 'commandName'

  _connected: ->
    super()
    @command = Commands[@commandName] if @commandName

  _disconnected: ->
    super()
    @command = null

  _onClick: ->
    @command?(@editorView.state, @editorView.dispatch, @editorView)
    @editorView.focus()

  _updateDisabled: ->
    if _.isFunction @command
      @disabled = !@command(@editorView.state, null, @editorView)

export default CommandItem.register()
