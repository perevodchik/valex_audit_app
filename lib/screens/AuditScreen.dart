import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:valex_agro_audit_app/All.dart';

class AuditScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  AuditScreen(this.args);

  State<StatefulWidget> createState() => _State();
}

class _State extends State<AuditScreen> with SingleTickerProviderStateMixin {
  Map<String, dynamic> args = {};
  ClientAudit? audit;
  bool isLoading = false;
  PageController? page, firstAuditPage, secondAuditPage, thirdAuditPage;
  TabController? tab;
  int selectedAudit0 = 0;
  int selectedAudit1 = 0;
  int selectedAudit2 = 0;
  int currentPage = 0;
  final DateFormat dateFormat = DateFormat('hh:mm dd.MM.yyyy');

  @override
  void initState() {
    args = widget.args;
    audit = args["audit"];
    page = PageController();
    firstAuditPage = PageController();
    secondAuditPage = PageController();
    thirdAuditPage = PageController();
    tab = TabController(length: audit?.auditQuestions.length ?? 6, vsync: this);
    load();
    super.initState();
  }

  @override
  void dispose() {
    page?.dispose();
    firstAuditPage?.dispose();
    secondAuditPage?.dispose();
    thirdAuditPage?.dispose();
    super.dispose();
  }

  Future<void> load() async {
    await NetworkRepository.refreshNetworkStatus();
    if(BlocProvider.of<NetworkCubit>(navigatorKey.currentContext!).state == ConnectivityResult.none && audit!.isCached) {
      audit = await LocalStorage().getAudit(audit!.id);
    } else {
      audit = await AuditRepository.getAudit(audit!.id, audit!.clientId);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("client_audit"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: blueAccent,
            brightness: Brightness.dark
        ),
        body: Stack(
            children: [
              Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("place"),
                          Text(dateFormat.format(DateTime.tryParse(audit?.date ?? "") ?? DateTime.now()), style: styleBoldP14)
                        ]
                    ).marginSymmetricWidget(horizontal: margin5X, vertical: blockY * 1.5),
                    PageView(
                        onPageChanged: (newPage) => setState(() => currentPage = newPage),
                        controller: page,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("main_info", style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY ),
                                Wrap(
                                    runSpacing: blockY,
                                    children: (audit?.data ?? []).map<Widget>((data) => AuditDataItem(data, isEditable: false).marginSymmetricWidget(horizontal: margin5X)).toList()
                                )
                              ]
                          ).scrollWidget(),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("audit_0", style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY),
                                ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: false,
                                    itemCount: (audit?.auditQuestions["audit_0"] ?? {}).entries.length,
                                    itemBuilder: (_, c) {
                                      var item = (audit?.auditQuestions["audit_0"] ?? {}).keys.toList()[c];
                                      return InkWell(
                                          borderRadius: BorderRadius.circular(10),
                                          onTap: () {
                                            setState(() => selectedAudit0 = c);
                                            firstAuditPage?.jumpToPage(c);
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: blockX, vertical: blockY),
                                              child: Text(item, style: c == selectedAudit0 ? styleBoldP14.copyWith(color: blueAccent) : styleNormalP14)
                                          )
                                      ).center();
                                    },
                                    separatorBuilder: (_, i) => Container(width: 10, height: 1)
                                ).width(width).height(50).marginSymmetricWidget(horizontal: margin5X),
                                PageView(
                                    onPageChanged: (p) => setState(() => selectedAudit0 = p),
                                    controller: firstAuditPage,
                                    children: (audit?.auditQuestions["audit_0"] ?? {}).entries.map<Widget>((e) {
                                      return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Wrap(
                                                runSpacing: blockY,
                                                children: e.value.map<Widget>((v) => AuditQuestionItem(v, isEditable: false, isCached: audit?.isCached ?? true).marginSymmetricWidget(horizontal: margin5X)).toList()
                                            )
                                          ]
                                      ).scrollWidget();
                                    }).toList()
                                ).expanded()
                              ]
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("audit_1", style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY),
                                ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: false,
                                    itemCount: (audit?.auditQuestions["audit_1"] ?? {}).entries.length,
                                    itemBuilder: (_, c) {
                                      var item = (audit?.auditQuestions["audit_1"] ?? {}).keys.toList()[c];
                                      return InkWell(
                                          borderRadius: BorderRadius.circular(10),
                                          onTap: () {
                                            setState(() => selectedAudit1 = c);
                                            secondAuditPage?.jumpToPage(c);
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: blockX, vertical: blockY),
                                              child: Text(item, style: c == selectedAudit1 ? styleBoldP14.copyWith(color: blueAccent) : styleNormalP14)
                                          )
                                      ).center();
                                    },
                                    separatorBuilder: (_, i) => Container(width: 10, height: 1)
                                ).width(width).height(50).marginSymmetricWidget(horizontal: margin5X),
                                PageView(
                                    onPageChanged: (p) => setState(() => selectedAudit1 = p),
                                    controller: secondAuditPage,
                                    children: (audit?.auditQuestions["audit_1"] ?? {}).entries.map<Widget>((e) => Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                              runSpacing: blockY,
                                              children: e.value.map<Widget>((v) => AuditQuestionItem(v, isEditable: false, isCached: audit?.isCached ?? true).marginSymmetricWidget(horizontal: margin5X)).toList()
                                          )
                                        ]
                                    ).scrollWidget()).toList()
                                ).expanded()
                              ]
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("audit_2", style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY),
                                ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: false,
                                    itemCount: (audit?.auditQuestions["audit_2"] ?? {}).entries.length,
                                    itemBuilder: (_, c) {
                                      var item = (audit?.auditQuestions["audit_2"] ?? {}).keys.toList()[c];
                                      return InkWell(
                                          borderRadius: BorderRadius.circular(10),
                                          onTap: () {
                                            setState(() => selectedAudit2 = c);
                                            thirdAuditPage?.jumpToPage(c);
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: blockX, vertical: blockY),
                                              child: Text(item, style: c == selectedAudit2 ? styleBoldP14.copyWith(color: blueAccent) : styleNormalP14)
                                          )
                                      ).center();
                                    },
                                    separatorBuilder: (_, i) => Container(width: 10, height: 1)
                                ).width(width).height(50).marginSymmetricWidget(horizontal: margin5X),
                                PageView(
                                    onPageChanged: (p) => setState(() => selectedAudit2 = p),
                                    controller: thirdAuditPage,
                                    children: (audit?.auditQuestions["audit_2"] ?? {}).entries.map<Widget>((e) => Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Wrap(
                                              runSpacing: blockY,
                                              children: e.value.map<Widget>((v) => AuditQuestionItem(v, isEditable: false, isCached: audit?.isCached ?? true).marginSymmetricWidget(horizontal: margin5X)).toList()
                                          )
                                        ]
                                    ).scrollWidget()).toList()
                                ).expanded()
                              ]
                          )
                        ]
                    ).expanded(),
                    Row(
                        children: [
                          (currentPage > 0 ? AppTextButton(
                              Text("back", style: styleBoldP14.copyWith(color: blueAccent)),
                              onPressed: () => page?.previousPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn)
                          ) : Container()).expanded(),
                          Container(width: 20),
                          AppElevatedButton(
                              Text(currentPage < 3 ? "next" : "generate_pdf", style: styleBoldP14.copyWith(color: Colors.white)),
                              onPressed: () async {
                                if(currentPage == 3) {
                                  if(isLoading) return;
                                  setState(() => isLoading = true);
                                  try {
                                    await NetworkRepository.refreshNetworkStatus();
                                    if(BlocProvider.of<NetworkCubit>(navigatorKey.currentContext!).state != ConnectivityResult.none) {
                                      audit?.isSaved = true;
                                      await FirebaseFirestore
                                          .instance
                                          .collection(tableClients)
                                          .doc(audit!.clientId)
                                          .collection(tableAudits)
                                          .doc(audit!.id)
                                          .update({
                                        "isSaved": true
                                      });
                                      await FirebaseFirestore
                                          .instance
                                          .collection(tableClients)
                                          .doc(audit!.clientId)
                                          .collection(tableAuditsShort)
                                          .doc(audit!.id)
                                          .update({
                                        "isSaved": true
                                      });

                                      await FirebaseFirestore
                                          .instance
                                          .collection(tableClientsShort)
                                          .doc(audit!.clientId)
                                          .collection(tableAudits)
                                          .doc(audit!.id)
                                          .update({
                                        "isSaved": true
                                      });
                                      await FirebaseFirestore
                                          .instance
                                          .collection(tableClientsShort)
                                          .doc(audit!.clientId)
                                          .collection(tableAuditsShort)
                                          .doc(audit!.id)
                                          .update({
                                        "isSaved": true
                                      });
                                      audit?.isSaved = true;
                                      await createPdf(audit!, true);
                                    } else
                                      await createPdf(audit!, false);
                                  } catch(e) {
                                    print("error: $e");
                                  }
                                  setState(() => isLoading = false);
                                }
                                if(currentPage < 3) {
                                  page?.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                  return;
                                }
                              }
                          ).expanded()
                        ]
                    ).width(width).marginSymmetricWidget(horizontal: margin5X).marginWidget(bottom: blockY * 2.5)
                  ]
              ),
              if(isLoading)
                LoadingHud()
            ]
        )
    );
  }
}