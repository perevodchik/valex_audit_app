import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:easy_localization/easy_localization.dart';

class ModalAcceptAuditDelete extends StatefulWidget {
  final ClientAudit audit;
  final Function? onDelete;
  ModalAcceptAuditDelete(this.audit, {this.onDelete});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ModalAcceptAuditDelete> {
  final DateFormat dateDeleteFormat = DateFormat('dd.MM.yyyy');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Container(
            height: 300,
            width: 320,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16)
            ),
            child: Stack(
                children: [
                  Positioned(
                      top: height / 2 - 150,
                      left: 0,
                      right: 0,
                      child: Container(
                          padding: EdgeInsets.only(top: margin5Y),
                          height: 300,
                          width: 320,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16)
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("accept_audit_delete".tr(args: [widget.audit.user, dateDeleteFormat.format(widget.audit.date)]),
                                    textAlign: TextAlign.center,
                                    style: styleBoldP21.copyWith(color: blueDark, fontFamily: "Arial")).material()
                                    .marginWidget(left: margin5X, right: margin5X)
                                    .expanded(),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      AppTextButton(
                                          Text("back".tr(), style: styleBoldP14.copyWith(color: blueAccent)),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          }
                                      ),
                                      AppTextButton(
                                          Text("delete".tr(), style: styleBoldP14.copyWith(color: red)),
                                          onPressed: () async {
                                            progressDialog();
                                            await LocalStorage().removeAudit(widget.audit);
                                            await AuditRepository.removeAudit(widget.audit.clientId, widget.audit.id);
                                            widget.onDelete?.call();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }, splash: red.withOpacity(.3)
                                      )
                                    ]
                                ).marginSymmetricWidget(horizontal: margin5X / 2).marginWidget(bottom: margin5Y / 2)
                              ]
                          )
                      )
                  )
                ]
            ).marginSymmetricWidget(horizontal: margin5X)
        )
    );
  }
}