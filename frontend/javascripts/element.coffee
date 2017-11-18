import $ from 'jquery'
import _ from 'lodash'
import { Component } from '@mycolorway/tao'
import { EditorState } from 'prosemirror-state'
import { EditorView, Decoration, DecorationSet } from 'prosemirror-view'
import { DOMParser, Node, DOMSerializer } from 'prosemirror-model'
import { baseKeymap } from 'prosemirror-commands'
import { keymap } from 'prosemirror-keymap'
import ExtensionBase from './extensions/base'
import AlignmentExtension from './extensions/alignment'
import HistoryExtension from './extensions/history'
import ListExtension from './extensions/list'
import TableExtension from './extensions/table'
import ToolbarExtension from './extensions/toolbar'
import editorSchema from './schema'

class EditorElement extends Component

  @extend ExtensionBase
  @include AlignmentExtension
  @include HistoryExtension
  @include ListExtension
  @include TableExtension
  @include ToolbarExtension

  @tag 'tao-editor'

  @attribute 'placeholder'

  @get 'value', ->
    if val = @field.val()
      JSON.parse val
    else
      ''
  _connected: ->
    @field = @jq.find('> input:hidden')
    @schema = @_buildSchema()
    @keymaps = @_buildKeymaps()
    @plugins = @_buildPlugins()
    @state = @_buildState()
    @view = @_buildView()
    @body = $ @view.dom

  _disconnected: ->
    @view.destroy()

  _buildSchema: ->
    @schema = editorSchema
    @constructor._schemaCallbacks.forEach (callback) =>
      @schema = callback.call(@, @schema)
    @schema

  _buildPlugins: ->
    @plugins = [keymap(@keymaps)]
    @constructor._pluginCallbacks.forEach (callback) =>
      plugin = callback.call(@)
      @plugins = _.concat(@plugins, plugin) if plugin
    @plugins

  _buildKeymaps: ->
    @keymaps = _.extend {}, baseKeymap
    @constructor._keymapCallbacks.forEach (callback) =>
      _.extend @keymaps, callback.call(@, @keymaps)
    @keymaps

  _buildState: ->
    options = plugins: @plugins

    if value = @field.val()
      content = $('<div>').html(value).get(0)
      options.doc = DOMParser.fromSchema(@schema).parse(content)
    else
      options.schema = @schema

    EditorState.create options

  _buildView: ->
    new EditorView @,
      state: @state
      decorations: @_generateDecorations.bind(@)
      dispatchTransaction: @_dispatchTransaction.bind(@)
      attributes:
        class: 'tao-editor-body'

  _dispatchTransaction: (transaction) ->
    @state = @state.apply(transaction)
    @view.updateState @state
    @_syncValue()
    @namespacedTrigger 'change'

  _generateDecorations: (state) ->
    doc = state.doc
    decorations = []
    if @placeholder && doc.childCount == 1 && doc.firstChild.isTextblock &&
        doc.firstChild.content.size == 0
      placeholderNode = $('<span>', placeholder: @placeholder).get(0)
      decorations.push Decoration.widget(1, placeholderNode)
    DecorationSet.create(doc, decorations) if decorations.length > 0

  _syncValue: ->
    serializer = DOMSerializer.fromSchema(@schema)
    fragment = serializer.serializeFragment(@view.state.doc.content)
    @field.val $('<div>').append(fragment).html()

export default EditorElement.register()
