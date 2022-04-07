import 'package:flutter/material.dart';
import 'package:smartech_base/smartech.dart';
import 'home_screebn.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    Smartech().onHandleDeeplinkActionBackground();
  }

  var valueName = '';

  @override
  Widget build(BuildContext context) {
    Globle().context = context;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextField(
                decoration: InputDecoration(hintText: "Enter Name"),
                onChanged: (value) {
                  valueName = value;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 150,
              child: ElevatedButton(
                  onPressed: () {
                    if (valueName.isNotEmpty) {
                      Smartech().login(valueName);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => HomeScreen()));
                    }
                  },
                  child: Center(
                    child: Text("Submit"),
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 150,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => HomeScreen()));
                  },
                  child: Center(
                    child: Text("Skip"),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
