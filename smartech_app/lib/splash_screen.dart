import 'package:flutter/material.dart';
import 'package:smartech_base/smartech_base.dart';
import 'base_home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateSplashScreen();
}

class _StateSplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initApp();
  }

  initApp() async {
    final value = await Smartech().getUserIdentity();
    if (value != null && value.isNotEmpty) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => HomeScreen()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Row(),
        ),
      ),
    );
  }
}
