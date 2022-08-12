import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:smartech_app/deep_link_screen.dart';
import 'package:smartech_app/events_utils.dart';
import 'package:smartech_app/navigator.dart';
import 'package:smartech_app/update_profile.dart';
import 'package:smartech_base/smartech_base.dart';
import 'package:url_launcher/url_launcher.dart';
import 'splash_screen.dart';

// DeepLinkNavigation deepLinkNavigation = DeepLinkNavigation();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Smartech().onHandleDeeplinkAction((String? link, Map<dynamic, dynamic>? map, bool? isAfterTerminated) async {
    print("is after terminated " + isAfterTerminated.toString());
    Future.delayed(const Duration(milliseconds: 500), () async {
      Globle().deepLinkNavigation(link, map, isAfterTerminated);
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
      Smartech().setInAppCustomHTMLListener(customHTMLCallback);
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
    print(payload);
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

  factory Globle() {
    return _singleton;
  }

  Globle._internal();
  late BuildContext context;

  deepLinkNavigation(String? link, Map<dynamic, dynamic>? map, bool? isAfterTerminated) async {
    if (link.toString() != "" || map!.isNotEmpty) {
      Map<String, dynamic> dict = HashMap();
      log(map.toString());
      dict["deepLinkData"] = map;
      dict["deepLinkUrl"] = link;
      dict["isFromScreen"] = false;
      if (link!.contains("http")) {
        print("navigate to browser with url");
        final Uri _url = Uri.parse(dict["deepLinkUrl"]);
        if (!await launchUrl(_url)) throw 'Could not launch $_url';
      } else if (link.contains("smartechflutter://profile")) {
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
}
