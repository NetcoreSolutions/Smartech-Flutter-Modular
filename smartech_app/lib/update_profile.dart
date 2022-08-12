import 'package:flutter/material.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_base/smartech_base.dart';

class UpdateProfile extends StatefulWidget {
  static const String route = "updateProfile";

  @override
  State<StatefulWidget> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String _firstName = "", _lastName = "", _age = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Profile",
        ),
        centerTitle: true,
        backgroundColor: AppColor.secondary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "When you update your profile, you can do a profile push to update your profile details with Smartech.",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  color: Colors.grey.shade200,
                  child: TextField(
                    decoration: const InputDecoration(hintText: "Enter your first name", contentPadding: EdgeInsets.all(5)),
                    onChanged: (value) {
                      _firstName = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  color: Colors.grey.shade200,
                  child: TextField(
                    decoration: const InputDecoration(hintText: "Enter your last name", contentPadding: EdgeInsets.all(5)),
                    onChanged: (value) {
                      _lastName = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  color: Colors.grey.shade200,
                  child: TextField(
                    decoration: const InputDecoration(hintText: "Enter your age", contentPadding: EdgeInsets.all(5)),
                    onChanged: (value) {
                      _age = value;
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
                    "Update Profile",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  color: AppColor.primary,
                  onPressed: () {
                    if (_firstName.isEmpty) {
                      showToast('Please enter your first name.');
                      return;
                    }
                    if (_lastName.isEmpty) {
                      showToast('Please enter your last name.');
                      return;
                    }
                    if (_age.isEmpty) {
                      showToast('Please enter your age.');
                      return;
                    }

                    var map = {"first_name": _firstName, "last_name": _lastName, "age": _age};
                    Smartech().updateUserProfile(map);
                    showToast("Profile updated");
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
