package;

import massive.haxe.log.Log;
import massive.sys.cmd.CommandLineRunner;
import massive.sys.cmd.ICommand;
import haxe.Resource;

class CommandLineTool extends CommandLineRunner {

  static function main():Void {new CommandLineTool();}

  function new():Void
  {
    super();

    mapCommand(NornCommand, "norn", ["norn"], "Generate from norn file", Resource.getString("help_norn"));
    mapCommand(VerdandiCommand, "verdandi", ["ver"], "Generate classes", Resource.getString("help_verdandi"));
    mapCommand(UrdCommand, "urd", ["urd"], "Generate sender and receiver", Resource.getString("help_urd"));
    run();
  }

  override private function createCommandInstance(commandClass:Class<ICommand>):ICommand
  {
    var command:ICommand = super.createCommandInstance(commandClass);

    var className:String = Type.getClassName(commandClass);
    Log.debug("Command: " + className);

    return command;
  }

  override public function printHeader():Void
  {
    print("\nNornir-framework - Copyright " + Date.now().getFullYear() + " naokirin.\n");
  }

  override public function printUsage():Void
  {
    print("Usage: nornir [subcommand] [options]");
  }

  override public function printHelp():Void
  {}
}
