import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:valex_agro_audit_app/All.dart';

class AuditItem extends StatefulWidget {
  final ClientAudit audit;
  AuditItem(this.audit);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AuditItem> {
  final DateFormat dateFormat = DateFormat('hh:mm dd.MM.yyyy');

  @override
  Widget build(BuildContext context) {
    return Container(
        key: Key("audit_${widget.audit.id}"),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: greyMedium)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.audit.user, style: styleBoldP16).marginWidget(bottom: blockY),
            Text(widget.audit.address, style: styleBoldP14).marginWidget(bottom: blockY),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dateFormat.format(widget.audit.date), style: styleBoldP14),
                  if(!widget.audit.isSaved)
                    Row(
                      children: [
                        Text("need_sync", style: styleBoldP12.copyWith(color: redAccent)),
                        Container(width: 5),
                        SvgPicture.asset("assets/icons/warning.svg", color: redAccent, width: 15, height: 15)
                      ]
                    )
                ]
            )
          ]
        )
    );
  }

}