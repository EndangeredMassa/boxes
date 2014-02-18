pty = require('pty.js')

module.exports = (window, command) ->
  term = pty.spawn command, [],
    name: 'xterm-color'
    cols: 40
    rows: 6

  history = ''
  cursorPosition = 0
  clearFrom = (position) ->
    # clear last line from position on
    lines = history.split '\n'
    lastLine = lines.pop()
    lastLine = lastLine.substr(0, position)
    lines.push lastLine
    history = lines.join '\n'

  term.on 'data', (data) ->
    data = data.replace /\r\r\n/gm, '\n'
    data = data.replace /\r\n/gm, '\n'

    # TODO readline emits strange cursor position data
    # making it hard to parse the proper output
    # console.log JSON.stringify data

    parseLine = ->
      moveCursor = new RegExp '\u001b\\[([0-9]+)G'
      clearCursor = new RegExp '\u001b\\[0J'

      if (cursorMatch = moveCursor.exec data)?
        cursorPosition = parseInt(cursorMatch[1], 10) - 1
        data = data.replace moveCursor, ''

      if (cursorMatch = data.match clearCursor)?
        parts = data.split cursorMatch[0]
        history += parts[0]
        clearFrom cursorPosition
        data = parts[1]

      #data = data.replace (new RegExp '\u001b\\[1A'), ''

      return !!cursorMatch

    while parseLine(data)
      noop = ''

    return if data.length == 0

    history += data

    if history.indexOf('\u001b[1;1H') > -1
      # TODO: fix clearing history
      history = (history.split '\u001b[1;1H')[1]


    window.setContent history



  term.on 'error', (error) ->
    # console.error error.stack
  term.on 'exit', ->
    window.destroy()

  term

