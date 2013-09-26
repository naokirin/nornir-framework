package org.nornir.skuld;

import sys.net.Socket;
import haxe.crypto.Sha1;

import org.nornir.urd.ISender;

class SkuldClient extends SkuldHost {

  public function new () {
    super();
  }

  public function connect(host:String, port:Int) : String {
    var s = new sys.net.Socket();

    try {
      s.connect(new sys.net.Host(host),port);
      return addConnection(s);
    }
    catch(e : Dynamic) {
      trace("Fail to connect on " + host + ":" + port);
      return null;
    }
  }
}
