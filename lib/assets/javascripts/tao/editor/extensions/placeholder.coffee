{ Decoration, DecorationSet } = ProseMirrorView

Tao.Editor.PlaceholderPlugin = ->

  @extendPlugins ->
    return unless @placeholder

    new Plugin
      props:
        decorations: (state) ->
          doc = state.doc
          if doc.childCount == 1 && doc.firstChild.isTextblock && doc.firstChild.content.size == 0
            DecorationSet.create(
              doc,
              [Decoration.widget(1, document.createTextNode(@placeholder))]
            )
