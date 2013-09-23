# Nornir framework

Nornir framework help to make your server/client system of RPC.

This framework is these following features.

1. This framework is written in Haxe, so you write some Haxe code when you use it.

2. In server and client code both types to provide this framework.

3. provide templates of procedure.

4. Useful simple server and client library.

These features are composed of different three components. The feature '2' is called "Verdandi", '3' is called "Urd". Another one is called "Skuld" that's for server/client communication.


## Introduction

Example in samples/simple\_skuld is good introduction.
You go to samples/simple\_skuld.

```
cd samples/simple_skuld
```

### Step 1. verdandi
Next step is to execute 'verdandi' command.

```
haxelib nornir verdandi json/sample.json
```

'verdandi' command read json file and make classes following an element of 'classes'.

```json/sample.json
{
  "classes":{
    "nornir.samples": {
      "Person": { "name" : "String", "address":"String" },
      "People": { "people" : "Array<Person>" },
      "MailData": { "sender":"Person", "receiver":"People", "subject":"String", "body":"String" }
    }
  }
  ...
}
```

### Step 2. urd
'urd' command make procedures following elements without 'classes' in json file.

```
haxelib nornri urd json/sample.json
```

```json/sample.json
{
  "classes":{
  ...
  },
  "server":{
    "nornir.samples": {
      "MailToAdressee": { "Mail" : "MailData" }
    }
  },
  "client":{
    "nornir.samples": {
      "MailToMailServer": { "Mail" : "MailData" }
    }
  }
}
```

### Step 3. skuld

Skuld is not command but a library.
For how to use, See TestServer.hx and TestClient.hx.
