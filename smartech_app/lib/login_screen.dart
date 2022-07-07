import 'package:flutter/material.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_app/main.dart';
import 'package:smartech_app/register_screen.dart';
import 'package:smartech_base/smartech_base.dart';

import 'base_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _name = "";

  @override
  void initState() {
    super.initState();
    Smartech().onHandleDeeplinkActionBackground();
  }

  @override
  Widget build(BuildContext context) {
    Globle().context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login To Your Account",
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "When you do a login to your application you should call to login method of SmartechSDK",
                  style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  color: Colors.grey.shade200,
                  child: TextField(
                    decoration: const InputDecoration(hintText: "Enter primary key as per Smartech Panel.", contentPadding: EdgeInsets.all(5)),
                    onChanged: (value) {
                      _name = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  color: Colors.deepOrange,
                  onPressed: () async {
                    if (_name.isNotEmpty) {
                      await Smartech().login(_name);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomeScreen()), (Route<dynamic> route) => false);
                    } else {
                      showToast("Please enter primary key");
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Create An Account",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ));
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomeScreen()), (Route<dynamic> route) => false);
                    },
                    child: Text(
                      "Continue as guest",
                      style: TextStyle(color: Colors.deepOrange, fontSize: 16, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
