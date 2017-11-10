import { Decoration, DecorationSet } from 'prosemirror-view'

export default ->

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
