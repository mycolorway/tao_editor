class Tao.Editor.Toolbar.MenuItem extends Tao.Editor.Toolbar.BaseItem

  @tag 'tao-editor-toolbar-menu-item'

  _connected: ->
    @items = @findComponent '.tao-editor-toolbar-item'
    @popover = @findComponent '> .menu-popover'
    @tooltip = @findComponent '> .tao-tooltip'

    @_bind()

  _bind: ->
    @on 'click', '.menu-popover .tao-editor-toolbar-item > .item-link', (e) =>
      @popover.active = false

    @on 'tao:activeChanged', '.tao-editor-toolbar-item', _.debounce =>
      console.log 'test'
      @activeItem = @jq.find('.tao-editor-toolbar-item[active]').get(0)
      @active = !!@activeItem
      null
    , 50

    @on 'tao-popover:show', '> .menu-popover', (e) =>
      @tooltip?.disabled = true

    @on 'tao-popover:hide', '>  .menu-popover', (e) =>
      @tooltip?.disabled = false

  _activeChanged: ->
    super
    @_renderIcon @activeItem?.icon

TaoComponent.register Tao.Editor.Toolbar.MenuItem
