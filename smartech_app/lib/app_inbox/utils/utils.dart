import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 13.0);
}

class AppColor {
  static const Color primary = Color(0xFFFF753F);
  static const Color secondary = Color(0xFF025BBF);
  static const Color accent1 = Color(0xFF32C759);
  static const Color accent2 = Color(0xFF025BBF);
  static const Color greyColorText = Color(0xFF808080);
}

Widget htmlText(String title) {
  return Column(
    children: [
      Html(
        data: title,
        style: {"body": Style(margin: Margins.zero, padding: HtmlPaddings.zero)},
      ),
      SizedBox(
        height: 4,
      ),
    ],
  );
}
