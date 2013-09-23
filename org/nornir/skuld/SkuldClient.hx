package org.nornir.skuld;

import sys.net.Socket;
import haxe.crypto.Sha1;

import org.nornir.urd.ISender;

class SkuldClient implements ISender {

  public var connectionId = "0";
  private var connection : SkuldConnection;
  private var tryReconnectCount : Int;

  public function new() {}

  public function connect(host:String, port:Int) : Bool {
    var s = new sys.net.Socket();

    try {
      s.connect(new sys.net.Host(host),port);
      connection = new SkuldConnection(s, connectionId);
    }
    catch(e : Dynamic) {
      trace("Fail to connect on " + host + ":" + port);
      return false;
    }
    return true;
  }

  public function send(serializedData : String, id : String) : Void {
    connection.send(serializedData);
  }

  public function broadcast(serializedData : String) : Void {
    send(serializedData, connectionId);
  }

  public function receive() {
    connection.receive();
  }
}
