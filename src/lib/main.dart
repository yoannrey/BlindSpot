import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as prefix;

void main() async {
  final credentials = prefix.SpotifyApiCredentials('d1d31f582c514ff483a45461f4a51003', '7005271fd0b2451e96ee6ea5bbae9d61');
  final spotify = prefix.SpotifyApi(credentials);
  var user = await spotify.me;
  user);
  //  runApp(BlindSpot());
}



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
      backgroundColor: Color(0xff191414),
      body: Container(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            Image.asset('assets/autocad-dxf-hello-world-png-clip-art.png'),
            const SizedBox(height: 600),
            ButtonTheme(
              minWidth: 300,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Colors.green,

                onPressed: () {},
                child: const Text(
                    'Connect with ',
                    style: TextStyle(fontSize: 20)
                ),
              ),
            )
          ],
        )
      )
    );
  }
}
