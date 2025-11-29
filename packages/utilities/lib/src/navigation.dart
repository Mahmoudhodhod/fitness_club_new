import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class NavigationService {
  NavigationService._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? get context => navigatorKey.currentContext;
}
