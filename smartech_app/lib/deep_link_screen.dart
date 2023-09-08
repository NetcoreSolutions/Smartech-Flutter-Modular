import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:smartech_app/app_inbox/app_inbox_class_screen.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_app/main.dart';
import 'package:smartech_appinbox/model/smt_appinbox_model.dart';

class DeepLinkScreen extends StatefulWidget {
  static const String route = "DeepLinkScreen";
  final Map<dynamic, dynamic>? args;
  DeepLinkScreen({Key? key, this.args}) : super(key: key);

  @override
  State<DeepLinkScreen> createState() => _DeepLinkScreenState();
}

class _DeepLinkScreenState extends State<DeepLinkScreen> {
  var list = [];
  bool isFromScreen = false;
  TextEditingController _controller = TextEditingController();
  // Map<String, dynamic>? object;
  dynamic encodedJson;

  @override
  void initState() {
    encodedJson = json.encode(widget.args);
    print(encodedJson.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Globle().context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Data"),
        centerTitle: true,
        backgroundColor: AppColor.secondary,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 16,
          ),
          Center(child: Text("Deeplink Url")),
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    widget.args?['smtDeeplink'] == "" ? "-" : widget.args?['smtDeeplink'] ?? "-",
                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                child: Text(
                  "Copy",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _controller.text));
                  showToast("Copied");
                },
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: JsonViewer(json.decode(encodedJson)),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                child: Text(
                  "SMTAppInbox Class",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () {
                  SMTAppInboxMessage smtAppInboxMessage = SMTAppInboxMessage();
                  smtAppInboxMessage = SMTAppInboxMessage.fromJson(widget.args?['smtPayload']['data'] ?? widget.args?['smtPayload']['smtPayload']);
                  print(smtAppInboxMessage);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppInboxClassScreen(args: smtAppInboxMessage),
                      ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DeepLinkData {
  String? keyTitle;
  String? keyValue;
  DeepLinkData(this.keyTitle, this.keyValue);
}
