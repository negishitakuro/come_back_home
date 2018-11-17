import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Come Back Home',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'Come Back Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _username = 'gmail';
  final String _password = 'password';

  void _incrementCounter() async {
    // setState(() {
      final smtpServer = gmail(_username, _password);

      final message = new Message()
        ..from = new Address(_username)
        ..recipients.add('toAddress')
        // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
        // ..bccRecipients.add(new Address('bccAddress@example.com'))
        ..subject = 'title'
        ..text = 'message';
        
      final sendReports = await send(message, smtpServer);

      // Scaffold.of(context).showSnackBar(new SnackBar(
      //   content: new Text('success send e-mail!'),
      // ));

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(),
          ],
        ),
      ),
      
      floatingActionButton: new Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'send e-mail',
            child: Icon(Icons.mail),
          );
        }
      )
    );
  }
}
