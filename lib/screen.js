// Generated by CoffeeScript 2.0.0-beta8
void function () {
  var blessed;
  blessed = require('blessed');
  module.exports = function () {
    var screen;
    screen = blessed.screen();
    screen.key(['escape'], function (char, key) {
      return process.exit(0);
    });
    return screen;
  };
}.call(this);