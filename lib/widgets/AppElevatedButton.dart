import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../All.dart';

class AppElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final int? borderRadius;
  final bool? shadow;

  AppElevatedButton(this.child, {this.onPressed, this.color, this.borderRadius, this.shadow});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          if(shadow ?? true)
          BoxShadow(
            color: greyMedium.withOpacity(.25),
            blurRadius: 20,
            offset: Offset(0, 10)
          )
        ]
      ),
      child: ElevatedButton(
          child: child,
          onPressed: onPressed,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) => color ?? blueAccent),
              elevation: MaterialStateProperty.resolveWith((states) => 0),
              shape: MaterialStateProperty.resolveWith((states) =>
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius?.toDouble() ?? 14)
                  )
              )
          )
      )
    );
  }

}