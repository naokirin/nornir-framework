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

using Reflect;

typedef GeneratorType = String -> String -> StringMap<String> -> String -> Void;

class CommandCommon {

  public static function createGeneratedDirectory(topDir : String) {
    if (!FileSystem.exists(topDir)) {
      FileSystem.createDirectory(topDir);
      return "create directory '" + topDir + "'.";
    }
    return "";
  }

  public static function checkValidJsonFile(path : String) {
    var content = File.getContent(path);

    var json:Dynamic = null;
    try {
      json = Json.parse(content);
    }
    catch (e:Dynamic) {
      return {};
    }

    return json;
  }
}