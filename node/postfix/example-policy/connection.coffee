connection = exports

class Connection
  constructor: (@client) ->
    @current_data = ""
    @values = []
    
    @setupClient()
    
  setupClient: ->
    @client.on "data", (data) =>
      console.log "data"
      
      @process_line data
  
  process_data: ->
    console.log "Processing all of the data..."
    
    # Do something clever..
    @lines = @current_data.split( "\n" )
    for line in @lines
      m = ''
      console.log "Processing line: " + line
      m = /^(\S+?)=(.*)$/.exec line

      if m 
        @values[m[1]] = m[2]
      else
        console.log "Regex failed to match"

    console.log(@values)
    @client.write "action=DISCARD\n\n"
    @client.end()
    
  process_line: (data) ->
    console.log( "Received data" + data )
    @current_data += data

    if /\n\s*\n/m.test @current_data
      @process_data()

exports.Connection = Connection
exports.createConnection = (client) ->
  new Connection(client)
