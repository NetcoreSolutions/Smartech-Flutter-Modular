import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartech_app/app_inbox/app_inbox_screen.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_app/event_category_screen.dart';
import 'package:smartech_app/login_screen.dart';
import 'package:smartech_app/main.dart';
import 'package:smartech_app/update_profile.dart';
import 'package:smartech_base/smartech_base.dart';
import 'package:smartech_push/smartech_push.dart';
import 'custom_profile_payload_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = "Guest User";
  bool _optPN = false, _optInAppMsg = false, _optEventTracking = false;
  String checkValue = "";

  String appId = "";
  String devicePushToken = "";
  String deviceUniqueID = "";
  String sdkVersion = "";

  @override
  void initState() {
    super.initState();
    fetchDetails();
    if (Platform.isAndroid) {
      Smartech().onHandleDeeplinkActionBackground();
    }
  }

  @override
  Widget build(BuildContext context) {
    Globle().context = context;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          "Dashboard",
        ),
        centerTitle: true,
        backgroundColor: AppColor.secondary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Image.asset(
              'assets/icons/opt-notification.png',
              width: 18,
              height: 18,
            ),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/user-profile-icon.png',
                      width: 32,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _username,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColor.secondary),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 12, left: 12, bottom: 10),
                child: Text(
                  "GENERAL APP SETTINGS",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        await Smartech().logoutAndClearUserIdentity(false);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => LoginScreen()));
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 32,
                                width: 32,
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: AppColor.accent1,
                                ),
                                child: Image.asset(
                                  'assets/icons/logout.png',
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Logout",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                            indent: 42,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await Smartech().logoutAndClearUserIdentity(true);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => LoginScreen()));
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 32,
                                width: 32,
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: AppColor.accent1,
                                ),
                                child: Image.asset(
                                  'assets/icons/logout-clear.png',
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Logout & Clear Identity",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                            indent: 42,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (builder) => UpdateProfile()));
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 32,
                                    width: 32,
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      color: AppColor.accent1,
                                    ),
                                    child: Image.asset(
                                      'assets/icons/update-profile.png',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Update My Profile",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                                  ),
                                ],
                              ),
                              Image.asset(
                                "assets/icons/right-chevron.png",
                                width: 18,
                                height: 18,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                            indent: 42,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomProfilePayloadScreen(),
                            ));
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 32,
                                    width: 32,
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      color: AppColor.accent1,
                                    ),
                                    child: Image.asset(
                                      'assets/icons/custom-profile.png',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Custom Profile Payload",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                                  ),
                                ],
                              ),
                              Image.asset(
                                "assets/icons/right-chevron.png",
                                width: 18,
                                height: 18,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                            indent: 42,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await Smartech().setUserLocation(21.089721, 79.068722);
                        showToast("Location updated.");
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 32,
                                width: 32,
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: AppColor.accent1,
                                ),
                                child: Image.asset(
                                  'assets/icons/location.png',
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Set Custom Location",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 12, left: 12, bottom: 10),
                child: Text(
                  "GDPR SETTINGS",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 32,
                                  width: 32,
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: AppColor.secondary,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/opt-notification.png',
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Opt Push Notification",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                              ],
                            ),
                            CupertinoSwitch(
                              value: _optPN,
                              activeColor: AppColor.accent1,
                              onChanged: (value) async {
                                await SmartechPush().optPushNotification(value);

                                setState(() {
                                  _optPN = value;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                          indent: 42,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 32,
                                  width: 32,
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: AppColor.secondary,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/opt-inapp.png',
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Opt In App Messages",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                              ],
                            ),
                            CupertinoSwitch(
                              value: _optInAppMsg,
                              activeColor: AppColor.accent1,
                              onChanged: (value) async {
                                await Smartech().optInAppMessage(value);
                                setState(() {
                                  _optInAppMsg = value;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                          indent: 42,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 32,
                                  width: 32,
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: AppColor.secondary,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/opt-tracking.png',
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Opt Event Tracking",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                              ],
                            ),
                            CupertinoSwitch(
                              value: _optEventTracking,
                              activeColor: AppColor.accent1,
                              onChanged: (value) async {
                                await Smartech().optTracking(value);
                                setState(() {
                                  _optEventTracking = value;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 12, left: 12, bottom: 10),
                child: Text(
                  "PAYLOAD EVENT TESTING",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventCategoryScreen(),
                      ));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 32,
                                    width: 32,
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      color: Colors.red.shade800,
                                    ),
                                    child: Image.asset(
                                      'assets/icons/opt-tracking.png',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "In-App Payload Testing",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                                  ),
                                ],
                              ),
                              Image.asset(
                                "assets/icons/right-chevron.png",
                                width: 18,
                                height: 18,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 12, left: 12, bottom: 10),
                child: Text(
                  "APPINBOX",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (builder) => const SMTAppInboxScreen()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 32,
                                    width: 32,
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      color: Colors.red.shade800,
                                    ),
                                    child: Image.asset(
                                      'assets/icons/update-event.png',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "AppInbox",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                                  ),
                                ],
                              ),
                              Image.asset(
                                "assets/icons/right-chevron.png",
                                width: 18,
                                height: 18,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 12, left: 12, bottom: 10),
                child: Text(
                  "MICELLANEOUS SETTINGS",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 32,
                              width: 32,
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: AppColor.primary,
                              ),
                              child: Image.asset(
                                'assets/icons/sync-events.png',
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Sync Events Manually",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                          indent: 42,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 32,
                                  width: 32,
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: AppColor.primary,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/preferences.png',
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "View Smartech Preference",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                              ],
                            ),
                            Image.asset(
                              "assets/icons/right-chevron.png",
                              width: 18,
                              height: 18,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 12, left: 12, bottom: 10),
                child: Text(
                  "SDK GET METHODS",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getSdkMethod("App ID", appId),
                    getSdkMethod("Device Push Token", devicePushToken),
                    getSdkMethod("Device Unique I", deviceUniqueID),
                    getSdkMethod("SDK Version", sdkVersion),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSdkMethod(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: title + " : " + value)).then((result) {
                  final snackBar = SnackBar(
                    content: Text('Copied'),
                    duration: Duration(milliseconds: 500),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar); // -> show a notification
                });
              },
              child: Icon(
                Icons.copy,
                size: 18,
                color: AppColor.secondary,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          value,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        SizedBox(
          height: 4,
        ),
        Divider(
          thickness: 1,
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }

  fetchDetails() {
    Smartech().getUserIdentity().then((value) {
      setState(() {
        if (value == null) {
          _username = "Guest User";
        } else {
          _username = value.isEmpty ? "Guest User" : value;
        }
      });
    });

    Smartech().getAppID().then((value) {
      if (value == null) {
        appId = "-";
      } else {
        appId = value.isEmpty ? "-" : value;
      }
      setState(() {});
    });

    if (Platform.isAndroid) {
      SmartechPush().getDevicePushToken().then((value) {
        if (value == null) {
          devicePushToken = "-";
        } else {
          devicePushToken = value.isEmpty ? "-" : value;
        }
        setState(() {});
      });
    } else {
      Smartech().getDevicePushToken().then((value) {
        if (value == null) {
          devicePushToken = "-";
        } else {
          devicePushToken = value.isEmpty ? "-" : value;
        }
        setState(() {});
      });
    }

    Smartech().getDeviceUniqueId().then((value) {
      if (value == null) {
        deviceUniqueID = "-";
      } else {
        deviceUniqueID = value.isEmpty ? "-" : value;
      }
      setState(() {});
    });

    Smartech().getSDKVersion().then((value) {
      if (value == null) {
        sdkVersion = "-";
      } else {
        sdkVersion = value.isEmpty ? "-" : value;
      }
      setState(() {});
    });

    Smartech().hasOptedTracking().then((value) {
      setState(() {
        _optEventTracking = value ?? false;
      });
    });

    Smartech().hasOptedInAppMessage().then((value) {
      setState(() {
        _optInAppMsg = value ?? false;
      });
    });

    SmartechPush().hasOptedPushNotification().then((value) {
      setState(() {
        _optPN = value ?? false;
      });
    });
  }
}
