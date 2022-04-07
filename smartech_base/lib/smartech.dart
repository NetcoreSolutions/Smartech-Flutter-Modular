
import 'dart:async';

import 'package:flutter/services.dart';

class Smartech {
  static const MethodChannel _channel = MethodChannel('smartech_base_channel');

  static final Smartech _smartech = Smartech._internal();

  factory Smartech() => _smartech;

  Smartech._internal() {
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

}
