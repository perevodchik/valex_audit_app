import 'package:flutter/widgets.dart';

bool isInitialized = false;
MediaQueryData? data;
double width = 0;
double height = 0;
double pr = 0;
double blockX = 0;
double blockY = 0;
double margin5X = 0;
double margin10X = 0;
double margin5Y = 0;
double margin10Y = 0;
double buttonWidth = 0;
double buttonHeight = 0;
double defaultMargin = 0;
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
final String tableUsers = "users";
final String tableClients = "clients";
final String tableClientsShort = "clientsShort";
final String tableReviews = "tableReviews";
final String tableAudits = "tableAudits";
final String tableAuditsShort = "tableAuditsShort";

class Global {

  static build() {
    if(isInitialized) return;
    isInitialized = true;
    data = MediaQuery.of(navigatorKey.currentContext!);
    width = data?.size.width ?? 0;
    height = data?.size.height ?? 0;
    pr = data?.devicePixelRatio ?? 0;
    blockX = width / 100;
    blockY = height / 100;
    margin5X = blockX * 5;
    margin10X = blockX * 10;
    margin5Y = blockY * 5;
    margin10Y = blockY * 10;
    defaultMargin = blockX * 3;
    buttonWidth = blockX * 50;
    buttonHeight = blockY * 6;
  }

}