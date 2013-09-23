package org.nornir.skuld;

import sys.net.Socket;
import haxe.Serializer;

import org.nornir.urd.UrdReceiver;

class SkuldConnection {

  private var socket : Socket;
  private var keepAlive : Bool;
  private var id : String;

  private var sendingQueue : List<String>;

  public function new(socket : Socket, id : String) {
    this.socket = socket;
    this.id = id;
    keepAlive = true;
  }

  public function receive() : Void {
    var data = socket.input.readLine();
    data.substring(0, data.length - 2); 
    UrdReceiver.receive(data);
  }

  public function send(serializedData : String) : Void {
    try {
      socket.output.writeString(serializedData + "\n");
    }
    catch(e : Dynamic) {
      keepAlive = false;
    }
  }

  public function close() : Void {
    try {
      socket.shutdown(true, true);
      socket.close();
    }
    catch(e : Dynamic) {}
    keepAlive = false;
  }

  public function clearSendingQueue() : Void {
    sendingQueue.clear();
  }

  public function disconnected() : Bool {
    return (socket == null || !keepAlive);
  }

  public function getId() : String {
    return id;
  }
}
