import 'package:flutter/material.dart';

class WebBrowsers extends StatefulWidget {
  final String initialUrl;

  WebBrowsers(this.initialUrl);

  @override
  State<StatefulWidget> createState() => _StateWebBrowser();
}

class _StateWebBrowser extends State<WebBrowsers> {
  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("data"));
  }
}
