import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:smartech_appinbox/model/smt_appinbox_model.dart';

class SmartechAppinbox {
  static late CustomHTMLCallback _customHTMLCallback;
  static const MethodChannel _channel = MethodChannel('smartech_appinbox');
  //To make singleton class
  static final SmartechAppinbox _smartechAppinbox = SmartechAppinbox._internal();
  factory SmartechAppinbox() => _smartechAppinbox;
  List<SMTAppInboxMessage> allInboxList = [];
  List<SMTAppInboxMessage> inboxList = [];
  List<MessageCategory> categoryList = [];

  SmartechAppinbox._internal() {
    _channel.setMethodCallHandler(_didRecieveTranscript);
  }

  Future<List<SMTAppInboxMessage>?> getAppInboxMessages() async {
    return await _channel.invokeMethod("getAppInboxMessages").then((value) {
      var json = jsonDecode(value.toString());
      allInboxList = [...json.map((e) => SMTAppInboxMessage.fromJson(e['smtPayload'])).toList()];
      log(allInboxList.toString());
      return allInboxList.isNotEmpty ? allInboxList : [];
    });
  }

  Future<List<MessageCategory>?> getAppInboxCategoryList() async {
    categoryList = [];
    return await _channel.invokeMethod("getAppInboxCategoryList").then((value) {
      var json = jsonDecode(value.toString());
      log(json.toString());
      categoryList = [...json.map((e) => MessageCategory.fromJson(e)).toList()];
      return categoryList.isNotEmpty ? categoryList : [];
    });
  }

  Future<List<SMTAppInboxMessage>?> getAppInboxCategoryWiseMessageList({List<String>? categoryList}) async {
    inboxList = [];
    return await _channel.invokeMethod("getAppInboxCategoryWiseMessageList", {"group_id": categoryList == [] ? [] : categoryList}).then((value) {
      var json = jsonDecode(value.toString());
      inboxList = [...json.map((e) => SMTAppInboxMessage.fromJson(e['smtPayload'])).toList()];
      log(inboxList.toString());
      return inboxList.isNotEmpty ? inboxList : [];
    });
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

  Future<List<SMTAppInboxMessage>?> getAppInboxMessagesByApiCall({int? messageLimit, String? smtInboxDataType, List<String>? categoryList}) async {
    return await _channel.invokeMethod(
      "getAppInboxMessagesByApiCall",
      {
        "messageLimit": messageLimit == 0 ? 10 : messageLimit,
        "smtInboxDataType": smtInboxDataType == "" ? "all" : smtInboxDataType,
        "group_id": categoryList == [] ? [] : categoryList
      },
    ).then((value) {
      var json = jsonDecode(value.toString());
      inboxList = [...json.map((e) => SMTAppInboxMessage.fromJson(e['smtPayload'])).toList()];
      log(inboxList.toString());
      return inboxList.isNotEmpty ? inboxList : [];
    });
  }

  Future<int?> getAppInboxMessageCount({String? smtAppInboxMessageType}) async {
    return await _channel.invokeMethod("getAppInboxMessageCount", {"smtAppInboxMessageType": smtAppInboxMessageType == "" ? "inbox" : smtAppInboxMessageType});
  }

  Future<void> _didRecieveTranscript(MethodCall call) async {
    switch (call.method) {
      case "customHTMLCallback":
        final Map<String, dynamic>? arguments = call.arguments;
        _customHTMLCallback(arguments);
        break;
    }
  }

  Future<void> displayAppInbox() async {
    return await _channel.invokeMethod("displayAppInbox");
  }
}

//custom type defined
typedef CustomHTMLCallback = Future<dynamic> Function(Map<String, dynamic>? payload);
