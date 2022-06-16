import 'package:intl/intl.dart';
import 'package:smartech_app/utils/enums.dart';
import 'package:smartech_app/utils/utils.dart';

// class AppInboxModel {
//   final int inboxCount;
//   final List<Inbox> inbox;
//   final String message;
//   final int code;

//   AppInboxModel({this.inboxCount = 0, this.inbox = const [], this.message = "", this.code = 0});

//   factory AppInboxModel.fromJson(Map json) {
//     return AppInboxModel(
//       inboxCount: json['inbox_count'] ?? 0,
//       inbox: (json['inbox'] as List).map((e) => Inbox.fromJson(e)).toList(),
//       message: json['message'] ?? "",
//       code: json['code'] ?? 0,
//     );
//   }
// }

class Inbox {
  final String appInboxCategory;
  final String appInboxTtl;
  final AttrParams? attrParams;
  final List<dynamic> carousel;
  final dynamic customPayload;
  final String deeplink;
  final String expiry;
  final String image;
  final String message;
  final dynamic pnMeta;
  final DateTime? publishedDate;
  final dynamic smtCustomPayload;
  final String smtSrc;
  final bool sound;
  final String status;
  final String subtitle;
  final String timestamp;
  final String title;
  final String trid;
  final NotificationType type;

  Inbox({
    this.appInboxCategory = "",
    this.appInboxTtl = "",
    this.attrParams,
    this.carousel = const [],
    this.customPayload,
    this.deeplink = "",
    this.expiry = "",
    this.image = "",
    this.message = "",
    this.pnMeta,
    this.publishedDate,
    this.smtCustomPayload,
    this.smtSrc = "",
    this.sound = false,
    this.status = "",
    this.subtitle = "",
    this.timestamp = "",
    this.title = "",
    this.trid = "",
    this.type = NotificationType.simple,
  });

  factory Inbox.fromJson(Map json) {
    return Inbox(
      appInboxCategory: json['app_inbox_category'] ?? "",
      appInboxTtl: json['app_inbox_ttl'] ?? "",
      attrParams: AttrParams.fromJson(json['attrParams'] ?? {}),
      carousel: json['carousel'] ?? [],
      customPayload: json['customPayload'] ?? {},
      deeplink: json['deeplink'] ?? "",
      expiry: json['expiry'] ?? "",
      image: json['image'] ?? "",
      message: json['message'] ?? "",
      pnMeta: json['pnMeta'] ?? {},
      publishedDate: DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['publishedDate'] ?? "", false).toLocal(),
      smtCustomPayload: json['smtCustomPayload'] ?? {},
      smtSrc: json['smtSrc'] ?? "",
      sound: json['sound'] ?? false,
      status: json['status'] ?? "",
      subtitle: json['subtitle'] ?? "",
      timestamp: json['timestamp'] ?? "",
      title: json['title'] ?? "",
      trid: json['trid'] ?? "",
      type: ((json['type'] ?? "") as String).toLowerCase().getNotificationType(),
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
    this.state = false,
  });

  final String name;
  final int position;
  final bool state;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        position: json["position"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "position": position,
        "state": state,
      };
}
