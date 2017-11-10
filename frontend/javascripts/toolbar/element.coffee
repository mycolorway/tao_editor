import { Component } from '@mycolorway/tao'
import helpers from '../helpers'

class ToolbarElement extends TaoComponent

  @tag 'tao-editor-toolbar'

  _connected: ->
    @items = @findComponent '.tao-editor-toolbar-item'

  _disconnected: ->
    @off()

  setEditorView: (editorView) ->
    @editorView = editorView
    @items.forEach (item) ->
      helpers.componentReady item, ->
        item.setEditorView editorView

  # called by editor view
  update: (prevState) ->
    @items.forEach (item) -> item.update(prevState)

  # called by editor view
  reset: ->
    @editorView = null
    @items.forEach (item) -> item.reset()


export default ToolbarElement.register()
