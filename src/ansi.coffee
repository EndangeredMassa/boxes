Parser = require '../vendor/ansi_parse'

clearFrom = (history, position) ->
  # clear last line from position on
  lines = history.split '\n'
  lastLine = lines.pop()
  lastLine = lastLine.substr(0, position)
  lines.push lastLine
  return lines.join '\n'

module.exports =
  parse: (history, data) ->
    # this parser emits sync events
    # allowing us to return the result

    parser = new Parser
    parser.on 'command', (character, params, intermediate) ->
      param1 = params[0]

      switch character
        #when 'G'
        when 'H'
          history = ''
        when 'J'
          history = clearFrom(history, param1)

    parser.on 'data', (newData) ->
      history += newData

    parser.parse(data)

    history

