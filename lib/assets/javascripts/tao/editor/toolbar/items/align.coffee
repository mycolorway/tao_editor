#= require ./command

{ setAlignment } = Tao.Editor.Commands

class Tao.Editor.Toolbar.AlignItem extends Tao.Editor.Toolbar.CommandItem

  @tag 'tao-editor-toolbar-align-item'

  @attribute 'alignment'

  setEditorView: (editorView) ->
    super
    @command = setAlignment @alignment

  _updateActive: ->
    return if @alignment == 'left'
    {$from, to, node} = @editorView.state.selection
    @active = to <= $from.end() && $from.parent.attrs?.align == @alignment

TaoComponent.register Tao.Editor.Toolbar.AlignItem
