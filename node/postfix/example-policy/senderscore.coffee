dns = require 'dns'
console = require 'console'
{EventEmitter} = require 'events'

class Senderscore

	constructor: ->
		@zonename = 'score.senderscore.com'
		@score 

	lookup: (@address, e) ->
		# Reverse the IP
		reversed = null
		m = /^(\d+)\.(\d+)\.(\d+)\.(\d+)$/.exec( @address )

		if m
			reversed = m[4] + "." + m[3] + "." + m[2] + "." + m[1] + "." + @zonename

			# @score = e.addListener 'response', ( domain, addresses ) ->
			# 	@score = addresses[0].split(".")[3]
			# 	console.log( domain + " = " + addresses + " : " + @score )
			# 	addresses[0].split(".")[3]
	
			dns.resolve4 reversed, ( err, addresses ) ->
				e.emit 'response', address, addresses


exports.Senderscore = Senderscore
