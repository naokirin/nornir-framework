package;

import nornir.samples.Person;
import nornir.samples.People;
import nornir.samples.MailToMailServerSender;
import nornir.samples.MailData;

import org.nornir.urd.*;

class Sender implements ISender {

  public function new() {}

  public function send(data : Dynamic, id : String) : Void {
    UrdReceiver.receive(data);
  }
  public function broadcast(data : Dynamic) : Void {
    UrdReceiver.receive(data);
  }
}


class Test {
  public static function main() {
    var arthur = new Person();
    arthur.name = "Arthur";
    arthur.address = "arthur2040@mnnmail.com";

    var array = [];
    array.push(new Person({name:"Jeff", address:"jeff@mailmail.com"}));
    array.push(new Person({name:"Tony", address:"tony@mailmail.com"}));

    var people = new People({people:array});

    for(k in people.people) {
      trace("name: " + k.name);
      trace("address: " + k.address + "\n");
    }

    new MailToMailServerSender(new Sender(), Broadcast)
      .sendMail(new MailData({sender:arthur, receiver:people, subject:"hello!", body:"Hello!"}));
  }
}
