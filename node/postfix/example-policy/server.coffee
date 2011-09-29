net  = require "net"
connection = require "./connection"
# cluster = require "cluster"

class Server
  createServer: ->
    serv = net.createServer()
    serv.listen 1337, "127.0.0.1"
    
    serv.on "connection", (client) ->
      connection.createConnection(client)

exports.Server = Server
exports.createServer = ->
	s = new Server
	s.createServer
