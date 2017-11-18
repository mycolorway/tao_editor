import _ from 'lodash'
import BaseItem from './base'

class MenuItem extends BaseItem

  @tag 'tao-editor-toolbar-menu-item'

  _connected: ->
    @items = @findComponent '.tao-editor-toolbar-item'
    @popover = @findComponent '> .menu-popover'
    @tooltip = @findComponent '> .tao-tooltip'

    @_bind()

  _bind: ->
    @on 'click', '.menu-popover .tao-editor-toolbar-item > .item-link', (e) =>
      @_hidePopover()
      null

    @on 'tao:activeChanged', '.tao-editor-toolbar-item', _.debounce =>
      @activeItem = @jq.find('.tao-editor-toolbar-item[active]').get(0)
      @active = !!@activeItem
      null
    , 50

    @on 'tao-popover:show', '> .menu-popover', (e) =>
      @tooltip?.disabled = true

    @on 'tao-popover:hide', '>  .menu-popover', (e) =>
      @tooltip?.disabled = false

  _activeChanged: ->
    super()
    @_renderIcon @activeItem?.icon

  _hidePopover: ->
    @popover.jq.hide()
    @popover.active = false

export default MenuItem.register()
