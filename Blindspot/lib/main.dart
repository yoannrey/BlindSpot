import 'package:flutter/material.dart';
import 'package:Blindspot/categories.dart';
import 'package:spotify/spotify.dart';
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
      home: LoginPage(),
    );
  }
}


class SpotifyContainer extends InheritedWidget {
  final SpotifyApi client;
  final User myDetails;

  SpotifyContainer({this.client, this.myDetails, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static SpotifyContainer of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SpotifyContainer>();

}


class LoginPage extends StatefulWidget {
  final grant = SpotifyApi.authorizationCodeGrant(SpotifyApiCredentials('a33521a59f124025999baa9bb36eeb41', '89075e09883a456aa28b624ec1ae2442'));

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
      print('AH BON       ' + authUrl);
      final client = SpotifyApi.fromAuthCodeGrant(widget.grant, uri);
      // TODO: save refresh token

      final myDetails = await client.me.get();
      navigateToApp(client, myDetails);
    } catch (e) {
      print ('NOPE     ' + e.toString());
    }

  }

  navigateToApp(SpotifyApi cli, User myDetails) {
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
      /*onWebViewCreated: (ctr) {
        ctr.clearCache();
      },*/
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
    ); /*: Container(
      color: Theme.of(context).backgroundColor,
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Welcome to Spotify Manager!\r\nWe'll start right away!", textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1,),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: SizedBox(width: 70, height: 70,child: CircularProgressIndicator()),
                ),
              ])),
    );*/
    return Scaffold(
        body: widget
    );
  }

  @override
  void dispose() {
//    _sub.cancel();
      super.dispose();
  }
}
