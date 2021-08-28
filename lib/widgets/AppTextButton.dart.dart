import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final Color? splash;
  final int? borderRadius;

  AppTextButton(this.child, {this.onPressed, this.color, this.splash, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
          child: child,
          onPressed: onPressed,
          style: ButtonStyle(
              elevation: MaterialStateProperty.resolveWith((states) => 0),
              shape: MaterialStateProperty.resolveWith((states) =>
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius?.toDouble() ?? 14)
                  )
              ),
            overlayColor: MaterialStateProperty.resolveWith((states) => splash)
          )
      )
    );
  }

}