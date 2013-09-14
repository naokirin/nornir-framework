package;

import nornir.samples.Person;
import nornir.samples.People;
import nornir.samples.MailSender;

import org.nornir.urd.ISender;
import org.nornir.urd.IPack;
import org.nornir.urd.UrdReceiver;
import nornir.samples.MailReceiver;


class Pack implements IPack {

  public function new() {}

  public function pack(data : Dynamic) : Dynamic {
    return data;
  }
  public function unpack(data : Dynamic) : Dynamic {
    return data;
  }
}

class Sender implements ISender {

  public function new() {}

  public function send(data : Dynamic) : Void {
    new UrdReceiver(new Pack()).receive(data);
  }
}


class Test {
  public static function main() {
    var arthur = new Person();
    arthur.name = "Arthur";
    arthur.age = 24;

    var array = [];
    array.push(arthur);
    array.push(new Person({name:"Jeff", age:23}));
    array.push(new Person({name:"Tony", age:36}));

    var people = new People({people:array});

    for(k in people.people) {
      trace("name: " + k.name);
      trace("age: " + k.age + "\n");
    }

    new MailSender(new Pack(), new Sender()).sendMail(arthur);
  }
}
