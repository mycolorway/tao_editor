class Tao.Editor.Toolbar.CommandItem extends Tao.Editor.Toolbar.BaseItem

  @tag 'tao-editor-toolbar-command-item'

  @attribute 'commandName'

  _connected: ->
    super
    @command = Tao.Editor.Commands[@commandName] if @commandName

  _disconnected: ->
    super
    @command = null

  _onClick: ->
    @command?(@editorView.state, @editorView.dispatch, @editorView)
    @editorView.focus()

  _updateDisabled: ->
    if _.isFunction @command
      @disabled = !@command(@editorView.state, null, @editorView)

TaoComponent.register Tao.Editor.Toolbar.CommandItem
