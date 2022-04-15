import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartech_app/events_utils.dart';
import 'package:smartech_base/smartech.dart';
import 'package:smartech_push/smartech_push.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile_page.dart';
import 'splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  //Firebase initialize and it's callback
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }


  Smartech().onHandleDeeplinkAction(
      (String? link, Map<dynamic, dynamic>? map, bool? isAfterTerminated) {
    if (link == null || link.isEmpty) {
      return;
    }
    if (link.contains('http')) {
      showDialog(
          context: _context,
          builder: (builder) => AlertDialog(
                title: Text(link),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(_context).pop();
                        Smartech().openUrl(link);
                      },
                      child: Text("Ok"))
                ],
              ));
    } else {
      Navigator.of(_context)
          .push(MaterialPageRoute(builder: (builder) => ProfilePage()));
    }
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

//static Build Context
late BuildContext _context;

//get Location
void getLocation() async {
  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
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

//launch url
void launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';


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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  SmartechPush().handlePushNotification(message.data.toString());
}