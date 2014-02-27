pty = require 'pty.js'
ansi = require './ansi'

module.exports = (window, command) ->
  term = pty.spawn command, [],
    name: 'xterm-color'
    cols: 40
    rows: 6

  history = ''

  term.on 'data', (data) ->
    data = data.replace /\r\r\n/gm, '\n'
    data = data.replace /\r\n/gm, '\n'

    history = ansi.parse history, data
    window.setContent history

  term.on 'error', (error) ->
    # console.error error.stack
  term.on 'exit', ->
    window.destroy()

  term

