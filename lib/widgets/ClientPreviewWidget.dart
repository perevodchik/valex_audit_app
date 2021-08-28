import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:easy_localization/easy_localization.dart';

class ClientPreviewWidget extends StatefulWidget {
  final ClientPreview client;
  final Function? onDelete;
  ClientPreviewWidget(this.client, {this.onDelete});
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ClientPreviewWidget> {
  final DateFormat dateFormat = DateFormat('hh:mm dd.MM.yyyy');

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          goToNamed(Routes.client, {
            "client": widget.client
          });
        },
        child: Container(
            padding: EdgeInsets.only(left: margin5X / 2, right: margin5X / 2, bottom: blockY),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: greyMedium, width: 1)
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedDefaultTextStyle(
                            child: Text(widget.client.name ?? ""),
                            style: styleBoldP20.copyWith(color: Colors.black),
                            duration: Duration(milliseconds: 500)
                        ),
                        BlocBuilder<UserCubit, User?>(
                          builder: (_, state) {
                            return PopupMenuButton<String>(
                                elevation: 5,
                                padding: EdgeInsets.zero,
                                onSelected: (s) async {
                                  switch (s) {
                                    case "edit":
                                      goToNamed(Routes.editClient, {
                                        "client": widget.client
                                      });
                                      break;
                                    case "audits":
                                      goToNamed(Routes.auditListClient, {
                                        "client": await ClientsRepository.getClientById(widget.client.id)
                                      });
                                      break;
                                    case "start_audit":
                                      goToNamed(Routes.auditClient, {
                                        "client": widget.client
                                      });
                                      break;
                                    case "delete":
                                      await showModal(ModalAcceptClientDelete(widget.client, onDelete: widget.onDelete));
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  var items = <String> [
                                    if(state?.canEdit == true)
                                      "edit",
                                    "audits",
                                    if(state?.canCreate == true)
                                      "start_audit",
                                    if(state?.canDelete == true)
                                      "delete"
                                  ];
                                  return items.map((String choice) {
                                    return PopupMenuItem<String> (
                                      value: choice,
                                      child: Text(choice.tr()),
                                    );
                                  }).toList();
                                }
                            );
                          }
                        )
                      ]
                  ),
                  Text(widget.client.address ?? "", style: styleBoldP14.copyWith(color: greyMedium)),
                  if(widget.client.lastAudit != null)
                    Text("last_audit".tr(), style: styleNormalP12).marginWidget(top: blockY),
                  if(widget.client.lastAudit != null)
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.client.userLastAudit ?? "", style: styleBoldP12),
                          Text(dateFormat.format(widget.client.lastAudit ?? DateTime.now()), style: styleBoldP12)
                        ]
                    )
                ]
            )
        )
      )
    );
  }
}