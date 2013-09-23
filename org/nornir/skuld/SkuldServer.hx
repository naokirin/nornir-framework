package org.nornir.skuld;

import sys.net.Socket;
import haxe.crypto.Sha1;

import org.nornir.urd.ISender;

class SkuldServer implements ISender {

  private var connections : SkuldConnections;
  private var total : Int;

  public function new() {
    total = 0;
    connections = new SkuldConnections();
  }

  public function accept(host:String, port:Int) : String {
    var s = new sys.net.Socket();
    s.bind(new sys.net.Host(host),port);
    s.listen(1);
    var soc = s.accept();

    var id = Sha1.encode(Std.string(total));
    var connection = new SkuldConnection(soc, id);
    connections.add(connection);
    total += 1;

    return id;
  }

  public function send(serializedData : String, id : String) : Void {
    connections.send(serializedData, id);
  }

  public function broadcast(serializedData : String) : Void {
    connections.broadcast(serializedData);
  }

  public function receive(id : String) : Bool {
    return connections.receive(id);
  }

  public function getConnections() : Array<SkuldConnection> {
    return connections.getConnections();
  }
}
