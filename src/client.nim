import os, threadpool, asyncnet, asyncdispatch, protocol

proc connect(socket: AsyncSocket, serverAddr: string) {.async.} =
  echo("Connecting to:", serverAddr)
  await socket.connect(serverAddr, 7687.Port)
  echo("Connected!")

  while true:
    let line = await socket.recvLine()
    let parsed = parseMessage(line)
    echo(parsed.username, " said: ", parsed.message)


if paramCount() == 0:
  quit("Please specify server address.  eg: ./client localhost")

let serverAddr = paramStr(1)

echo "Chat client started: ", getAppFilename(), " talking to ", serverAddr

while true:
  let message = spawn stdin.readLine()
  echo "Sending \"", ^message, "\""


