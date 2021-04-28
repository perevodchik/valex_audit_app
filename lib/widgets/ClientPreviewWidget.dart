import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valex_agro_audit_app/All.dart';

class ClientPreviewWidget extends StatefulWidget {
  final ClientPreview client;
  ClientPreviewWidget(this.client);
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ClientPreviewWidget> {

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
                        PopupMenuButton<String>(
                          elevation: 5,
                          padding: EdgeInsets.zero,
                          onSelected: (s) {
                            switch (s) {
                              case "Редактировать":
                                  goToNamed(Routes.editClient, {
                                    "client": widget.client
                                  });
                                  break;
                              case "Начать аудит":
                                  goToNamed(Routes.auditClient, {
                                    "client": widget.client
                                  });
                                  break;
                            //   case "Синхронизировать":
                            //     // widget.client.isNeedSync = false;
                            //     widget.client.dateLastAudit = DateTime.now().toString();
                            //     widget.client.userLastAudit = BlocProvider.of<UserCubit>(context).state?.name ?? "User";
                            //     BlocProvider.of<ClientsCubit>(navigatorKey.currentContext!).update(widget.client);
                            //     break;
                            }
                          },
                            // "Синхронизировать",
                            itemBuilder: (BuildContext context) {
                            return {"Редактировать", "Начать аудит"}.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          }
                        )
                      ]
                  ),
                  Text(widget.client.address ?? "", style: styleBoldP14.copyWith(color: greyMedium)),
                  if(widget.client.dateLastAudit?.isNotEmpty ?? false)
                    Text("last_audit", style: styleNormalP12).marginWidget(top: blockY),
                  if(widget.client.dateLastAudit?.isNotEmpty ?? false)
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.client.userLastAudit ?? "", style: styleBoldP12),
                          Text(widget.client.dateLastAudit ?? "", style: styleBoldP12)
                          // DateFormat("dd.MM.yy").format(DateTime.parse( ?? DateTime.now().toString()))
                        ]
                    )
                ]
            )
        )
      )
    );
  }
}