package org.nornir.urd;

interface ISender {
  public function send(data : Dynamic, id : String) : Void;
  public function broadcast(data : Dynamic) : Void;
}
