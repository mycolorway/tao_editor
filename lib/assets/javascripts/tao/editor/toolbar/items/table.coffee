{ insertTable } = Tao.Editor.Commands

class Tao.Editor.Toolbar.TableItem extends Tao.Editor.Toolbar.MenuItem

  @tag 'tao-editor-toolbar-table-item'

  _connected: ->
    super

  _bind: ->
    super

    @on 'mouseenter', '.table-creator .link-create-table', (e) =>
      $td = $(e.currentTarget).closest('td')
      [rowIndex, colIndex] = @_getCellPosition $td
      @_highlightTableCreator rowIndex, colIndex
      null

    @on 'click', '.table-creator .link-create-table', (e) =>
      $td = $(e.currentTarget).closest('td')
      [rowIndex, colIndex] = @_getCellPosition $td
      insertTable @editorView.state, @editorView.dispatch, rowIndex + 1, colIndex + 1
      @editorView.focus()
      @_resetTableCreator()
      @_hidePopover()
      null

  _getCellPosition: ($td) ->
    $tr = $td.closest('tr')
    $table = $tr.closest('table')
    [$table.find('tr').index($tr), $tr.find('td').index($td)]

  _highlightTableCreator: (rowIndex, colIndex) ->
    $table = @jq.find('.table-creator')
    $table.find('td').removeClass 'active'
    $table.find('tr').slice(0, rowIndex + 1).each (i, tr) ->
      $(tr).find('td').slice(0, colIndex + 1).addClass 'active'

  _resetTableCreator: ->
    $table = @jq.find('.table-creator')
    $table.find('td.active').removeClass 'active'

  _updateActive: ->
    @active = !!@_isInTable()

  _isInTable: ->
    $head = @editorView.state.selection.$head
    depth = $head.depth
    while depth > 0
      return true if $head.node(depth).type.spec.tableRole == 'row'
      depth -= 1
    return false

  _updateDisabled: ->
    @disabled = !@active && !insertTable(@editorView.state, null)

TaoComponent.register Tao.Editor.Toolbar.TableItem
