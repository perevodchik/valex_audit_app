import 'package:flutter/material.dart';
import 'package:valex_agro_audit_app/All.dart';

Future<void> progressDialogStream(Stream<String> logListener) {
  return showDialog<void>(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Material(
                  // color: Colors.transparent,
                  child: StreamBuilder(
                      stream: logListener,
                      builder: (_, AsyncSnapshot<String> data) => Text(data.data ?? "Очікування даних", style: TextStyle(
                        fontSize: 20
                      ))
                  )
                )
              ]
          )
      )
  );
}

Future<void> progressDialog() {
  return showDialog<void>(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => Center(child: CircularProgressIndicator())
  );
}