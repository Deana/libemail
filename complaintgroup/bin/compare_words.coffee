redis = require 'redis'
client = redis.createClient()

@fn = []
@matchid = 3

@done = {}

client.on 'ready', () ->
	client.select 5, ( err, res ) ->
		#console.dir res
		client.emit 'processargs'

client.on 'processargs', () ->
	for inputid in process.argv
		do ( inputid ) ->
			val = /^\d+$/.exec inputid
			if val?
				console.log 'processing ' + inputid

				# First, get all words
				#my @words = $r->smembers( "file:words:$fileindex" );
				client.smembers 'file:words:' + inputid, ( err, val ) ->
					#console.log inputid + " => " + val
					for i in val
						do ( i ) ->
							console.log "ngram id: " + i
							#my @files = $r->smembers( "set:ngram:$ngram_id" );
							#
							# Ok, now we want to get all files that contain this
							# ngram ID, and compare ourselves to it
							client.smembers "set:ngram:" + i, ( err, v2 ) ->
							  	#console.log "Comparing " + inputid + " and " + v2
							  	client.emit 'compare', inputid, v2

client.on 'compare', (fileid, mid) ->
	return unless fileid?
	return unless mid?
	
	client.sinter 'file:words:' + fileid, 'file:words:' + mid, ( err, val ) ->
		console.log fileid + ":" + mid + " => " + val unless /^\s*$/.exec(val)?

client.on 'alldone', ->
	client.quit()

# vim: set nu ts=2:
