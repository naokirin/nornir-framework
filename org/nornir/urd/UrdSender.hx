package org.nornir.urd;

import haxe.Serializer;

class UrdSender {

  private var sender : ISender;
  private var destination : Destination;

  public function new(sender : ISender, dest : Destination) {
    this.sender = sender;
    destination = dest;
  }

  private function send(className : String, methodName : String, data : Dynamic) :Void {
    var d = {className:className, methodName:methodName, data:data}

    switch(destination) {
    case Id(id) :
      sender.send(Serializer.run(d), id);
    case Broadcast :
      sender.broadcast(Serializer.run(d));
    }
  }
}
