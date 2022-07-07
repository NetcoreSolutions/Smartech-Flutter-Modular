import 'package:intl/intl.dart';
import 'package:smartech_app/app_inbox/utils/enums.dart';
import 'package:smartech_app/app_inbox/utils/utils.dart';

class SMTInbox {
  final List<ActionButton> actionButton;
  final String appInboxCategory;
  final String appInboxTtl;
  final String body;
  final AttrParams? attrParams;
  final List<Carousel> carousel;
  final dynamic customPayload;
  final String deeplink;
  final String expiry;
  final String image;
  final String mediaUrl;
  final String message;
  final dynamic pnMeta;
  final DateTime? publishedDate;
  final dynamic smtCustomPayload;
  final String smtSrc;
  final bool sound;
  final String status;
  final String subtitle;
  final int timestamp;
  final String title;
  final String trid;
  final SMTNotificationType type;

  SMTInbox({
    this.actionButton = const [],
    this.appInboxCategory = "",
    this.appInboxTtl = "",
    this.body = "",
    this.attrParams,
    this.carousel = const [],
    this.customPayload,
    this.deeplink = "",
    this.expiry = "",
    this.image = "",
    this.mediaUrl = "",
    this.message = "",
    this.pnMeta,
    this.publishedDate,
    this.smtCustomPayload,
    this.smtSrc = "",
    this.sound = false,
    this.status = "",
    this.subtitle = "",
    this.timestamp = 0,
    this.title = "",
    this.trid = "",
    this.type = SMTNotificationType.simple,
  });

  factory SMTInbox.fromJson(Map json) {
    return SMTInbox(
      actionButton: (json['actionButton'] as List).map((e) => ActionButton.fromJson(e)).toList(),
      appInboxCategory: json['appInboxCategory'] ?? "",
      appInboxTtl: json['app_inbox_ttl'] ?? "",
      body: json['body'] ?? "",
      attrParams: AttrParams.fromJson(json['attrParams'] ?? {}),
      carousel: (json['carousel'] as List).map((e) => Carousel.fromJson(e)).toList(),
      customPayload: json['customPayload'] ?? {},
      deeplink: json['deeplink'] ?? "",
      expiry: json['expiry'] ?? "",
      image: json['image'] ?? "",
      mediaUrl: json['mediaUrl'] ?? "",
      message: json['message'] ?? "",
      pnMeta: json['pnMeta'] ?? {},
      publishedDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(json['publishedDate'] ?? "", true).toLocal(),
      smtCustomPayload: json['smtCustomPayload'] ?? {},
      smtSrc: json['smtSrc'] ?? "",
      sound: json['sound'] ?? false,
      status: json['status'] ?? "",
      subtitle: json['subtitle'] ?? "",
      timestamp: json['timestamp'] ?? "",
      title: json['title'] ?? "",
      trid: json['trid'] ?? "",
      type: ((json['type'] ?? "") as String).toLowerCase().getSMTNotificationType(),
    );
  }
}

class AttrParams {
  final String sSta;
  final String sStmId;
  final String sStmMedium;
  final String sStmSource;

  AttrParams({this.sSta = "", this.sStmId = "", this.sStmMedium = "", this.sStmSource = ""});

  factory AttrParams.fromJson(Map json) {
    return AttrParams(
      sSta: json['__sta'] ?? "",
      sStmId: json['__stm_id'] ?? "",
      sStmMedium: json['__stm_medium'] ?? "",
      sStmSource: json['__stm_source'] ?? "",
    );
  }
}

class Category {
  Category({
    this.name = "",
    this.position = 0,
    this.selected = false,
  });

  final String name;
  final int position;
  bool selected;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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
  final Config? config;

  ActionButton({this.aTyp = 0, this.actionDeeplink = "", this.actionName = "", this.callToAction = "", this.config});

  factory ActionButton.fromJson(Map<String, dynamic> json) {
    return ActionButton(
        aTyp: json['aTyp'] ?? "",
        actionDeeplink: json['actionDeeplink'] ?? "",
        actionName: json['actionName'] ?? "",
        callToAction: json['call_to_action'] ?? "",
        config: json['config'] != null ? new Config.fromJson(json['config']) : null);
  }
}

class Config {
  final String intl;
  final String ctxt;

  Config({
    this.intl = "",
    this.ctxt = "",
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      intl: json['intl'] ?? "",
      ctxt: json['ctxt'] ?? "",
    );
  }
}
