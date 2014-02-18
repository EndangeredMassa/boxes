spawnWindow = require './window'

windowId = 0
windows = {}
activeWindow = null

module.exports = (screen) ->

  spawnProcess = (command) ->
    windowId++
    window = spawnWindow screen,
      title: "#{windowId}. #{command}"
      command: command
    window.id = windowId
    windows[windowId] = window

    window.onFocus = ->
      activeWindow = window
    window.onRemove = ->
      delete windows[window.id]
      screen.focusNext()

    activeWindow = window
    window

  switchWindow = (windowId) ->
    return unless windowId?
    window = windows[windowId]
    return unless window?
    activeWindow = window
    window.focus()

  screen.on 'keypress', (char, key) ->
    if key.meta
      if key.name == 't'
        return spawnProcess 'nsh'

      adjustment = 2 # if key.shift then 1 else 5
      command = if key.shift then 'size' else 'move'
      if key.name == 'j'
        return activeWindow[command] {y: -adjustment}
      if key.name == 'k'
        return activeWindow[command] {y: adjustment}
      if key.name == 'h'
        return activeWindow[command] {x: -adjustment}
      if key.name == 'l'
        return activeWindow[command] {x: adjustment}

      if key.name == '['
        return activeWindow.scroll(-1)
      if key.name == ']'
        return activeWindow.scroll(1)

      id = try parseInt(key.name, 10)
      if id?
        switchWindow(id)

  process.stdin.on 'data', (data) ->
    if data? && activeWindow?.term?
      activeWindow.term.write data

  spawnProcess 'nsh'

