import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartech_app/deep_link_screen.dart';
import 'package:smartech_app/events_utils.dart';
import 'package:smartech_app/navigator.dart';
import 'package:smartech_app/service_locator.dart';
import 'package:smartech_base/smartech.dart';
import 'package:smartech_push/smartech_push.dart';
import 'package:url_launcher/url_launcher.dart';
import 'splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Start time: " + DateTime.now().toString());
  await Firebase.initializeApp();
  log("End time: " + DateTime.now().toString());

  SmartechPush().handlePushNotification(message.data.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  await Firebase.initializeApp();

  //Firebase initialize and it's callback

  // if (Platform.isAndroid) {
  // await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Smartech().onHandleDeeplinkAction((String? link, Map<dynamic, dynamic>? map, bool? isAfterTerminated) async {
    log(map.toString());

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
      } else {
        NavigationUtilities.pushRoute(
          DeepLinkScreen.route,
          args: dict,
        );
      }
    } else {
      return;
    }
  });
  // }
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
      setupFirebase();
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
  //location.enableBackgroundMode(enable: true);

  _locationData = await location.getLocation();
}

//Firebase initialize and it's callback
//store and push firebase device token
void setupFirebase() async {
  var token = await FirebaseMessaging.instance.getToken();
  debugPrint(token);

  if (token != null) {
    var _shp = await SharedPreferences.getInstance();
    var saveToken = _shp.get("token") ?? "";
    //check if token is changed or not
    if (saveToken != token) {
      _shp.setString(token, "token");
      SmartechPush().setDevicePushToken(token);
    }
  }

  FirebaseMessaging.onMessage.listen((event) {
    SmartechPush().handlePushNotification(event.data.toString());
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    SmartechPush().handlePushNotification(event.data.toString());
  });
  FirebaseMessaging.instance.getInitialMessage().then((event) {
    if (event != null) {
      SmartechPush().handlePushNotification(event.data.toString());
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

class Globle {
  static final Globle _singleton = Globle._internal();

  factory Globle() {
    return _singleton;
  }

  Globle._internal();
  late BuildContext context;
}
