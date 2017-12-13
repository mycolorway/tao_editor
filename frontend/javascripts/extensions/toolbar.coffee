import _ from 'lodash'
import $ from 'jquery'
import { Plugin } from 'prosemirror-state'

export default ->

  @extendPlugins ->
    new Plugin
      view: (editorView) =>
        @_initToolbar editorView

        update: @_updateToolbar.bind(@)
        destroy: @_destroyToolbar.bind(@)

  @attribute 'toolbarFloatable', type: 'boolean'

  @attribute 'toolbarFloating', type: 'boolean', observe: true

  @attribute 'toolbarFloatOffset', type: 'number', default: 0

  @attribute 'scrollContainerSelector'

  _initToolbar: (editorView) ->
    @toolbar = @findComponent '> .tao-editor-toolbar', =>
      @toolbar.setEditorView editorView

    if @toolbarFloatable
      @_scrollContainer = @jq.closest(@scrollContainerSelector)
      @_scrollContainer = null if @_scrollContainer.length <= 0
      @_toolbarHeight = $(@toolbar).outerHeight()
      @_toolbarWidth = $(@toolbar).outerWidth()
      @_generatePlaceholder()
      @_updateToolbarFloating editorView

      $(@_scrollContainer || window).on "scroll.tao-editor-toolbar-#{@taoId}", _.throttle (e) =>
        @_updateToolbarFloating()
      , 50

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
      $(@_scrollContainer || window).off(".tao-editor-toolbar-#{@taoId}")
      @_scrollContainer = null
      @_toolbarHeight = null
      @_toolbarWidth = null
      @_toolbarPlaceholder.remove()

  _updateToolbarFloating: (editorView = @view) ->
    editorBody = $ editorView.dom
    bodyTop = editorBody.get(0).getBoundingClientRect().top
    if @_scrollContainer?.length > 0
      bodyTop -= @_scrollContainer.get(0).getBoundingClientRect().top

    @toolbarFloating = bodyTop - @_toolbarHeight < 0 &&
      bodyTop + editorBody.outerHeight() - @_toolbarHeight - 60 > 0

  _toolbarFloatingChanged: ->
    if @toolbarFloating
      @_toolbarPlaceholder.show()
      toolbarLeft = @_toolbarPlaceholder.get(0).getBoundingClientRect().left

      @toolbar.jq.css
        width: @_toolbarWidth
        top: @toolbarFloatOffset
        left: toolbarLeft
    else
      @_toolbarPlaceholder.hide()
      @toolbar.jq.css width: ''
