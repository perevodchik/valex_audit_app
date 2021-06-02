import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';

import '../All.dart';

class AuditDataItem extends StatefulWidget {
  final AuditData data;
  final bool isEditable;
  final bool withAdditional;
  AuditDataItem(this.data, {this.isEditable = true, this.withAdditional = true});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AuditDataItem> {
  TextEditingController? value, additional;

  @override
  void initState() {
    value = TextEditingController(text: widget.data.value);
    additional = TextEditingController(text: widget.data.additional);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: Key("audit_data_item_${widget.data.id}"),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: greyMedium)
        ),
        child: Wrap(
            runSpacing: 10,
            children: [
              Text(widget.data.title.tr()),
              CustomRoundedTextField(value, hint: "data_card_value".tr(), helperText: "data_card_value".tr(), maxLines: 3,
                  onChanged: (v) {
                    widget.data.value = v;
                    print(widget.data.value);
                  }, isEnable: widget.isEditable).center(),
              if(widget.withAdditional)
              CustomRoundedTextField(additional, hint: "data_card_additional".tr(), helperText: "data_card_additional".tr(), maxLines: 3,
                  onChanged: (a) => widget.data.additional = a, isEnable: widget.isEditable).center(),
            ]
        )
    );
  }
}