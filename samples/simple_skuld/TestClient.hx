package;

import nornir.samples.MailData;
import nornir.samples.People;
import nornir.samples.Person;
import nornir.samples.MailToAdresseeReceiver;
import nornir.samples.MailToMailServerSender;
import org.nornir.skuld.SkuldClient;

class TestClient {
  public static function main() {
    var client = new SkuldClient();
    client.connect("localhost", 5000);
    client.receive();

    var jeff = new Person({name:"Jeff", address:"jeff@mailmail.com"});
    var arthur = new Person({name:"Arthur", address:"arthur2040@mnnmail.com"});

    var array = []; array.push(arthur);
    var people = new People({people:array});

    new MailToMailServerSender(client, Id(client.connectionId))
      .sendMail(new MailData({sender:jeff, receiver:people, subject:"Re:hello!", body:"Thx!"}));
  }
}
