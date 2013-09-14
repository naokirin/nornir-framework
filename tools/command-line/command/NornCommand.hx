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

class NornCommand extends Command {

  override public function initialise():Void
  {
    super.initialise();
    var nextArg = console.getNextArg();

    if (nextArg == null) {
      error("cannot run 'norn' without file name.");
      return;
    }
    else {
      var norn = parseNornFile(nextArg);

      if (norn.message != "") {
        error(norn.message);
        return;
      }

      for (command in norn.commands) {
        for (file in norn.files) {
          if (command == "verdandi") addPostRequisite(VerdandiCommand, file);
          if (command == "urd") addPostRequisite(UrdCommand, file);
        }
      }
    }
  }

  override public function execute():Void
  {
    super.execute();
  }

  public static function parseNornFile(path : String) {

    var message = "";
    if (path == null) {
      message += "cannot run 'verdandi config' without file name.\n";
      return { files:[], commands:[], message:message};
    }
    if (!FileSystem.exists(path)){
      message += "no such file " + path;
      return { files:[], commands:[], message:message};
    }
    var fin = sys.io.File.read(path, false);
    var files = [];
    var commands = [];
    try {
      while (true) {
        var line = fin.readLine();
        if (line != "") {
          var jsonLine = ~/^-j (.*)$/;
          if (jsonLine.match(line)) {
            var file = jsonLine.matched(1);
            if (file != "") files.push(file);
          }
          else {
            commands.push(line);
          }
        }
      }
    } catch (e:haxe.io.Eof) { }
    fin.close();

    if (Lambda.empty(files) && Lambda.empty(commands)) {
      message += "the file is empty.\n";
      return { files:[], commands:[], message:message};
    }
    else if (Lambda.empty(files)) {
      message += "should be specified json files.\n";
      return { files:[], commands:[], message:message};
      }
    else if (Lambda.empty(commands)) {
      message += "should be specified commands.\n";
      return { files:[], commands:[], message:message};
    }

    return {files:files, commands:commands, message:message};
  }
}
