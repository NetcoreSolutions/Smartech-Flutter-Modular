import 'dart:async';
import 'package:flutter/services.dart';

class SmartechAppinbox {
  static late CustomHTMLCallback _customHTMLCallback;
  static const MethodChannel _channel = MethodChannel('smartech_appinbox');
  //To make singleton class
  static final SmartechAppinbox _smartechAppinbox = SmartechAppinbox._internal();
  factory SmartechAppinbox() => _smartechAppinbox;
  SmartechAppinbox._internal() {
    _channel.setMethodCallHandler(_didRecieveTranscript);
  }

  Future<String?> getPlatformVersion() async {
    return await _channel.invokeMethod("getPlatformVersion");
  }

  Future<void> displayAppInbox() async {
    return await _channel.invokeMethod("displayAppInbox");
  }

  Future<dynamic> getAppInboxMessages() async {
    return await _channel.invokeMethod("getAppInboxMessages");
  }

  Future<dynamic> getAppInboxCategoryList() async {
    return await _channel.invokeMethod("getAppInboxCategoryList");
  }

  Future<dynamic> getAppInboxCategoryWiseMessageList(List<String> categoryList) async {
    return await _channel.invokeMethod("getAppInboxCategoryWiseMessageList", {"group_id": categoryList});
  }

  Future<void> markMessageAsDismissed(String trid) async {
    await _channel.invokeMethod("markMessageAsDismissed", {"trid": trid});
  }

  Future<void> markMessageAsClicked(String deeplink, String trid) async {
    await _channel.invokeMethod("markMessageAsClicked", {"deeplink": deeplink, "trid": trid});
  }

  Future<void> markMessageAsViewed(String trid) async {
    await _channel.invokeMethod("markMessageAsViewed", {"trid": trid});
  }

  Future<dynamic> getAppInboxMessagesByApiCall() async {
    return await _channel.invokeMethod("getAppInboxMessagesByApiCall");
  }

  Future<void> _didRecieveTranscript(MethodCall call) async {
    switch (call.method) {
      case "customHTMLCallback":
        final Map<String, dynamic>? arguments = call.arguments;
        _customHTMLCallback(arguments);
        break;
    }
  }
}

//custom type defined
typedef CustomHTMLCallback = Future<dynamic> Function(Map<String, dynamic>? payload);
