import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_base/smartech_base.dart';

class CustomProfilePayloadScreen extends StatefulWidget {
  const CustomProfilePayloadScreen({Key? key}) : super(key: key);

  @override
  _CustomProfilePayloadScreenState createState() => _CustomProfilePayloadScreenState();
}

class _CustomProfilePayloadScreenState extends State<CustomProfilePayloadScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Widget> imageSliders = [];

  @override
  void initState() {
    super.initState();
    var map = {
      "first_name": "",
      "last_name": "",
      "email": "",
      "url": "",
      "dob": "",
    };

    _controller.text = JsonEncoder.withIndent("     ").convert(map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Custom Profile Update"),
        centerTitle: true,
        backgroundColor: AppColor.secondary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Here you can send some custom profile payload in JSON format which will then be saved on Smartech Panel",
                  style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              _controller.text = data.text!;
                            });
                          }
                        }
                      },
                    ),
                    MaterialButton(
                      child: Text(
                        "Clear",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        _controller.text = "";
                      },
                    ),
                    MaterialButton(
                      child: Text(
                        "Update",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      color: Colors.deepOrange,
                      onPressed: () async {
                        if (_controller.text.isEmpty) {
                          showToast("Payload must be required");
                          return;
                        }

                        try {
                          final data = jsonDecode(_controller.text);
                          await Smartech().updateUserProfile(data);
                          showToast("Updated");
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
                        "Profile JSON Payload",
                        style: TextStyle(color: Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      TextFormField(
                        controller: _controller,
                        maxLines: 10000,
                        minLines: 10,
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
