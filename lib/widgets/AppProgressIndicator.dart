import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../All.dart';

class AppProgressIndicator extends StatelessWidget {
  final Color defaultColor;
  AppProgressIndicator({this.defaultColor = blueDark});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(defaultColor)
    );
  }
}