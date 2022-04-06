
import 'dart:async';

import 'package:flutter/services.dart';

class SmartechBase {
  static const MethodChannel _channel = MethodChannel('smartech_base');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
