import os, threadpool

if paramCount() == 0:
  quit("Please specify server address.  eg: ./client localhost")
  
let serverAddr = paramStr(1)

echo "Chat client started: ", getAppFilename(), " talking to ", serverAddr

while true:
  let message = spawn stdin.readLine()
  echo "Sending \"", ^message, "\""


