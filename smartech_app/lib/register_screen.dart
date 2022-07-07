import 'package:flutter/material.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';
import 'package:smartech_base/smartech_base.dart';
import 'base_home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _firstName = "", _lastName = "", _email = "", _age = "";

  @override
  void initState() {
    super.initState();
    Smartech().onHandleDeeplinkActionBackground();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create An Account",
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
                    decoration: const InputDecoration(hintText: "Enter your email", contentPadding: EdgeInsets.all(5)),
                    onChanged: (value) {
                      _email = value;
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
                    "Create An Account",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () async {
                    if (_firstName.isEmpty) {
                      showToast('Please enter your first name.');
                      return;
                    }
                    if (_lastName.isEmpty) {
                      showToast('Please enter your last name.');
                      return;
                    }
                    if (_email.isEmpty) {
                      showToast('Please enter your email.');
                      return;
                    }
                    if (_age.isEmpty) {
                      showToast('Please enter your age.');
                      return;
                    }

                    var map = {"first_name": _firstName, "last_name": _lastName, "email": _email, "age": _age};
                    await Smartech().login(_email);
                    await Smartech().updateUserProfile(map);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomeScreen()), (Route<dynamic> route) => false);
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
