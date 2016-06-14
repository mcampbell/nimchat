import json


type
  Message = object
    username*: string
    message*: string


proc parseMessage*(data: string): Message =
  let dataJson = parseJson(data)
  result.username = dataJson["username"].getStr
  result.message  = dataJson["message"].getStr

proc createMessage*(username, message: string): string =
  $(%{"username": %username, "message": %message}) & "\c\l"

proc createMessage*(m: Message): string =
  $(%{"username": %m.username, "message": %m.message}) & "\c\l"

  
when isMainModule:
  block:
    let data = """{"username": "michael", "message": "hello" }"""
    let parsed = parseMessage(data)

    doAssert parsed.username == "michael"
    doAssert parsed.message == "hello"

  block:
    let data = """nope"""
    try:
      let parsed = parseMessage(data)
    except JsonParsingError:
      doAssert true
    except:
      doAssert false

  block:
    let data = createMessage("michael", "hello")
    doAssert data == """{"username":"michael","message":"hello"}""" & "\c\l"

  block:
    let m = Message(username: "michael", message: "hello")
    let data = createMessage(m)
    doAssert data == """{"username":"michael","message":"hello"}""" & "\c\l"


  echo "All Tests Passed."
    
