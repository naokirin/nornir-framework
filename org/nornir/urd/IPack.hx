package org.nornir.urd;

interface IPack {
  public function pack(data : Dynamic) : Dynamic;
  public function unpack(data : Dynamic) : Dynamic;
}