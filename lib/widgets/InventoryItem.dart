import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:easy_localization/easy_localization.dart';

class InventoryItem extends StatefulWidget {
  final Inventory inventory;
  final bool isEditable;
  InventoryItem(this.inventory, {this.isEditable = true});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<InventoryItem> {
  TextEditingController? name, comment, count;

  @override
  void initState() {
    name = TextEditingController(text: widget.inventory.name);
    comment = TextEditingController(text: widget.inventory.comment);
    count = TextEditingController(text: widget.inventory.count.toString());
    super.initState();
  }

  @override
  void dispose() {
    name?.dispose();
    comment?.dispose();
    count?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: Key("inventory_item_${widget.inventory.id}"),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: greyMedium)
        ),
        child: Wrap(
            runSpacing: 10,
            children: [
              CustomRoundedTextField(name, hint: "inventory_card_name".tr(), helperText: "inventory_card_name".tr(),
                  onChanged: (n) => widget.inventory.name = n, isEnable: widget.isEditable).center(),
              CustomRoundedTextField(count, hint: "inventory_card_count".tr(), helperText: "inventory_card_count".tr(),
                  onChanged: (c) => widget.inventory.count = int.tryParse(c) ?? 0,
                  inputType: TextInputType.number, maxLines: 5, isEnable: widget.isEditable),
              CustomRoundedTextField(comment, hint: "inventory_card_comment".tr(), helperText: "inventory_card_comment".tr(),
                  onChanged: (c) => widget.inventory.comment = c, isEnable: widget.isEditable)

            ]
        )
    );
  }
}