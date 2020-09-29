import 'package:flutter/material.dart';
import 'package:Blindspot/categories.dart';
import 'package:spotify/spotify.dart' as prefix;
import 'package:webview_flutter/webview_flutter.dart';


final authorizationUrl = Uri.parse("https://accounts.spotify.com/authorize");
const scopes = [
  'user-read-email',
  'user-read-private',
  'playlist-modify-public',
  'playlist-read-private',
  'playlist-modify-private',
  'user-library-read'
];
final tokenUrl = Uri.parse("https://accounts.spotify.com/api/token");

void main() {
  runApp(BlindSpot());
}

class BlindSpot extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LoginBtn(),
    );
  }
}


class SpotifyContainer extends InheritedWidget {
  final prefix.SpotifyApi client;
  final prefix.User myDetails;

  SpotifyContainer({this.client, this.myDetails, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static SpotifyContainer of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SpotifyContainer>();

}


class LoginPage extends StatefulWidget {
  final grant = prefix.SpotifyApi.authorizationCodeGrant(prefix.SpotifyApiCredentials('a33521a59f124025999baa9bb36eeb41', '89075e09883a456aa28b624ec1ae2442'));

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  bool shouldShowWebView = false;
  String authUrl;
  Key webviewKey = GlobalKey();


  @override
  void initState() {
    super.initState();
    authUrl = widget.grant.getAuthorizationUrl(
        Uri.parse('blindspot://auth'),
        scopes: ['user-read-email', 'user-read-private']
    ).toString();
  }

  handleRedirect(String uri) async{
    if (uri == null || !uri.startsWith('blindspot://auth'))
      throw 'invalid uri';
    try {
      final client = prefix.SpotifyApi.fromAuthCodeGrant(widget.grant, uri);
      // TODO: save refresh token

      final myDetails = await client.me.get();
      navigateToApp(client, myDetails);
    } catch (e) {
      print ('NOPE     ' + e.toString());
    }

  }

  navigateToApp(prefix.SpotifyApi cli, prefix.User myDetails) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => SpotifyContainer(
          client: cli,
          myDetails: myDetails,
          child: HomeNav(cli)
        )
        ));
  }

  @override
  Widget build(BuildContext context) {
    final widget = WebView(
      key: webviewKey,
      initialUrl: authUrl,
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: (navReq) {
        if (!navReq.url.startsWith('blindspot://auth')) {
          return NavigationDecision.navigate;
        }
        setState(() {
          shouldShowWebView = false;
        });
        handleRedirect(navReq.url);
        return NavigationDecision.navigate;
      },
    );

    return Scaffold(
        body: widget
    );
  }

  @override
  void dispose() {
      super.dispose();
  }
}

class LoginBtn extends StatefulWidget {
  @override
  _LoginBtnState createState() => _LoginBtnState();
}

class _LoginBtnState extends State<LoginBtn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff191414),
        body: Container(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50),
                Center(
                  child: Image.asset('assets/Spotify_Icon_RGB_Green.png', width: 350),
                ),
                const SizedBox(height: 400),
                Center(child:
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  color: Color(0xff1DB954),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Connect with ',
                          style: TextStyle(fontFamily: 'Railway')),
                      Image.asset('assets/Spotify_Logo_RGB_Black.png', width: 80),
                    ],
                  ),
                  /*color: Colors.purple,*/
                ),
                ),
              ],
            )
        )
    );
  }
}
