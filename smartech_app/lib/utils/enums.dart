import 'package:flutter/material.dart';

enum NotificationType {
  simple,
  audio,
  image,
  gif,
  carouselLandscape,
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
      case NotificationType.carouselLandscape:
        return "CarouselLandscape";
      case NotificationType.simple:
      default:
        return "Simple";
    }
  }
}
