process.stdin.setRawMode(true)

buildScreen = require './screen'
processManager = require './process_manager'

screen = buildScreen()
screen.render()

processManager(screen)

