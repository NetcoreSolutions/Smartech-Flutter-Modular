import 'package:flutter/material.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_app/main.dart';

class DeepLinkScreen extends StatefulWidget {
  static const String route = "DeepLinkScreen";
  final dynamic args;
  DeepLinkScreen({Key? key, this.args}) : super(key: key);

  @override
  State<DeepLinkScreen> createState() => _DeepLinkScreenState();
}

class _DeepLinkScreenState extends State<DeepLinkScreen> {
  var list = [];
  bool isFromScreen = false;

  @override
  void initState() {
    isFromScreen = widget.args['isFromScreen'];
    if (!isFromScreen) {
      list = widget.args['deepLinkData'].entries.map((e) => DeepLinkData(e.key, e.value)).toList();
    }
    print(list);
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
      body: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Text("Deep Link Url :"),
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    !isFromScreen
                        ? widget.args["deepLinkUrl"].toString() == ""
                            ? "-"
                            : widget.args["deepLinkUrl"].toString()
                        : widget.args["actionDeeplink"].toString() == ""
                            ? "-"
                            : widget.args["actionDeeplink"].toString(),
                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text("Custom PayLoad :"),
          Expanded(
            child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                list[index].keyTitle.toString() + " : ",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              Text(
                                list[index].keyValue.toString(),
                              ),
                            ],
                          ),
                        );
                      }),
                )),
          )
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
