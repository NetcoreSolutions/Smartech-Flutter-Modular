
import 'dart:async';

import 'package:flutter/services.dart';

class Smartech {

  static const MethodChannel _channel = MethodChannel('smartech_base_channel');

  //To make singleton class
  static final Smartech _smartech = Smartech._internal();
  factory Smartech() => _smartech;
  Smartech._internal() {
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

}

class DebugLevel {
  static const int verbose = 1;
  static const int debug = 2;
  static const int info = 3;
  static const int warn = 4;
  static const int error = 5;
  static const int fatal = 6;
  static const int none = 7;
}

//custom type defined
typedef CustomHTMLCallback = Future<dynamic> Function(Map<String, dynamic>? payload);
typedef OnhandleDeeplinkAction = Function(String? deeplinkigUrl,Map<dynamic, dynamic>? payload, bool? isAfterTerminated);

