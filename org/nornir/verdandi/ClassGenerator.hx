package org.nornir.verdandi;

import sys.io.File;
import haxe.ds.StringMap;
using Reflect;

class ClassGenerator {

  public static function generateClass(packageName : String, className : String, fields : StringMap<String>, dirPath : String) : Void {
    var resource = haxe.Resource.getString("verdandi_gen_class");
    var t = new haxe.Template(resource);

    var output = t.execute(createTextForTemplate(packageName, className, fields));
    File.saveContent("generated/" + dirPath + className + ".hx", output);
  }

  private static function createTextForTemplate(packageName : String, className : String, fields : StringMap<String>) : Dynamic {

    var fieldsText = "";
    var newArgText = "?obj : {";
    var newSubstitution = "    if (obj != null) {\n";

    var isLoopFirst = true;

    for (name in fields.keys()) {
      if (isLoopFirst) {
        isLoopFirst = false;
      }
      else {
        fieldsText += "\n";
        newArgText += ", ";
      }

      var typeName = fields.get(name);
      fieldsText += "  public var " + name + " : " + typeName + ";";
      newArgText += name + " : " + typeName;
      newSubstitution += "      " + name + " = obj." + name + ";\n";
    }

    newArgText += "}";
    newSubstitution += "    }";

    return {package_name:packageName, class_name:className, fields:fieldsText, new_arg:newArgText, new_substitution:newSubstitution};
  }
}
