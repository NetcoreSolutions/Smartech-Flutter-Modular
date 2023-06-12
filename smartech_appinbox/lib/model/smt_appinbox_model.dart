import 'dart:convert';

import 'package:intl/intl.dart';

class SMTAppInboxMessages {
  final SMTAppInboxMessage? smtPayload;
  final Map<String, dynamic> smtCustomPayload;

  SMTAppInboxMessages({this.smtPayload, this.smtCustomPayload = const {}});

  factory SMTAppInboxMessages.fromJson(Map json) {
    return SMTAppInboxMessages(
      smtPayload: SMTAppInboxMessage.fromJson(json['smtPayload'] ?? json['payload'] ?? {}),
      smtCustomPayload: jsonDecode(json['smtCustomPayload'] ?? {}) ?? {},
    );
  }
}

class SMTAppInboxMessage {
  final List<ActionButton> actionButton;
  final String appInboxCategory;
  final String appInboxTtl;
  final String body;
  final AttrParams? attrParams;
  final List<Carousel> carousel;
  final dynamic customPayload;
  final String deeplink;
  final String mediaUrl;
  final dynamic pnMeta;
  final DateTime? publishedDate;
  final String smtSrc;
  final bool sound;
  final String status;
  final String subtitle;
  final String timestamp;
  final String title;
  final String trid;
  final SMTNotificationType type;

  SMTAppInboxMessage({
    this.actionButton = const [],
    this.appInboxCategory = "",
    this.appInboxTtl = "",
    this.body = "",
    this.attrParams,
    this.carousel = const [],
    this.customPayload,
    this.deeplink = "",
    this.mediaUrl = "",
    this.pnMeta,
    this.publishedDate,
    this.smtSrc = "",
    this.sound = false,
    this.status = "",
    this.subtitle = "",
    this.timestamp = "",
    this.title = "",
    this.trid = "",
    this.type = SMTNotificationType.simple,
  });

  factory SMTAppInboxMessage.fromJson(Map json) {
    return SMTAppInboxMessage(
      actionButton: json['actionButton'] != null ? (json['actionButton'] as List).map((e) => ActionButton.fromJson(e)).toList() : [],
      appInboxCategory: json['appInboxCategory'] ?? "",
      appInboxTtl: json['app_inbox_ttl'] ?? "",
      body: (json['body'] ?? "").isNotEmpty
          ? json['body']
          : (json['message'] ?? "").isNotEmpty
              ? json['message']
              : "-",
      attrParams: AttrParams.fromJson(json['attrParams'] ?? {}),
      carousel: json['carousel'] != null ? (json['carousel'] as List).map((e) => Carousel.fromJson(e)).toList() : [],
      customPayload: json['customPayload'] ?? {},
      deeplink: json['deeplink'] ?? "",
      mediaUrl: (json['mediaUrl'] ?? "").isNotEmpty
          ? json['mediaUrl']
          : (json['image'] ?? "").isNotEmpty
              ? json['image']
              : "-", // There is difference keys for image url of SDK-1 and SDK2, that's why we maintain like this.
      pnMeta: json['pnMeta'] ?? {},
      publishedDate: json['publishedDate'] != null ? DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(json['publishedDate'], true).toLocal() : null,
      smtSrc: json['smtSrc'] ?? "",
      sound: json['sound'] ?? false,
      status: json['status'] ?? "",
      subtitle: json['subtitle'] ?? json['subTitle'] ?? "",
      timestamp: json['timestamp'].toString(),
      title: json['title'] ?? "",
      trid: json['trid'] ?? "",
      type: ((json['type'] ?? "") as String).toLowerCase().getSMTNotificationType(),
    );
  }
}

class AttrParams {
  final String sta;
  final String stmId;
  final String stmMedium;
  final String stmSource;

  AttrParams({this.sta = "", this.stmId = "", this.stmMedium = "", this.stmSource = ""});

  factory AttrParams.fromJson(Map json) {
    return AttrParams(
      sta: json['__sta'] ?? "",
      stmId: json['__stm_id'].toString(),
      stmMedium: json['__stm_medium'] ?? "",
      stmSource: json['__stm_source'] ?? "",
    );
  }
}

class MessageCategory {
  MessageCategory({
    this.name = "",
    this.position = 0,
    this.selected = false,
  });

  final String name;
  final int position;
  bool selected;

  factory MessageCategory.fromJson(Map<String, dynamic> json) => MessageCategory(
        name: json["name"],
        position: json["position"],
        selected: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "position": position,
        "state": selected,
      };
}

class Carousel {
  final String imgDeeplink;
  final String imgMsg;
  final String imgTitle;
  final String imgUrl;

  Carousel({this.imgDeeplink = "", this.imgMsg = "", this.imgTitle = "", this.imgUrl = ""});

  factory Carousel.fromJson(Map json) {
    return Carousel(
      imgDeeplink: json['imgDeeplink'] ?? "",
      imgMsg: json['imgMsg'] ?? "",
      imgTitle: json['imgTitle'] ?? "",
      imgUrl: json['imgUrl'] ?? "",
    );
  }
}

class ActionButton {
  final int aTyp;
  final String actionDeeplink;
  final String actionName;
  final String callToAction;
  final String configCtxt;

  ActionButton({
    this.aTyp = 0,
    this.actionDeeplink = "",
    this.actionName = "",
    this.callToAction = "",
    this.configCtxt = "",
  });

  factory ActionButton.fromJson(Map<String, dynamic> json) {
    return ActionButton(
      aTyp: json['aTyp'] ?? "",
      actionDeeplink: json['actionDeeplink'] ?? "",
      actionName: json['actionName'] ?? "",
      callToAction: json['callToAction'] ?? json['call_to_action'] ?? "",
      configCtxt: json['config_ctxt'] ?? "",
    );
  }
}

enum SMTNotificationType { simple, audio, image, gif, carouselLandscape, carouselPortrait, video }

extension SMTNotificationTypeValue on String {
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
      case "video":
        return SMTNotificationType.video;
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
