import 'package:flutter/material.dart';

enum NotificationType {
  simple,
  audio,
  image,
  gif,
  carousel,
}

extension NotificationTypeExtension on NotificationType {
  String getName() {
    switch (this) {
      case NotificationType.audio:
        return "Audio";
      case NotificationType.image:
        return "Image";
      case NotificationType.gif:
        return "GIF";
      case NotificationType.carousel:
        return "Carousel";
      case NotificationType.simple:
      default:
        return "Simple";
    }
  }
}
