Senderscore = require './senderscore'
console = require 'console'

lookup = '216.40.44.1'
console.log 'looking up address ' + lookup

score = Senderscore.score lookup

console.log( "Score: " + score )
