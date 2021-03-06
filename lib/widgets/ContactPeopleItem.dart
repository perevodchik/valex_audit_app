import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactPeopleItem extends StatefulWidget {
  final ContactPeople contactPeople;
  final bool isEditable;
  ContactPeopleItem(this.contactPeople, {this.isEditable = true});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ContactPeopleItem> {
  TextEditingController? name, phone, work;

  @override
  void initState() {
    name = TextEditingController(text: widget.contactPeople.name);
    phone = TextEditingController(text: widget.contactPeople.phone);
    work = TextEditingController(text: widget.contactPeople.work);
    super.initState();
  }

  @override
  void dispose() {
    name?.dispose();
    phone?.dispose();
    work?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key("contact_people_item_${widget.contactPeople.id}"),
      padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: greyMedium)
        ),
        child: Wrap(
            runSpacing: 10,
            children: [
              CustomRoundedTextField(name, hint: "people_card_name".tr(), helperText: "people_card_name".tr(),
                  onChanged: (n) => widget.contactPeople.name = n, isEnable: widget.isEditable).center(),
              Row(
                children: [
                  CustomRoundedTextField(work, hint: "people_card_work".tr(), helperText: "people_card_work".tr(),
                      onChanged: (w) => widget.contactPeople.work = w, isEnable: widget.isEditable).expanded(),
                  Container(width: 10),
                  CustomRoundedTextField(phone, hint: "people_card_phone".tr(), helperText: "people_card_phone".tr(),
                      onChanged: (p) => widget.contactPeople.phone = p, isEnable: widget.isEditable).expanded()
                ]
              ).width(width).height(50)
            ]
        )
    );
  }
}