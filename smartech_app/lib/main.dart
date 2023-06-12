import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:smartech_app/deep_link_screen.dart';
import 'package:smartech_app/events_utils.dart';
import 'package:smartech_app/navigator.dart';
import 'package:smartech_app/update_profile.dart';
import 'package:smartech_appinbox/model/smt_appinbox_model.dart';
import 'package:smartech_base/smartech_base.dart';
import 'package:url_launcher/url_launcher.dart';
import 'splash_screen.dart';

// DeepLinkNavigation deepLinkNavigation = DeepLinkNavigation();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Smartech().onHandleDeeplinkAction((String? smtDeeplink, Map<dynamic, dynamic>? smtCustomPayload) async {
  //   print("smtDeeplinkSource value :" + smtDeeplink.toString());
  //   print("smtCustomPayload value :" + smtCustomPayload.toString());
  //   Future.delayed(const Duration(milliseconds: 1000), () async {
  //     Globle().deepLinkNavigation(smtDeeplink, smtCustomPayload);
  //   });
  // });

  Smartech()
      .onHandleDeeplink((String? smtDeeplinkSource, String? smtDeeplink, Map<dynamic, dynamic>? smtPayload, Map<dynamic, dynamic>? smtCustomPayload) async {
    print("smtDeeplink value :" + smtDeeplink.toString());
    print("smtCustomPayload value :" + smtCustomPayload.toString());
    print("smtDeeplinkSource value :" + smtDeeplinkSource.toString());
    print("smtPayload value :" + smtPayload.toString());
    Future.delayed(const Duration(milliseconds: 1000), () async {
      Globle().deepLinkNavigationWithPayload(smtDeeplinkSource, smtDeeplink, smtPayload, smtCustomPayload);
    });
  });
  await loadEventsJson();
  runApp(MyApp());
  getLocation();
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      // Smartech().setInAppCustomHTMLListener(customHTMLCallback);
      Smartech().setOnInAppClickListener(onInAppCallback);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  Future<void> customHTMLCallback(Map<String, dynamic>? payload) async {
    if (payload != null) {
      log("customHTMLCallback payload" + payload.toString());
    }
  }

  Future<void> onInAppCallback(String? deeplink, Map<String, dynamic>? payload) async {
    if (deeplink != null) {
      log("onInAppCallback deeplink" + deeplink.toString());
    }
    if (payload != null) {
      log("onInAppCallback payload" + payload.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationUtilities.key,
      onGenerateRoute: onGenerateRoute,
      title: 'Base',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

//get Location
void getLocation() async {
  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  // ignore: unused_local_variable
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  _locationData = await location.getLocation();
}

class Globle {
  static final Globle _singleton = Globle._internal();
  SMTAppInboxMessage smtAppInboxMessage = SMTAppInboxMessage();

  factory Globle() {
    return _singleton;
  }

  Globle._internal();
  late BuildContext context;

  deepLinkNavigation(String? link, Map<dynamic, dynamic>? payload) async {
    if (link != null || payload!.isNotEmpty) {
      Map<String, dynamic> dict = HashMap();
      log(payload.toString());
      var encodedJson = json.encode(payload);
      dict["smtCustomPayload"] = json.decode(encodedJson.toString());
      dict["smtDeeplink"] = link;
      if (dict["smtDeeplink"].contains("http")) {
        print("navigate to browser with url");
        final Uri _url = Uri.parse(dict["smtDeeplink"]);
        if (!await launchUrl(_url)) throw 'Could not launch $_url';
      } else if (dict["smtDeeplink"].contains("smartechflutter://profile")) {
        NavigationUtilities.pushRoute(UpdateProfile.route);
      } else {
        NavigationUtilities.pushRoute(
          DeepLinkScreen.route,
          args: dict,
        );
      }
    } else {
      return;
    }
  }

  deepLinkNavigationWithPayload(
      String? smtDeeplinkSource, String? smtDeeplink, Map<dynamic, dynamic>? smtPayload, Map<dynamic, dynamic>? smtCustomPayload) async {
    if (smtPayload != null) {
      smtAppInboxMessage = SMTAppInboxMessage.fromJson(smtPayload['smtPayload'] ?? smtPayload['data'] ?? smtPayload['payload'] ?? {});
    }
    print(smtAppInboxMessage);

    if (smtDeeplink != null || smtCustomPayload!.isNotEmpty) {
      Map<String, dynamic> dict = HashMap();
      dict["smtDeeplink"] = smtDeeplink ?? "";
      dict["smtCustomPayload"] = smtCustomPayload ?? {};
      dict["smtDeeplinkSource"] = smtDeeplinkSource;
      dict["smtPayload"] = smtPayload;
      log(smtCustomPayload.toString());
      if (dict["smtDeeplink"].contains("http")) {
        print("navigate to browser with url");
        final Uri _url = Uri.parse(dict["smtDeeplink"]);
        print(_url);
        if (!await launchUrl(_url)) throw 'Could not launch $_url';
      } else if (dict["smtDeeplink"].contains("smartechflutter://profile")) {
        NavigationUtilities.pushRoute(UpdateProfile.route);
      } else {
        print(dict);
        NavigationUtilities.pushRoute(DeepLinkScreen.route, args: dict);
      }
    } else {
      return;
    }
  }
}
