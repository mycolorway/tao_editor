class Tao.Editor.Toolbar.BaseItem extends TaoComponent

  @attribute 'active', type: 'boolean', observe: true

  @attribute 'disabled', type: 'boolean', observe: true

  @attribute 'icon'

  _connected: ->
    @on 'click', '> .item-link', (e) => @_onClick()

  _disconnected: ->
    @off()

  _onClick: ->
    # to be implemented

  setEditorView: (editorView) ->
    @editorView = editorView

  update: (prevState) ->
    @_updateActive prevState
    @_updateDisabled prevState

  _updateActive: (prevState) ->
    # to be implemented

  _updateDisabled: (prevState) ->
    # to be implemented

  _activeChanged: ->
    @namespacedTrigger 'activeChanged'

  _disabledChanged: ->
    @namespacedTrigger 'disabledChanged'

  _renderIcon: (iconName = @icon) ->
    @jq.find('> .item-link .icon')
      .replaceWith Tao.iconTag(_.kebabCase iconName)

  reset: ->
    @active = false
    @disabled = false
    @editorView = null
