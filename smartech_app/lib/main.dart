import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:smartech_base/smartech.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_screen.dart';
import 'profile_page.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isAndroid) {
  //   await Firebase.initializeApp();
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // }
  Smartech().onHandleDeeplinkAction(
      (String? link, Map<dynamic, dynamic>? map, bool? isAfterTerminated) {
    if (link == null || link.isEmpty) {
      return;
    }
    if (link.contains('http')) {
      showDialog(
          context: Globle().context,
          builder: (builder) => AlertDialog(
                title: Text(link),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(Globle().context).pop();
                        Smartech().openUrl(link);
                      },
                      child: Text("Ok"))
                ],
              ));
    } else {
      Navigator.of(Globle().context)
          .push(MaterialPageRoute(builder: (builder) => ProfilePage()));
    }
  });

  runApp(MyApp());
  getLocation();
}

void launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

getLocation() async {
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

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   SmartechBase().handlePushNotification(message.data.toString());
// }

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      // getToken();
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

  // getToken() async {
  //   var token = await FirebaseMessaging.instance.getToken();
  //   print(token);
  //   if (token != null) {
  //     var _shp = await SharedPreferences.getInstance();
  //     var saveToken = _shp.get("token") ?? "";
  //     if (saveToken != token) {
  //       _shp.setString(token, "token");
  //       SmartechBase().setDevicePushToken(token);
  //     }
  //   }
  //
  //   FirebaseMessaging.onMessage.listen((event) {
  //     SmartechBase().handlePushNotification(event.data.toString());
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //     SmartechBase().handlePushNotification(event.data.toString());
  //   });
  //   FirebaseMessaging.instance.getInitialMessage().then((event) {
  //     if (event != null) {
  //       SmartechBase().handlePushNotification(event.data.toString());
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Base',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: SplashScreen(),
      home: LoginScreen(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}

class Globle {
  static final Globle _singleton = Globle._internal();

  factory Globle() {
    return _singleton;
  }

  Globle._internal();

  late BuildContext context;
}
