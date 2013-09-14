package;

import haxe.Json;
import haxe.ds.StringMap;
import massive.sys.cmd.Command;
import massive.sys.haxe.HaxeWrapper;
import massive.haxe.log.Log;
import massive.haxe.util.TemplateUtil;
import sys.io.File;
import sys.FileSystem;
import sys.io.Process;
import Lambda;

import org.nornir.urd.TransceiverGenerator;

using Reflect;

class UrdCommand extends Command {

  inline static var topDir = "generated";

  override public function initialise():Void
  {
    super.initialise();
    print("\nurd");
    print("====================================");
    return;
  }

  override public function execute():Void
  {
    super.execute();

    var nextArg = console.getNextArg();
    if (nextArg == null) {
      if (data == null || cast(data, String) == "") {
        error("cannot run 'urd' without file name.");
        return;
      }
      else {
        nextArg = data;
      }
    }
    print(CommandCommon.createGeneratedDirectory(topDir));
    generateClasses(nextArg);
  }

  private function generateClasses(filename:String):Void {
    if (!FileSystem.exists(filename)) {
      error("not found " + filename + ".");
      return;
    }

    print("start to generate classes.\n");
    var json = CommandCommon.checkValidJsonFile(filename);
    if(json == null) {
      error(filename + " is invalid json file.");
      return;
    }

    if (Lambda.empty(json.fields())) {
      error("fail to parse json file " + filename + ".");
      return;
    }

    json.deleteField("classes");

    var components = cast(json.fields(), Array<Dynamic>);
    if (components.length != 2) {
      error("top elements are exactly 2 without \"classes\"");
      return;
    }
    var message = generateClass(json, components[0], components[1], topDir);
    if (message != "") print(message);
    message = generateClass(json, components[1], components[0], topDir);
    if (message != "") print(message);
    print("finished to generate classes.");
    print("success to urd.\n");
  }

  private function generateClass(json : Dynamic, name : String, anotherName : String, topDirectory : String) : String {

    var message = "";

    for (pn in json.field(name).fields()) {
      var cnArray = pn.split(".");

      var packageName = pn;
      var dirPath = name;
      var anotherDirPath = anotherName;
      if (!Lambda.empty(cnArray)) {

        for (dirName in cnArray) {
          if (dirPath.length == 0) {
            dirPath = dirName;
          }
          else {
            dirPath += "/" + dirName;
            anotherDirPath += "/" + dirName;
          }
          if (!FileSystem.exists(topDirectory + "/" + dirPath)) {
            FileSystem.createDirectory(topDirectory + "/" + dirPath);
          }
          if (!FileSystem.exists(topDirectory + "/" + anotherDirPath)) {
            FileSystem.createDirectory(topDirectory + "/" + anotherDirPath);
          }
        }
      }

      dirPath += "/";
      anotherDirPath += "/";

      for (cn in json.field(name).field(pn).fields()) {
        var className = cn;
        var fields = new StringMap<String>();
        for (f in json.field(name).field(pn).field(cn).fields()) {
          fields.set(f, json.field(name).field(pn).field(cn).field(f));
        }
        TransceiverGenerator.generateTransceiver(packageName, className, anotherName, fields, dirPath, anotherDirPath);
        var pname = packageName == "" ? "" : packageName + ".";
        message += "   generate class '" + pname + className + "Receiver' at '" + anotherName + "'.\n";
        message += "   generate class '" + pname + className + "Sender' at '" + name + "'.\n";
      }
    }
    return message;
  }
}
