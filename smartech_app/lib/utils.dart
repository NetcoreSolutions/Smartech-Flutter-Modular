import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  getCurrentRoute() {
    // ModelRp
  }

  Future<dynamic> navigateTO(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  Future<dynamic> navigateToWithReplacement(String routeName) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }
}
