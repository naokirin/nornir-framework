package org.nornir.urd;

import haxe.Unserializer;
using Reflect;

class UrdReceiver {

  public static function receive(data : String) {
    var unserializedData = Unserializer.run(data);
    var instance = Type.createInstance(Type.resolveClass(unserializedData.className), []);
    Reflect.callMethod(instance, Reflect.field(instance, unserializedData.methodName), [unserializedData.data]);
  }
}
