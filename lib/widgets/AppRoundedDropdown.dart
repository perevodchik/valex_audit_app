import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:easy_localization/easy_localization.dart';

class AppRoundedDropdown extends StatefulWidget {
  final List<String> items;
  final String selected;
  final ValueChanged<dynamic?>? onChanged;
  AppRoundedDropdown(this.items, this.selected, this.onChanged);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AppRoundedDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 30,
        maxHeight: 200
      ),
      padding: EdgeInsets.symmetric(vertical: blockY * 1.5, horizontal: margin5X / 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: greyMedium),
        borderRadius: BorderRadius.circular(10)
      ),
      child: IntrinsicHeight(
          child: DropdownButton<String>(
              style: styleBoldP14.copyWith(color: blueDark, fontFamily: "Arial"),
              underline: Container(),
              icon: Container(),
              hint: Text("dropdown_select_value".tr()),
              isExpanded: true,
              items: widget.items.map((String value) {
                return new DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                        child: Text(value)
                    )
                );
              }).toList(),
              value: widget.selected.isEmpty ? null : widget.selected,
              onChanged: widget.onChanged
          ).width(width)
      )
    );
  }
}