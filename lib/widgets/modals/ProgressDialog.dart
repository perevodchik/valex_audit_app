import 'package:flutter/material.dart';
import 'package:valex_agro_audit_app/All.dart';

Future<void> progressDialog({BuildContext? context}) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context ?? navigatorKey.currentContext!,
      builder: (BuildContext context) => Center(child: CircularProgressIndicator())
  );
}