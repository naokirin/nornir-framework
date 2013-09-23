package;

import nornir.samples.*;
import nornir.samples.MailToMailServerReceiver;
import org.nornir.skuld.SkuldServer;

class TestServer {
  public static function main() {
    var arthur = new Person();
    arthur.name = "Arthur";
    arthur.address = "arthur2040@mnnmail.com";

    var array = [];
    array.push(new Person({name:"Jeff", address:"jeff@mailmail.com"}));
    array.push(new Person({name:"Tony", address:"tony@mailmail.com"}));

    var people = new People({people:array});

    var server = new SkuldServer();
    var id = server.accept("localhost", 5000);

    new MailToAdresseeSender(server, Broadcast)
      .sendMail(new MailData({sender:arthur, receiver:people, subject:"hello!", body:"Hello!"}));

    for(k in people.people) {
      trace("name: " + k.name);
      trace("address: " + k.address + "\n");
    }

    server.receive(id);
  }
}
