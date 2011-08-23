dns = require 'dns'
console = require 'console'

class Senderscore

	constructor: ->
		@zonename = 'score.senderscore.com'

	lookup: (@address) ->
		# Reverse the IP
		reversed = null
		m = /^(\d+)\.(\d+)\.(\d+)\.(\d+)$/.exec( @address )

		if m
			reversed = m[4] + "." + m[3] + "." + m[2] + "." + m[1]

		host = reversed + "." + @zonename

		result = ''
		dns.resolve4 host, ( err, addresses ) ->
			for address in addresses
				a = address.split( "." )
				return a[3]


exports.Senderscore = Senderscore
exports.lookup = (address) ->
	obj = new Senderscore
	return obj.lookup address

