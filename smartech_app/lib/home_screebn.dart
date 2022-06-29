// import 'package:flutter/material.dart';
// import 'package:smartech_app/app_inbox/utils/utils.dart';
// import 'package:smartech_base/smartech.dart';
// import 'custom_event.dart';
// import 'login_screen.dart';
// import 'main.dart';
// import 'track_event.dart';
// import 'update_profile.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
//   SliverGridDelegate? gridDelegate;
//   String? platformVersion = "Unkown";

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addObserver(this);
//     Smartech().onHandleDeeplinkActionBackground();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//   }

//   @override
//   Widget build(BuildContext context) {
//     Globle().context = context;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home"),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//                 child: Row(
//                   children: [
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () {
//                         Smartech().logoutAndClearUserIdentity(true);
//                         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => LoginScreen()));
//                       },
//                       child: Text("LOGOUT AND CLEAR USER IDENTITY"),
//                     )),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () {
//                         launchURL("http://www.google.com");
//                         // Smartech().clearUserIdentity();
//                       },
//                       child: Text("CLEAR USER IDENTITY"),
//                     ))
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//                 child: Row(
//                   children: [
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).push(MaterialPageRoute(builder: (builder) => UpdateProfile()));
//                       },
//                       child: Text("UPDATE USER PROFILE"),
//                     )),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () {},
//                       child: Text("HANDLE PUSH NOTIFICATION"),
//                     ))
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//                 child: Row(
//                   children: [
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).push(MaterialPageRoute(builder: (builder) => TrackEventScreen()));
//                       },
//                       child: Text("TRACK EVENT"),
//                     )),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () {
//                         Smartech().setUserLocation(21.089721, 79.068722);
//                       },
//                       child: Text("SET USER LOCATION"),
//                     ))
//                   ],
//                 ),
//               ),
//               // Padding(
//               //   padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//               //   child: Row(
//               //     children: [
//               //       Expanded(
//               //           child: ElevatedButton(
//               //         onPressed: () {
//               //           Smartech().optPushNotification(false);
//               //         },
//               //         child: Text("OPT-OUT PUSH NOTIFICATION"),
//               //       )),
//               //       SizedBox(
//               //         width: 10,
//               //       ),
//               //       Expanded(
//               //           child: ElevatedButton(
//               //         onPressed: () async {
//               //           var value =
//               //               await Smartech().hasOptedPushNotification();
//               //
//               //           Fluttertoast.showToast(
//               //               msg: value.toString(),
//               //               toastLength: Toast.LENGTH_SHORT,
//               //               gravity: ToastGravity.BOTTOM,
//               //               timeInSecForIosWeb: 1,
//               //               backgroundColor: Colors.green,
//               //               textColor: Colors.white,
//               //               fontSize: 13.0);
//               //         },
//               //         child: Text("GET OPT-OUT STATUS"),
//               //       ))
//               //     ],
//               //   ),
//               // ),
//               // Padding(
//               //   padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//               //   child: Row(
//               //     children: [
//               //       Expanded(
//               //           child: ElevatedButton(
//               //         onPressed: () async {
//               //           Smartech().fetchAlreadyGeneratedTokenFromFCM;
//               //         },
//               //         child: Text("FETCH ALREADY GENETATED TOEKN"),
//               //       )),
//               //       SizedBox(
//               //         width: 10,
//               //       ),
//               //       Expanded(
//               //           child: ElevatedButton(
//               //         onPressed: () async {
//               //           var _shp = await SharedPreferences.getInstance();
//               //           String color = _shp.get("color") as String? ?? "";
//               //           if (color.isEmpty) {
//               //             var option = SMTNotificationOptions(
//               //                 transparentIconBgColor: "#ff888888");
//               //             Smartech().setNotificationOptions(option);
//               //
//               //             _shp.setString("color", "ff888888");
//               //           }
//               //           Navigator.of(context).push(MaterialPageRoute(
//               //               builder: (builder) => SetIconColor()));
//               //         },
//               //         child: Text("NOTIFICATION ICON COLOR"),
//               //       ))
//               //     ],
//               //   ),
//               // ),
//               // Padding(
//               //   padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//               //   child: Row(
//               //     children: [
//               //       Expanded(
//               //           child: ElevatedButton(
//               //         onPressed: () {},
//               //         child: Text("FETCH DELIVERD PUSH NOTIFICATIONS"),
//               //       )),
//               //       SizedBox(
//               //         width: 10,
//               //       ),
//               //       Expanded(
//               //           child: ElevatedButton(
//               //         onPressed: () async {
//               //           var value = await Smartech().getInboxMessageCount(
//               //               SMTNotificatioMessageType.ALL_MESSAGE);
//               //           Fluttertoast.showToast(
//               //               msg: value.toString(),
//               //               toastLength: Toast.LENGTH_SHORT,
//               //               gravity: ToastGravity.BOTTOM,
//               //               timeInSecForIosWeb: 1,
//               //               backgroundColor: Colors.green,
//               //               textColor: Colors.white,
//               //               fontSize: 13.0);
//               //         },
//               //         child: Text("UNREAD PUSH NOTIFICATION COUNT"),
//               //       ))
//               //     ],
//               //   ),
//               // ),
//               // Padding(
//               //   padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//               //   child: Row(
//               //     children: [
//               //       Expanded(
//               //           child: ElevatedButton(
//               //         onPressed: () {},
//               //         child: Text("PRODUCT RECOMMENDATION"),
//               //       )),
//               //       SizedBox(
//               //         width: 10,
//               //       ),
//               //       Expanded(
//               //           child: ElevatedButton(
//               //         onPressed: () async {
//               //           var value = await Smartech().getDevicePushToken();
//               //
//               //           Fluttertoast.showToast(
//               //               msg: value.toString(),
//               //               toastLength: Toast.LENGTH_SHORT,
//               //               gravity: ToastGravity.BOTTOM,
//               //               timeInSecForIosWeb: 1,
//               //               backgroundColor: Colors.green,
//               //               textColor: Colors.white,
//               //               fontSize: 13.0);
//               //         },
//               //         child: Text("GET TOKEN"),
//               //       ))
//               //     ],
//               //   ),
//               // ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//                 child: Row(
//                   children: [
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () async {
//                         var value = await Smartech().getUserIdentity();
//                         showToast(value.toString());
//                       },
//                       child: Text("GET USER IDENTITY"),
//                     )),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () async {
//                         var value = await Smartech().getDeviceUniqueId();
//                         showToast(value.toString());
//                       },
//                       child: Text("GET DEVICE UNIQUE ID"),
//                     ))
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//                 child: Row(
//                   children: [
//                     // Expanded(
//                     //     child: ElevatedButton(
//                     //   onPressed: () {
//                     //     Smartech().optPushNotification(true);
//                     //   },
//                     //   child: Text("OPT-IN Notification"),
//                     // )),
//                     // SizedBox(
//                     //   width: 10,
//                     // ),
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () {
//                         Smartech().optTracking(true);
//                       },
//                       child: Text("OPT-IN Tracking"),
//                     ))
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//                 child: Row(
//                   children: [
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () {
//                         Smartech().optInAppMessage(true);
//                       },
//                       child: Text("OPT-IN in appmessage"),
//                     )),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () {
//                         Smartech().optTracking(false);
//                       },
//                       child: Text("OPT-Out Tracking"),
//                     ))
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//                 child: Row(
//                   children: [
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () {
//                         Smartech().optInAppMessage(false);
//                       },
//                       child: Text("OPT-OUT IN APPMESSAGE"),
//                     )),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () {
//                         Smartech().trackAppInstallUpdateBySmartech();
//                       },
//                       child: Text("Track update and install by smartech"),
//                     ))
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
//                 child: Row(
//                   children: [
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () {
//                         Smartech().openNativeWebView();
//                       },
//                       child: Text("NATIVE TO WEBVIEW"),
//                     )),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                         child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).push(MaterialPageRoute(builder: (builder) => const CustomeEventPage()));
//                       },
//                       child: Text("Track update and install by smartech"),
//                     ))
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
