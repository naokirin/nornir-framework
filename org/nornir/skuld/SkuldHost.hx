package org.nornir.skuld;

import sys.net.Socket;
import haxe.crypto.Sha1;

import org.nornir.urd.ISender;

class SkuldHost implements ISender {
  private var connections : SkuldConnections;
  private var total : Int;

  public function new() {
    connections = new SkuldConnections();
    total = 0;
  }

 private function addConnection(socket : Socket) : String {
    var id = Sha1.encode(Std.string(total));
    var connection = new SkuldConnection(socket, id);
    connections.add(connection);
    total += 1;
    return id;
  }

  public function send(data : String, id : String) : Void {
    connections.send(data, id);
  }

  public function broadcast(data : String) : Void {
    connections.broadcast(data);
  }

  public function receive(id : String) : Bool {
    return connections.receive(id);
  }

  public function getConnections() : Array<SkuldConnection> {
    return connections.getConnections();
  }
}