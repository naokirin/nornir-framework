package org.nornir.skuld;

class SkuldConnections {
  private var connections : Array<SkuldConnection>;

  public function new() {
    connections = new Array<SkuldConnection>();
  }

  public function add(connection : SkuldConnection) : Void {
    if (!connection.disconnected()) {
      connections.push(connection);
    }
  }

  public function deleteAll() : Void {
    for (connection in connections) {
      connection.close();
    }
    connections = new Array<SkuldConnection>();
  }

  public function checkAlive() : Void {
    for (connection in connections) {
      if (connection.disconnected()) connections.remove(connection);
    }
  }

  public function send(serializedData : String, id : String) : Void {
    for (connection in connections) {
      if(connection.getId() == id) {
        connection.send(serializedData);
        return;
      }
    }
  }

  public function broadcast(serializedData : String) : Void {
    for (connection in connections) {
      connection.send(serializedData);
    }
  }

  public function receive(id : String) : Bool {
    for ( connection in connections) {
      if (connection.getId() == id) {
        connection.receive();
        return true;
      }
    }
    return false;
  }

  public function getConnections() : Array<SkuldConnection> {
    return connections;
  }
}
