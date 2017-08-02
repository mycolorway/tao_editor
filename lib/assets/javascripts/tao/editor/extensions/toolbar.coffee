{ Plugin } = ProseMirrorState

Tao.Editor.ToolbarExtension = ->

  @extendPlugins ->
    new Plugin
      view: (editorView) =>
        @_initToolbar editorView

        update: @_updateToolbar
        destroy: @_destroyToolbar

  @attribute 'toolbarFloatable', type: 'boolean'

  @attribute 'toolbarFloating', type: 'boolean', observe: true

  @attribute 'toolbarFloatOffset', type: 'number', default: 0

  @attribute 'scrollContainerSelector'

  _initToolbar: (editorView) ->
    @toolbar = @findComponent '> .tao-editor-toolbar', =>
      @toolbar.setEditorView editorView

    if @toolbarFloatable
      @_scrollContainer = @jq.closest(@scrollContainerSelector) if @scrollContainerSelector
      @_toolbarHeight = $(toolbar).outerHeight()
      @_generatePlaceholder()
      @_updateToolbarFloating()

      $(window).on "scroll.tao-editor-toolbar-#{@taoId}", _.throttled (e) =>
        @_updateToolbarFloating()
      , 100

  _generatePlaceholder: ->
    @_toolbarPlaceholder = @jq.find('> .toolbar-placeholder')
    return if @_toolbarPlaceholder.length > 0
    @_toolbarPlaceholder = $('<div>', class: 'toolbar-placeholder')
      .height @_toolbarHeight
      .insertBefore @toolbar

  _updateToolbar: (editorView, prevState) ->
    @toolbar.update prevState

  _destroyToolbar: ->
    @toolbar.reset()

    if @toolbarFloatable
      @_scrollContainer = null
      @_toolbarHeight = null
      @_toolbarPlaceholder.remove()
      $(window).off(".tao-editor-toolbar-#{@taoId}")

  _updateToolbarFloating: ->
    bodyTop = @body.get(0).getBoundingClientRect().top
    if @_scrollContainer && @_scrollContainer.length > 0
      bodyTop -= @_scrollContainer.get(0).getBoundingClientRect().top

    @toolbarFloating = bodyTop - @_toolbarHeight < 0 &&
      bodyTop + @body.outerHeight() - @_toolbarHeight - 60 > 0

  _toolbarFloatingChanged: ->
    if @toolbarFloating
      @_toolbarPlaceholder.show()
      @toolbar.css
        top: @toolbarFloatOffset
        left: @_toolbarPlaceholder.position().left
    else
      @_toolbarPlaceholder.hide()
