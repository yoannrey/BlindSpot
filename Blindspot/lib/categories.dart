import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class CategoriesPage extends StatefulWidget {
  final authUri;
  final redirectUri;
  CategoriesPage(
      this.authUri,
      this.redirectUri);
  @override
  _CategoriesPageState createState() => _CategoriesPageState(this.authUri, this.redirectUri);
}

class _CategoriesPageState extends State<CategoriesPage> {
  var _authUri;
  var _redirectUri;
  _CategoriesPageState(this._authUri, this._redirectUri);
  @override
  Widget build(BuildContext context) {
    var responseUri;
    return Container(
      child: WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: _authUri,
      navigationDelegate: (navReq) {
        if (navReq.url.startsWith(_redirectUri)) {
          responseUri = navReq.url;
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ));
  }
}
