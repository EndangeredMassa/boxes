blessed = require 'massa-blessed'

module.exports = ->
  screen = blessed.screen()
  screen.key ['escape'], (char, key) ->
    process.exit(0)
  screen

