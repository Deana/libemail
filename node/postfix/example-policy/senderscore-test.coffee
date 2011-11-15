Senderscore = require './senderscore'
console = require 'console'
{EventEmitter} = require 'events'

address = '216.40.44.1'
console.log 'looking up address ' + address

ss = new Senderscore.Senderscore()
listener = new EventEmitter
score = -1

listener.on 'response', ( domain, addresses ) ->
	score = addresses[0].split(".")[3]
	console.log( domain + " = " + addresses + " : " + score )

ss.lookup address, listener

