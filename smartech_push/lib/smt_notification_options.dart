class SMTNotificationOptions {

  String? smallIconTransparentId;
  String? largeIconId;
  String? placeHolderIcon;
  String? smallIconId;
  String? transparentIconBgColor;

  SMTNotificationOptions(
      {this.smallIconTransparentId,
      this.largeIconId,
      this.placeHolderIcon,
      this.smallIconId,
      this.transparentIconBgColor});

  Map<String, dynamic> toJson() => {
        "smallIconTransparentId": smallIconTransparentId,
        "largeIconId": largeIconId,
        "placeHolderIcon": placeHolderIcon,
        "smallIconId": smallIconId,
        "transparentIconBgColor": transparentIconBgColor
      };

}
