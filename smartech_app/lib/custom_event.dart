import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_base/smartech_base.dart';

class CustomeEventPage extends StatefulWidget {
  const CustomeEventPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomeEventState();
}

class _CustomeEventState extends State<CustomeEventPage> {
  var eventName = '';
  var eventData = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Event"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(),
                child: TextField(
                  decoration: InputDecoration(hintText: "Event name"),
                  onChanged: (value) {
                    eventName = value;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(),
                child: TextField(
                  decoration: InputDecoration(hintText: "Event Data"),
                  onChanged: (value) {
                    eventData = value;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (eventName.isEmpty) {
                      showToast("Please Enter event Name");
                      return;
                    }
                    if (eventData.isEmpty) {
                      showToast("Please add event data");
                      return;
                    }
                    var jsonData = json.decode(eventData);

                    if (jsonData == null) {
                      showToast("event data not in proper formate");
                      return;
                    }
                    Smartech().trackEvent(eventName, jsonData);
                  },
                  child: Text("Send"))
            ],
          ),
        ),
      ),
    );
  }
}
