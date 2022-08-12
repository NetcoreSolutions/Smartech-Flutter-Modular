class SMTNotifcationChannelBuilder {
  String channelId;
  String channelName;
  int? notificationImportance;
  String? channelDescription;
  String? groupId;
  String? notificationSoundFile;
  SMTNotifcationChannelBuilder(this.channelId, this.channelName,
      {this.notificationImportance, this.channelDescription, this.groupId, this.notificationSoundFile});

  Map<String, dynamic> toJson() => {
        "Channel_ID": channelId,
        "Channel_Name": channelName,
        "Notification_Importance": notificationImportance,
        "Channel_Description": channelDescription,
        "Group_ID": groupId,
        "Sound_File_Name": notificationSoundFile
      };
}

class NotificationManager {
  // ignore: constant_identifier_names
  static const int IMPORTANCE_DEFAULT = 3;
  // ignore: constant_identifier_names
  static const int IMPORTANCE_HIGH = 4;
  // ignore: constant_identifier_names
  static const int IMPORTANCE_LOW = 2;
  // ignore: constant_identifier_names
  static const int IMPORTANCE_MAX = 5;
  // ignore: constant_identifier_names
  static const int IMPORTANCE_MIN = 1;
  // ignore: constant_identifier_names
  static const int IMPORTANCE_NONE = 0;
  // ignore: constant_identifier_names
  static const int IMPORTANCE_UNSPECIFIED = -1000;
}
