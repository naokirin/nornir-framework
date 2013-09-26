package org.nornir.skuld;

import sys.net.Socket;

class SkuldServer extends SkuldHost {

  public function new() {
    super();
  }

  public function accept(host:String, port:Int) : String {
    var s = new sys.net.Socket();
    s.bind(new sys.net.Host(host),port);
    s.listen(1);
    var soc = s.accept();
    return addConnection(soc);
  }
}
