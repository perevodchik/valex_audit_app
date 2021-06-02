import 'package:flutter/material.dart';
import 'package:valex_agro_audit_app/utils/Global.dart';

Future<void> progressDialog({BuildContext? context}) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context ?? navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Center(
            child: CircularProgressIndicator()
        );
      }
  );
}