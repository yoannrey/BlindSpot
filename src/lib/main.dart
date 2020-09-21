import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as prefix;
import 'package:src/SizeConfig.dart';

void main() async {
  final credentials = prefix.SpotifyApiCredentials('d1d31f582c514ff483a45461f4a51003', '7005271fd0b2451e96ee6ea5bbae9d61');
  final spotify = prefix.SpotifyApi(credentials);
  var user = await spotify.me.get();
  print(user.id);
 //  runApp(BlindSpot());
}



class BlindSpot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlindSpot',
      theme: ThemeData(fontFamily: 'Kufam'),
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
            Image.asset(
                'assets/Spotify-Logo.png',
                width: 400, // SizeConfig.safeBlockHorizontal * 25,
                // SizeConfig.safeBlockVertical * 55,
            ),
            const SizedBox(height: 100),
            /*RaisedButton.icon(
              
              label: Text('Connect with'),
              shape: 
              icon: Image.asset('assets/Spotify_Logo_RGB_Black.png', width: 90),

              onPressed: () {},
              
            )*/
            RaisedButton(
              onPressed: () {},
              color: Color(0xff1DB954),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Connect with ',
                    style: TextStyle(fontFamily: 'Boire')),
                  Image.asset('assets/Spotify_Logo_RGB_Black.png', width: 80)
                ],
              ),
              /*color: Colors.purple,*/
            ),
          ],
        )
      )
    );
  }
}
