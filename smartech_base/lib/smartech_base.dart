import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';

class Smartech {
  static const MethodChannel _channel = MethodChannel('smartech_base');
  static late CustomHTMLCallback _customHTMLCallback;
  static late OnInAppClickCallback _onInAppClickCallback;
  static late OnhandleDeeplinkAction _onhandleDeeplinkAction;
  static late OnhandleDeeplink _onhandleDeeplink;

  //To make singleton class
  static final Smartech _smartech = Smartech._internal();
  factory Smartech() => _smartech;
  Smartech._internal() {
    _channel.setMethodCallHandler(didRecieveDeeplinkCallback);
  }

  //bridge functions
  Future<void> setDebugLevel(int level) async {
    await _channel.invokeMethod('setDebugLevel', level);
  }

  Future<void> trackAppInstall() async {
    await _channel.invokeMethod('trackAppInstall');
  }

  Future<void> trackAppUpdate() async {
    await _channel.invokeMethod('trackAppUpdate');
  }

  Future<String?> getDeviceGuid() async {
    return await _channel.invokeMethod('getDeviceGuid');
  }

  Future<void> trackAppInstallUpdateBySmartech() async {
    await _channel.invokeMethod('trackAppInstallUpdateBySmartech');
  }

  Future<void> setInAppCustomHTMLListener(CustomHTMLCallback customHTMLCallback) async {
    _customHTMLCallback = customHTMLCallback;
    await _channel.invokeMethod('setInAppCustomHTMLListener');
  }

  Future<void> setOnInAppClickListener(OnInAppClickCallback onInAppClickCallback) async {
    _onInAppClickCallback = onInAppClickCallback;
    await _channel.invokeMethod('setOnInAppClickListener');
  }

  Future<void> updateUserProfile(Map<String, dynamic> map) async {
    await _channel.invokeMethod("updateUserProfile", map);
  }

  Future<void> setUserIdentity(String userIdentity) async {
    await _channel.invokeMethod("setUserIdentity", userIdentity);
  }

  Future<void> login(String userIdentity) async {
    await _channel.invokeMethod("login", userIdentity);
  }

  Future<void> clearUserIdentity() async {
    await _channel.invokeMethod("clearUserIdentity");
  }

  Future<void> logoutAndClearUserIdentity(bool clearUserIdentity) async {
    await _channel.invokeMethod("logoutAndClearUserIdentity", clearUserIdentity);
  }

  Future<void> trackEvent(String eventName, Map<String, dynamic> eventData) async {
    await _channel.invokeMethod("trackEvent", {"event_name": eventName, "event_data": eventData});
  }

  Future<String?> getDeviceUniqueId() async {
    return await _channel.invokeMethod("getDeviceUniqueId");
  }

  Future<void> setUserLocation(double latitude, double longitude) async {
    var map = {"latitude": latitude, "longitude": longitude};
    await _channel.invokeMethod("setUserLocation", map);
  }

  Future<void> optTracking(bool isOpted) async {
    await _channel.invokeMethod("optTracking", isOpted);
  }

  Future<bool?> hasOptedTracking() async {
    return await _channel.invokeMethod("hasOptedTracking");
  }

  Future<void> optInAppMessage(bool isOpted) async {
    await _channel.invokeMethod("optInAppMessage", isOpted);
  }

  Future<bool?> hasOptedInAppMessage() async {
    return await _channel.invokeMethod("hasOptedInAppMessage");
  }

  Future<void> processEventsManually() async {
    await _channel.invokeMethod("processEventsManually");
  }

  Future<String?> getUserIdentity() async {
    return await _channel.invokeMethod("getUserIdentity");
  }

  Future<void> openNativeWebView() async {
    return _channel.invokeMethod("openNativeWebView");
  }

  Future<void> onHandleDeeplinkAction(OnhandleDeeplinkAction onhandleDeeplinkAction) async {
    _onhandleDeeplinkAction = onhandleDeeplinkAction;
    await _channel.invokeMethod("onHandleDeeplinkAction");
  }

  Future<void> onHandleDeeplink(OnhandleDeeplink onhandleDeeplink) async {
    _onhandleDeeplink = onhandleDeeplink;
    await _channel.invokeMethod("onHandleDeeplinkAction");
  }

  Future<void> onHandleDeeplinkActionBackground() async {
    await _channel.invokeMethod("onHandleDeeplinkActionBackground");
  }

  Future<void> openUrl(String url) async {
    await _channel.invokeMethod('openUrl', url);
  }

  Future<String?> getAppID() async {
    return await _channel.invokeMethod('getAppID');
  }

  Future<String?> getSDKVersion() async {
    return await _channel.invokeMethod('getSDKVersion');
  }

  Future<void> setDeviceAdvertiserId(String id) async {
    await _channel.invokeMethod('setDeviceAdvertiserId', id);
  }

  Future<String?> getDevicePushToken() async {
    return await _channel.invokeMethod("getDevicePushToken");
  }

  Future<void> didRecieveDeeplinkCallback(MethodCall call) async {
    switch (call.method) {
      case "customHTMLCallback":
        log("customHTMLCallback invoked" + call.arguments);
        final Map<String, dynamic>? arguments = call.arguments;
        _customHTMLCallback(arguments);
        break;

      case "onCustomHtmlInAppClick":
        Map<String, dynamic>? map;
        try {
          map = json.decode(call.arguments["smtCustomPayload"]);
        } catch (e) {
          log(e.toString());
        }
        _onInAppClickCallback(call.arguments["smtDeeplink"], map);
        break;

      case "onhandleDeeplinkAction":
        String? smtDeeplinkSource;
        String? smtDeeplink;
        Map<dynamic, dynamic>? smtPayloadMap;
        Map<dynamic, dynamic>? smtCustomPayloadMap;

        smtDeeplinkSource = call.arguments["smtDeeplinkSource"];
        smtDeeplink = call.arguments["smtDeeplink"];
        smtPayloadMap = call.arguments["smtPayload"] as Map<dynamic, dynamic>?;
        smtCustomPayloadMap = call.arguments["smtCustomPayload"] as Map<dynamic, dynamic>?;

        try {
          _onhandleDeeplinkAction(smtDeeplink, smtCustomPayloadMap);
        } catch (e) {}

        try {
          _onhandleDeeplink(smtDeeplinkSource, smtDeeplink, smtPayloadMap, smtCustomPayloadMap);
        } catch (e) {}
        break;
    }
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
  static const int all = 9;
}

//custom type defined
typedef OnInAppClickCallback = Future<dynamic> Function(String? deepLink, Map<String, dynamic>? payload);
typedef CustomHTMLCallback = Future<dynamic> Function(Map<String, dynamic>? payload);
typedef OnhandleDeeplinkAction = Function(String? smtDeeplink, Map<dynamic, dynamic>? smtCustomPayload);
typedef OnhandleDeeplink = Function(String? smtDeeplinkSource, String? smtDeeplink, Map<dynamic, dynamic>? smtPayload, Map<dynamic, dynamic>? smtCustomPayload);
