import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_base/smartech_base.dart';
import 'events_utils.dart' as eventUtils;

class PayloadScreen extends StatefulWidget {
  final eventUtils.CategoryModel category;
  PayloadScreen(this.category);

  @override
  _PayloadScreenState createState() => _PayloadScreenState();
}

// class abcModel extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Text('abc'),
//         ],
//       ),
//     );
//   }
// }

class _PayloadScreenState extends State<PayloadScreen> {
  TextEditingController _payloadController = TextEditingController();
  String _eventName = "";

  @override
  void initState() {
    super.initState();
    print("payload ==> ${jsonDecode(jsonEncode(widget.category.payload))}");
    _payloadController.text = JsonEncoder.withIndent("     ").convert(jsonDecode(jsonEncode(widget.category.payload)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        centerTitle: true,
        backgroundColor: AppColor.secondary,
      ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                if (widget.category.category == "Custom Events")
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Here you can send some custom custom payload in JSON format which will then be auto discovered by Smartech Panel",
                        style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.grey.shade200,
                        child: TextField(
                          decoration: const InputDecoration(hintText: "Please enter event name", contentPadding: EdgeInsets.all(5)),
                          onChanged: (value) {
                            _eventName = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      child: Text(
                        "Paste",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      color: Colors.blue,
                      onPressed: () async {
                        ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
                        if (data != null) {
                          if (data.text != null) {
                            print("Paste ==> ${data.text}");
                            setState(() {
                              _payloadController.text = data.text!;
                            });
                          }
                        }
                      },
                    ),
                    MaterialButton(
                      child: Text(
                        "Copy",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      color: AppColor.accent1,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _payloadController.text));
                        showToast("Copied");
                      },
                    ),
                    if (widget.category.category == "Custom Events")
                      MaterialButton(
                        child: Text(
                          "Clear",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        color: Colors.red,
                        onPressed: () {
                          _payloadController.text = "";
                        },
                      ),
                    MaterialButton(
                      child: Text(
                        "Send",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      color: Colors.deepOrange,
                      onPressed: () async {
                        if (_payloadController.text.isEmpty) {
                          showToast("Payload must be required");
                          return;
                        }

                        if (_eventName.isEmpty && widget.category.category == "Custom Events") {
                          showToast("Event name must be required");
                          return;
                        }

                        try {
                          final data = jsonDecode(_payloadController.text);
                          if (widget.category.category == "Custom Events") {
                            await Smartech().trackEvent(_eventName, data);
                          } else {
                            await Smartech().trackEvent(widget.category.name, data);
                          }
                          showToast("Submitted");
                        } catch (e) {
                          showToast("Invalid payload");
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.grey.shade200,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Profile Details",
                        style: TextStyle(color: AppColor.secondary, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      TextFormField(
                        controller: _payloadController,
                        maxLines: 10000,
                        minLines: 20,
                        decoration: InputDecoration(
                          alignLabelWithHint: false,
                          border: InputBorder.none,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
