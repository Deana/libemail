redis = require 'redis'
client = redis.createClient('slowpoke.internal.tucows.com')

@fn = []
@matchid = 3

client.on 'ready', () ->
	client.select 5, ( err, res ) ->
		client.emit 'processargs'

client.on 'processargs', ->
	for inputid in process.argv
		do ( inputid ) ->
			console.log 'Processing ' + inputid

client.on 'compare', (fileid, mid) ->
	return unless fileid?
	return unless mid?
	
	client.sinter 'file:words:' + fileid, 'file:words:' + mid, ( err, val ) ->
		console.log fileid + ":" + mid + " => " + val unless /^\s*$/.exec(val)?

client.on 'alldone', ->
	client.quit()

client.on 'getallfilenames', ->
	@fn = [] unless @fn?
	client.keys 'orig:idx:*', (err,res) ->
		if res?
			do ( res ) ->
				fileids = []
				for val in res
					do (val) ->
						ret = /.*:.*:(\d+)$/.exec val
						fileids.push ret[1] if ret?

				client.emit 'matchall', fileids

client.on 'matchall', ( fileids ) ->
	do ( fileids ) ->
		for inputid in process.argv
			@matchid = inputid if /^\d+$/.exec( inputid )?
			console.log "Cannot matchall, since fileids is undefined" unless fileids?
			for j in fileids
				client.emit 'compare', @matchid, j unless @matchid == j
		client.emit 'alldone'


client.on 'getwords', (@index,@filename) ->
	console.log @filename
	console.log @index

	# lets get the words in the set: file:words:$index
	console.log 'getting smembers for file:words:' + @index if @index?
	client.smembers 'file:words:' + @index, (err,res) ->
		if res?
			console.log @index + res
			res.forEach ( @resval, @resindex, @resarray ) ->
				console.log @resval if @resval?

# vim: set nu ts=2:
