import asyncdispatch, asyncnet

type
  Client = ref object
    socket: AsyncSocket
    netAddr: string
    id: int
    connected: bool

  Server = ref object
    socket: AsyncSocket
    clients: seq[Client]


proc `$`(client: Client): string = 
  $client.id & ":(" & client.netAddr & ")"

#[
We use this non-standard constructor because we are giving 
it default values and we don't want the caller to have to
specify all this every time. newAsyncSocket is part of the net
package
]#
proc newServer(): Server =
  Server(socket: newAsyncSocket(), clients: @[])

proc processMessages(server: Server, client: Client) {.async.} =
  while true:
    let line = await client.socket.recvLine()
    if line.len == 0:
      echo client, "disconnected"
      client.connected = false
      client.socket.close()
      return

    echo client, " sent: ", line

    for c in server.clients:
      if c.connected and c.id != client.id:
        await c.socket.send(line & "\c\l")


proc loop(server: Server, port = 7687) {.async.} =
  server.socket.bindAddr(port.Port)
  server.socket.listen()

  while true:
    let (netAddr, clientSocket) = await server.socket.acceptAddr()
    echo "accepted connection from:", netAddr
    let client = Client(socket: clientSocket, 
                        netAddr: netAddr, 
                        id: server.clients.len,
                        connected: true)
    server.clients.add(client)
    asyncCheck (processMessages(server, client))

var server = newServer()    
waitFor loop(server)
