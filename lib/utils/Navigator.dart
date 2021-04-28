import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../All.dart';

Future<dynamic> goToNamed(String route,
    Map<String, dynamic> data, {
    isReplacePage = false,
    isRemovePreviously = false}) async {
  print("go to $route, isReplacePage $isReplacePage, isRemovePreviously $isRemovePreviously, with $data");
  if(isReplacePage)
    return Navigator.pushReplacementNamed(navigatorKey.currentContext!, route, arguments: data);
  else if(isRemovePreviously) {
    return Navigator.pushNamedAndRemoveUntil(
        navigatorKey.currentContext!, route, (v) => false, arguments: data);
  }
  else
    return Navigator.pushNamed(navigatorKey.currentContext!, route, arguments: data);
}

class Routes {
  static const String splash = "splash";
  static const String signIn = "signIn";
  static const String main = "main";
  static const String client = "client";
  static const String audit = "audit";
  static const String newClient = "newClient";
  static const String editClient = "editClient";
  static const String auditClient = "auditClient";
  static const String auditListClient = "auditListClient";
  static const String reviewClient = "reviewClient";
  static const String reviewPage = "reviewPage";
}