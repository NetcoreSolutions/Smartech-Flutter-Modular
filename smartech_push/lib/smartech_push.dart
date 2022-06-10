import 'dart:async';
import 'package:flutter/services.dart';
import 'channel_builder.dart';
import 'smt_notification_options.dart';

class SmartechPush {
  static const MethodChannel _channel = MethodChannel('smartech_push_channel');

  Future<void> setDevicePushToken(String token) async {
    await _channel.invokeMethod('setDevicePushToken', token);
  }

  Future<String?> get fetchAlreadyGeneratedTokenFromFCM async {
    return await _channel.invokeMethod('fetchAlreadyGeneratedTokenFromFCM');
  }

  Future<void> handlePushNotification(String notificationData) async {
    await _channel.invokeMethod("handlePushNotification", notificationData);
  }

  Future<void> createNotificationChannel(SMTNotifcationChannelBuilder builder) async {
    await _channel.invokeMethod("createNotificationChannel", builder.toJson());
  }

  Future<void> createNotificationChannelGroup(String groupId, String groupName) async {
    await _channel.invokeMethod("createNotificationChannelGroup", {"group_id": groupId, "group_name": groupName});
  }

  Future<void> deleteNotificationChannel(String channelId) async {
    await _channel.invokeMethod("deleteNotificationChannel", channelId);
  }

  Future<void> deleteNotificationChannelGroup(String groupId) async {
    await _channel.invokeMethod("deleteNotificationChannelGroup", groupId);
  }

  Future<void> setNotificationOptions(SMTNotificationOptions options) async {
    await _channel.invokeMethod("setNotificationOptions", options.toJson());
  }

  Future<void> optPushNotification(bool isOpted) async {
    return await _channel.invokeMethod("optPushNotification", isOpted);
  }

  Future<bool?> hasOptedPushNotification() async {
    return await _channel.invokeMethod("hasOptedPushNotification");
  }

  Future<String?> getDevicePushToken() async {
    return await _channel.invokeMethod("getDevicePushToken");
  }
}
