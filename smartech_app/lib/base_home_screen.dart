import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartech_app/login_screen.dart';
import 'package:smartech_app/track_event.dart';
import 'package:smartech_app/update_profile.dart';
import 'package:smartech_app/utils.dart';
import 'package:smartech_base/smartech.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String _username = "Guest User";
  bool _optPN = false, _optInAppMsg = false, _optEventTracking = false;
  bool _syncEventManually = false;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Dashboard",),
        centerTitle: true,
        backgroundColor: AppColor.secondary,
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
                    Image.asset('assets/icons/user-profile-icon.png', width: 32,),
                    SizedBox(height: 5,),
                    Text(_username,
                      style: TextStyle(fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColor.secondary),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20, right: 12, left: 12, bottom: 10),
                child: Text("GENERAL APP SETTINGS",
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (builder) => LoginScreen()));
                      },
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
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
                                child: Image.asset('assets/icons/logout.png',),
                              ),
                              SizedBox(width: 10,),
                              Text("Logout",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Divider(thickness: 1, indent: 42,),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await Smartech().logoutAndClearUserIdentity(true);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (builder) => LoginScreen()));
                      },
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
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
                                child: Image.asset('assets/icons/logout-clear.png',),
                              ),
                              SizedBox(width: 10,),
                              Text("Logout & Clear Identity",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Divider(thickness: 1, indent: 42,),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => UpdateProfile()));
                      },
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
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
                                    child: Image.asset('assets/icons/update-profile.png',),
                                  ),
                                  SizedBox(width: 10,),
                                  Text("Update My Profile",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
                                ],
                              ),
                              Image.asset("assets/icons/right-chevron.png", width: 18, height: 18,)
                            ],
                          ),
                          SizedBox(height: 10,),
                          Divider(thickness: 1, indent: 42,),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {

                        var map = {
                          "first_name": 'Krish',
                          "last_name": 'Krish',
                          "country": 'India',
                          "age": 100,
                        };
                        await Smartech().updateUserProfile(map);

                        Navigator.push(context, MaterialPageRoute(builder: (context) => TrackEventScreen(),));

                      },
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
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
                                    child: Image.asset('assets/icons/custom-profile.png',),
                                  ),
                                  SizedBox(width: 10,),
                                  Text("Custom Profile Payload",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
                                ],
                              ),
                              Image.asset("assets/icons/right-chevron.png", width: 18, height: 18,)
                            ],
                          ),
                          SizedBox(height: 10,),
                          Divider(thickness: 1, indent: 42,),
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
                          SizedBox(height: 10,),
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
                                    child: Image.asset('assets/icons/location.png',),
                                  ),
                                  SizedBox(width: 10,),
                                  Text("Set Custom Location",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
                                ],
                              ),
                              Image.asset("assets/icons/right-chevron.png", width: 18, height: 18,)
                            ],
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20, right: 12, left: 12, bottom: 10),
                child: Text("GDPR SETTINGS",
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
                        SizedBox(height: 10,),
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
                                  child: Image.asset('assets/icons/opt-notification.png',),
                                ),
                                SizedBox(width: 10,),
                                Text("Opt Push Notification",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
                              ],
                            ),
                            CupertinoSwitch(
                              value: _optPN,
                              activeColor: AppColor.accent1,
                              onChanged: (value) {
                                // _optPN = value;
                                //Not Available
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Divider(thickness: 1, indent: 42,),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 10,),
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
                                  child: Image.asset('assets/icons/opt-inapp.png',),
                                ),
                                SizedBox(width: 10,),
                                Text("Opt In App Messages",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
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
                        SizedBox(height: 10,),
                        Divider(thickness: 1, indent: 42,),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 10,),
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
                                  child: Image.asset('assets/icons/opt-tracking.png',),
                                ),
                                SizedBox(width: 10,),
                                Text("Opt Event Tracking",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
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
                        SizedBox(height: 10,),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20, right: 12, left: 12, bottom: 10),
                child: Text("APP WEB STITCHING",
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
                        SizedBox(height: 10,),
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
                                  child: Image.asset('assets/icons/update-event.png',),
                                ),
                                SizedBox(width: 10,),
                                Text("Web Stitching",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
                              ],
                            ),
                            Image.asset("assets/icons/right-chevron.png", width: 18, height: 18,)
                          ],
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20, right: 12, left: 12, bottom: 10),
                child: Text("APPINBOX",
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
                        SizedBox(height: 10,),
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
                                  child: Image.asset('assets/icons/update-event.png',),
                                ),
                                SizedBox(width: 10,),
                                Text("AppInbox",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
                              ],
                            ),
                            Image.asset("assets/icons/right-chevron.png", width: 18, height: 18,)
                          ],
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20, right: 12, left: 12, bottom: 10),
                child: Text("AUTOMATION TESTING",
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
                        SizedBox(height: 10,),
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
                              child: Image.asset('assets/icons/opt-tracking.png',),
                            ),
                            SizedBox(width: 10,),
                            Text("In-App Payload Testing",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
                          ],
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20, right: 12, left: 12, bottom: 10),
                child: Text("MICELLANEOUS SETTINGS",
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
                        SizedBox(height: 10,),
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
                                  child: Image.asset('assets/icons/sync-status.png',),
                                ),
                                SizedBox(width: 10,),
                                Text("Sync Event Automatically",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
                              ],
                            ),
                            CupertinoSwitch(
                              value: _syncEventManually,
                              activeColor: AppColor.accent1,
                              onChanged: (value) {
                                // _syncEventManually = value
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Divider(thickness: 1, indent: 42,),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 10,),
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
                              child: Image.asset('assets/icons/sync-events.png',),
                            ),
                            SizedBox(width: 10,),
                            Text("Sync Events Manually",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Divider(thickness: 1, indent: 42,),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 10,),
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
                                  child: Image.asset('assets/icons/preferences.png',),
                                ),
                                SizedBox(width: 10,),
                                Text("View Smartech Preference",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),),
                              ],
                            ),
                            Image.asset("assets/icons/right-chevron.png", width: 18, height: 18,)
                          ],
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40,),

            ],
          ),
        ),
      ),
    );
  }

  fetchDetails() async {

    _username = (await Smartech().getUserIdentity()) ?? "Guest User";
    _optEventTracking = (await Smartech().hasOptedTracking()) ?? false;
    _optInAppMsg = (await Smartech().hasOptedInAppMessage()) ?? false;

  }

}

