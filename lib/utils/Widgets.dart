import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:valex_agro_audit_app/All.dart';

Future<dynamic> showModal(Widget modal) async {
  return await showDialog<void>(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return modal;
      }
  );
}

extension Widgets on Widget {
  Widget safe() => SafeArea(child: this);
  Widget material({Color color = Colors.white}) => Material(child: this, color: color);
  Widget expanded({int flex = 1}) => Expanded(child: this, flex: flex);
  Widget center() => Center(child: this);
  Widget flexible() => Flexible(child: this);
  Widget color(Color color) => Container(child: this, color: color);
  Widget scrollWidget({Axis direction = Axis.vertical}) => SingleChildScrollView(child: this, scrollDirection: direction);
  Widget visibility(bool isVisible) => Visibility(visible: isVisible, child: this);
  Widget width(double width) => Container(width: width, child: this);
  Widget height(double height) => Container(height: height, child: this);
  Widget sized(double width, double height) => Container(width: width, height: height, child: this);

  Widget onClick(Function() action) =>
      GestureDetector(onTap: action, child: this);


  Widget paddingWidget(
      {double left = 0,
        double top = 0,
        double right = 0,
        double bottom = 0}) =>
      Padding(
          padding: EdgeInsets.only(
              left: left, top: top, right: right, bottom: bottom),
          child: this);

  Widget paddingAllWidget(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetricWidget({double vertical = 0, double horizontal = 0}) =>
      Padding(padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal), child: this);

  Widget marginWidget(
      {double left = 0,
        double top = 0,
        double right = 0,
        double bottom = 0}) =>
      Container(
          margin: EdgeInsets.only(
              left: left, top: top, right: right, bottom: bottom),
          child: this);

  Widget marginAllWidget(double padding) =>
      Container(margin: EdgeInsets.all(padding), child: this);

  Widget marginSymmetricWidget({double vertical = 0, double horizontal = 0}) =>
      Container(margin: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal), child: this);
}