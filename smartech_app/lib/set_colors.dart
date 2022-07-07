import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';

class SetIconColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Icon Colors"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                var _shp = await SharedPreferences.getInstance();
                showToast("Notification icon color: ${_shp.get("color")}");
              },
              child: Text("Get push icon color")),
        ],
      ),
    );
  }
}
