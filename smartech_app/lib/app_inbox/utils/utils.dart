import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartech_app/app_inbox/utils/enums.dart';

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

extension test on String {
  SMTNotificationType getSMTNotificationType() {
    switch (this) {
      case "audio":
        return SMTNotificationType.audio;
      case "image":
        return SMTNotificationType.image;
      case "gif":
        return SMTNotificationType.gif;
      case "carousellandscape":
        return SMTNotificationType.carouselLandscape;
      case "carouselportrait":
        return SMTNotificationType.carouselPortrait;
      case "simple":
      default:
        return SMTNotificationType.simple;
    }
  }
}

extension TimeDuration on DateTime {
  String getTimeAndDayCount() {
    if (DateTime.now().difference(this).inMinutes == 0) {
      return "just now";
    } else if (DateTime.now().difference(this).inHours == 0) {
      int minutes = DateTime.now().difference(this).inMinutes;
      return "$minutes ${minutes == 1 ? "minute" : "minutes"} ago";
    } else if (DateTime.now().difference(this).inDays == 0) {
      int hours = DateTime.now().difference(this).inHours;
      return "$hours ${hours == 1 ? "hour" : "hours"} ago";
    } else if (DateTime.now().difference(this).inDays < 7) {
      int days = DateTime.now().difference(this).inDays;
      return "$days ${days == 1 ? "day" : "days"} ago";
    } else if (int.parse(((DateTime.now().difference(this).inDays) / 7).toStringAsFixed(0)) == 1) {
      return "A week ago";
    } else if (int.parse(((DateTime.now().difference(this).inDays) / 7).toStringAsFixed(0)) < 5) {
      return "${((DateTime.now().difference(this).inDays) / 7).toStringAsFixed(0)} weeks ago";
    } else if (int.parse(((DateTime.now().difference(this).inDays) / 30).toStringAsFixed(0)) == 1) {
      return "A month ago";
    } else if (int.parse(((DateTime.now().difference(this).inDays) / 30).toStringAsFixed(0)) < 12) {
      return "${((DateTime.now().difference(this).inDays) / 30).toStringAsFixed(0)} months ago";
    } else if (int.parse(((DateTime.now().difference(this).inDays) / 365).toStringAsFixed(0)) == 1) {
      return "A year ago";
    } else {
      return "${((DateTime.now().difference(this).inDays) / 365).toStringAsFixed(0)} years ago";
    }
  }
}
