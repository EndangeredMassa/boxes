#!/usr/bin/env node

// for some reasons, `npm start` works,
// but requireing the same module here does not
// require('child_process').spawn('npm', ['start'], {cwd: __dirname, stdio: 'inherit'})

require(__dirname + '/lib/index.js');

