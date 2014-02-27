blessed = require 'massa-blessed'
pty = require './pty'
{min, max} = Math

offsetTop = 0
offsetLeft = 40

module.exports = (screen, options) ->
  options.top ?= (offsetTop += 4)
  options.left ?= (offsetLeft += 4)
  options.width ?= 100
  options.height ?= 20

  frame = blessed.box
    parent: screen
    top: options.top
    left: options.left
    width: options.width
    height: options.height
    border:
      type: 'line'
    style:
      fg: 'lime'
      focus:
        border:
          bg: 'green'

  title = blessed.text
    parent: frame
    left: 2
    content: " #{options.title} "
    tags: true

  content = blessed.box
    parent: frame
    scrollable: true
    tags: true
    content: options.content
    top: 1
    left: 1
    width: options.width - 2
    height: options.height - 2

  frame.focus()


  window =
    move: (options) ->
      if options.y?
        frame.top += options.y
        frame.top = max(frame.top, 0)
        # frame.top = min(frame.top, screen.rows - frame.width)

      if options.x?
        frame.left += options.x
        frame.left = max(frame.left, 0)
        # frame.left = min(frame.left, screen.cols - frame.height)
      screen.render()

    size: (options) ->
      if options.y?
        frame.height += options.y
        frame.height = max(frame.height, 4)
        content.height += options.y
        content.height = max(content.height, 2)
      if options.x?
        frame.width += options.x
        frame.width = max(frame.width, 7)
        content.width += options.x
        content.width = max(content.width, 5)
      screen.render()

    scroll: (delta) ->
      content.scroll(delta)
      screen.render()

    setContent: (data) ->
      content.setContent(data)
      content.setScrollPerc(100)
      screen.render()

    focus: ->
      frame.focus()
      frame.setFront()
      screen.render()

    destroy: ->
      screen.remove(frame)
      @onRemove()
      screen.render()

    onRemove: ->
    onFocus: ->

  frame.on 'focus', -> window.onFocus()

  window.term = pty(window, options.command)
  window

