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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("data"));
  }
}
