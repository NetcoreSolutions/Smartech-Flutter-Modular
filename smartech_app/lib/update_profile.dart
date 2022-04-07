import 'package:flutter/material.dart';
import 'package:smartech_base/smartech.dart';

import 'main.dart';

class UpdateProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String firstName = '';
  String lastName = '';
  String age = '';

  @override
  Widget build(BuildContext context) {
    Globle().context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(hintText: "First Name"),
                onChanged: (value) {
                  firstName = value;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(hintText: "Last Name"),
                onChanged: (value) {
                  lastName = value;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(hintText: "Age"),
                onChanged: (value) {
                  age = value;
                },
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 150,
              child: ElevatedButton(
                  onPressed: () {
                    var map = {
                      "first_name": firstName,
                      "last_name": lastName,
                      "age": age
                    };
                    Smartech().updateUserProfile(map);
                  },
                  child: const Center(
                    child: Text("Save"),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
