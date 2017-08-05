Tao.Editor.Helpers =

  isMac: ->
    if typeof navigator != "undefined"
      /Mac/.test(navigator.platform)
    else
      false

  chainCommands: (commands...) ->
    commands = _.compact(commands)
    if commands.length > 1
      ProseMirrorCommands.chainCommands commands...
    else
      commands[0]

  # isInViewport: (el) ->
  #   $el = $ el
  #   $window = $ window
  #   rect = $el.get(0).getBoundingClientRect()
  #   winHeight = $window.height()
  #   winWidth = $window.width()
  #   rect.top >= 0 && rect.left >= 0 &&
  #     rect.bottom <= winHeight && rect.right <= winWidth
