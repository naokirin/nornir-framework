package org.nornir.urd;

import sys.io.File;
import haxe.ds.StringMap;
import sys.FileSystem;
using Reflect;

class TransceiverGenerator {

  public static function generateTransceiver(packageName : String, className : String, anotherClassName : String, methods : StringMap<String>, dirPath : String, anotherDirPath : String) : Void {
    var receiverResource = haxe.Resource.getString("urd_gen_receiver");
    var receirverTemplate = new haxe.Template(receiverResource);
    var senderResource = haxe.Resource.getString("urd_gen_sender");
    var senderTemplate = new haxe.Template(senderResource);

    var data = createTextForTemplate(packageName, className, anotherClassName, methods);

    var receiverInterfaceName = data.className + "ReceiverInterface";
    var receiverInterfaceOutput = receirverTemplate.execute({package_name:data.packageName, class_name:("interface " + receiverInterfaceName), methods:data.receiverInterfaceMethods});
    File.saveContent("generated/" + anotherDirPath + receiverInterfaceName + ".hx", receiverInterfaceOutput);

    var receiverImplOutput = receirverTemplate.execute({package_name:data.packageName, class_name:("class " + data.className + "Receiver implements " + receiverInterfaceName), methods:data.receiverMethods});
    if (!FileSystem.exists("generated/" + anotherDirPath + className + "Receiver" + ".hx")) {
      File.saveContent("generated/" + anotherDirPath + className + "Receiver" + ".hx", receiverImplOutput);
    }
    var pname = packageName == "" ? "" : packageName + ".";
    var senderOutput = senderTemplate.execute({package_name:data.packageName, class_name:("class " + data.className + "Sender extends org.nornir.urd.UrdSender"), methods:data.senderMethods, imports:"import " + pname + data.className + "Receiver;\nimport org.nornir.urd.*;"});
    File.saveContent("generated/" + dirPath + className + "Sender" + ".hx", senderOutput);
  }

  private static function createTextForTemplate(packageName : String, className : String, anotherClassName : String, methods : StringMap<String>) : Dynamic {
    var receiverMethodsText = "  public function new() {}\n\n";
    var receiverInterfaceMethodsText = "";
    var senderMethodsText = "  public function new(sender : ISender, dest : Destination) {\n    super(sender, dest);\n  }\n\n";

    var isLoopFirst = true;
    var pname = packageName == "" ? "" : packageName + ".";

    for (name in methods.keys()) {
      if (isLoopFirst) {
        isLoopFirst = false;
      }
      else {
        receiverMethodsText += "\n";
        receiverInterfaceMethodsText += "\n";
        senderMethodsText += "\n";
      }

      var typeName = methods.get(name);
      receiverMethodsText += "  public function receive" + name + "(arg : " + typeName + ") : Bool {\n  }";
      receiverInterfaceMethodsText +="  public function receive" + name + "(arg : " + typeName + ") : Bool;";

      senderMethodsText += "  public function send" + name + "(arg : " + typeName + ") : Void { send(\"" + pname + className +"Receiver\" ,\"receive" + name + "\" ,arg); }";
    }

    return {packageName : packageName, className:className, receiverInterfaceMethods:receiverInterfaceMethodsText, receiverMethods:receiverMethodsText, senderMethods:senderMethodsText}
  }
}
