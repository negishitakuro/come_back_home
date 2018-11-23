import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Come Back Home',
      theme: ThemeData.light().copyWith(
          inputDecorationTheme:
              InputDecorationTheme(border: OutlineInputBorder())),
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
  final String _username = '@gmail.com';
  final String _password = '';
  final String _initMailAddress = '@ezweb.ne.jp';

  bool isNow = false;
  bool isEatAtHome = true;
  String distMailAddress = '@ezweb.ne.jp';
  TimeOfDay time = TimeOfDay.now();
  final timeFormat = DateFormat("h:mm a");

  void _sendMail() async {
      final smtpServer = gmail(_username, _password);

      final message = new Message()
        ..from = new Address(_username)
        ..recipients.add(distMailAddress)
        // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
        // ..bccRecipients.add(new Address('bccAddress@example.com'))
        ..subject = ""
        ..text = getMessage();
        
      final sendReports = await send(message, smtpServer);

      if (sendReports.first.sent) {
        showToast("Success send message!");
      } else {
        showToast("Faild send message...");
      }


      // showToast(getMessage());

  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      bgcolor: "#e74c3c",
      textcolor: '#ffffff'
    );
  }

  String getMessage() {
    String mes = """●●です。
""";
    if (isNow) {
      mes += """今から帰ります！
""";
    } else {
      mes += time.toString().replaceAll("TimeOfDay(", "").replaceAll(")", "") + """頃に帰ります！
""";
    }
    if (isEatAtHome) {
      mes += "夕飯は家で食べます！";
    } else {
      mes += "夕飯は要らないです！";
    }
    return mes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding (
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 16.0),
            TextFormField(
              initialValue: _initMailAddress,
              decoration: InputDecoration(labelText: '送信先 E-mail'),
              onSaved: (t) => setState(() => distMailAddress = t),
            ),

            SizedBox(height: 16.0),
            TimePickerFormField(
              initialTime: time,
              format: timeFormat,
              // todo
              // editable: !isNow,
              // enabled: !isNow,
              decoration: InputDecoration(labelText: '帰宅予定時刻'),
              onChanged: (t) => setState(() => time = t),
            ),

            SizedBox(height: 16.0),
            SwitchListTile(
              title: const Text('今から帰ります！'),
              value: isNow,
              onChanged: (flag) => setState(() => isNow = flag),
            ),

            SizedBox(height: 16.0),
            SwitchListTile(
              title: const Text('夕飯家で食べます！'),
              value: isEatAtHome,
              onChanged: (flag) => setState(() => isEatAtHome = flag),
            ),
          ],
        ),
      ),
      
      floatingActionButton: new Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: _sendMail,
            tooltip: 'send e-mail',
            child: Icon(Icons.mail),
          );
        }
      )
    );
  }
}

