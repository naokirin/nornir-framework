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

import org.nornir.verdandi.ClassGenerator;

using Reflect;

class VerdandiCommand extends Command {

  inline static var topDir = "generated";

  override public function initialise():Void
  {
    super.initialise();
    print("\nverdandi");
    print("====================================");
    return;
  }

  override public function execute():Void
  {
    super.execute();

    var nextArg = console.getNextArg();
    if (nextArg == null) {
      if (data == null || cast(data, String) == "") {
        error("cannot run 'verdandi' without file name.");
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

    print("start to generate classes.");
    var json = CommandCommon.checkValidJsonFile(filename);
    if(json == null) {
      error(filename + " is invalid json file.");
      return;
    }

    if (Lambda.empty(json.fields())
        || !Lambda.exists(json.fields(), function(f){ return cast(f, String) == "classes"; })) {
      error("fail to parse json file " + filename + ".");
      return;
    }

    var message = generateClass(json, "classes", topDir);
    if (message != "") print(message);
    print("finished to generate classes.");
    print("success to verdandi.\n");
  }

  private function generateClass(json : Dynamic, name : String, topDirectory : String) : String {

    var message = "\n";

    for (pn in json.field(name).fields()) {
      var cnArray = pn.split(".");

      var packageName = pn;
      var dirPath = name;
      if (!Lambda.empty(cnArray)) {
        for (dirName in cnArray) {
          if (dirPath.length == 0) {
            dirPath = dirName;
            }
          else {
            dirPath += "/" + dirName;
          }
          if (!FileSystem.exists(topDirectory + "/" + dirPath)) {
            FileSystem.createDirectory(topDirectory + "/" + dirPath);
          }
        }
      }

      dirPath += "/";
      for (cn in json.field(name).field(pn).fields()) {
        var className = cn;
        var fields = new StringMap<String>();
        for (f in json.field(name).field(pn).field(cn).fields()) {
          fields.set(f, json.field(name).field(pn).field(cn).field(f));
        }
        ClassGenerator.generateClass(packageName, className, fields, dirPath);
        var pname = packageName == "" ? "" : packageName + ".";
        message += "   generate class '" + pname + className + "'.\n";
      }
    }
    return message;
  }
}
