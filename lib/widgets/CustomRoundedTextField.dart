import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../All.dart';

class CustomRoundedTextField extends StatelessWidget {
  final TextEditingController? controller;
  final bool isEnable;
  final String? hint;
  final String? helperText;
  final Widget? leading;
  final Widget? trailing;
  final double borderRadius;
  final TextInputType inputType;
  final List<TextInputFormatter>? formatters;
  final FormFieldValidator<String>? validator;
  final Function(String q)? onChanged;
  final Function(String q)? onSubmit;
  final Function()? onComplete;
  final int lines;
  final int maxLines;
  final Color? borderColor;
  final Color? background;
  final TextStyle? style;

  CustomRoundedTextField(this.controller, {
    this.isEnable = true,
    this.leading,
    this.trailing,
    this.hint,
    this.helperText,
    this.borderRadius = 10,
    this.inputType = TextInputType.text,
    this.formatters,
    this.onChanged,
    this.onSubmit,
    this.validator,
    this.onComplete,
    this.lines = 1,
    this.maxLines = 1,
    this.background,
    this.style,
    this.borderColor});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        enabled: isEnable,
        keyboardType: inputType,
        controller: controller,
        inputFormatters: formatters ?? [],
        validator: validator,
        minLines: lines,
        maxLines: maxLines,
        onFieldSubmitted: onSubmit,
        onChanged: onChanged,
        onEditingComplete: onComplete,
        style: style ?? styleBoldP14.copyWith(color: blueDark, fontFamily: "Arial"),
        decoration: InputDecoration(
            labelText: helperText,
            fillColor: background ?? Colors.white,
            filled: true,
            hintText: hint,
            hintStyle: style ?? styleNormalP12.copyWith(color: silver, fontFamily: "Arial"),
            prefixIcon: leading != null ? Container(
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(minWidth: 15, maxWidth: 15, maxHeight: 15, minHeight: 15),
                child: leading
            ) : null,
            suffixIcon: trailing,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                    color: borderColor ?? greyMedium
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                    color: borderColor ?? greyMedium
                )
            ),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                    color: borderColor ?? greyMedium
                )
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                    color: borderColor ?? greyMedium
                )
            )
        )
    );
  }
}