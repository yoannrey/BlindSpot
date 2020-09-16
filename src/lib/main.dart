import 'package:flutter/material.dart';

void main() => runApp(BlindSpot());



class BlindSpot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Login()
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            Image.asset('assets/autocad-dxf-hello-world-png-clip-art.png'),
            const SizedBox(height: 400),
            const RaisedButton(
              color: Colors.green,// Color(0xff1DB954),
              child: Text(
                  'Coucou',
              style: TextStyle(fontSize: 20)
              ),
              textColor: Colors.white,
              onPressed: null,
            )
          ],
        )
      )
    );
  }
}
