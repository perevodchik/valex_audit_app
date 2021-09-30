import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:easy_localization/easy_localization.dart';

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
  ScrollController? firstAuditTitle, secondAuditTitle, thirdAuditTitle;
  TabController? tab;
  int selectedAudit0 = 0;
  int selectedAudit1 = 0;
  int selectedAudit2 = 0;
  int currentPage = 0;
  final DateFormat dateFormat = DateFormat('HH:mm dd.MM.yyyy');
  File? pdfFile;
  bool _hasFocus = false;

  @override
  void initState() {
    args = widget.args;
    audit = args["audit"];
    page = PageController();
    firstAuditPage = PageController();
    secondAuditPage = PageController();
    thirdAuditPage = PageController();

    firstAuditTitle = ScrollController();
    secondAuditTitle = ScrollController();
    thirdAuditTitle = ScrollController();

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

    firstAuditTitle?.dispose();
    secondAuditTitle?.dispose();
    thirdAuditTitle?.dispose();
    super.dispose();
  }

  Future<void> load() async {
    await NetworkRepository.refreshNetworkStatus();
    if(BlocProvider.of<NetworkCubit>(navigatorKey.currentContext!).state == ConnectivityResult.none && audit!.isCached) {
      audit = await LocalStorage().getAudit(audit!.id);
    } else {
      audit = await AuditRepository.getAudit(audit!.id, audit!.clientId);
    }
    if(mounted)
      setState(() {});
  }

  Future<void> generatePdf() async {
    if(isLoading) return;
    setState(() => isLoading = true);
    try {
      await NetworkRepository.refreshNetworkStatus();
      if(BlocProvider.of<NetworkCubit>(navigatorKey.currentContext!).state != ConnectivityResult.none) {
        if(!(audit?.isSaved ?? true)) {
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
        }
        var client = await ClientsShortRepository.getClient(audit!.clientId);
        if(client?.lastAudit == null || client!.lastAudit!.millisecondsSinceEpoch < audit!.date.millisecondsSinceEpoch) {
          BlocProvider.of<ClientsCubit>(context).updateClientLastAudit(audit!.clientId, BlocProvider.of<UserCubit>(navigatorKey.currentContext!).state?.name ?? "", audit!.date);
          await FirebaseFirestore.instance.collection(tableClients).doc(audit!.clientId).update({
            "lastAudit": audit!.date,
            "userLastAudit": BlocProvider.of<UserCubit>(navigatorKey.currentContext!).state?.name ?? ""
          });
          await FirebaseFirestore.instance.collection(tableClientsShort).doc(audit!.clientId).update({
            "lastAudit": audit!.date,
            "userLastAudit": BlocProvider.of<UserCubit>(navigatorKey.currentContext!).state?.name ?? ""
          });
        }

        try {
          var file = await createPdf(audit!, true, company: BlocProvider.of<UserCubit>(context).state?.company ?? "", manager: BlocProvider.of<UserCubit>(context).state?.name ?? "");
          Navigator.push(navigatorKey.currentContext!, CupertinoPageRoute(builder: (_) =>  PdfFileViewPage(file, audit!)));
        } catch(e) {
          Fluttertoast.showToast(
              msg: "$e",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      } else
        try {
          FocusScope.of(context).unfocus();
          var file = await createPdf(audit!, false, company: BlocProvider.of<UserCubit>(context).state?.company ?? "", manager: BlocProvider.of<UserCubit>(context).state?.name ?? "");
          Navigator.push(navigatorKey.currentContext!, CupertinoPageRoute(builder: (_) =>  PdfFileViewPage(file, audit!)));
        } catch(e) {
          Fluttertoast.showToast(
              msg: "$e",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
    } catch(e) {
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print("error: $e");
    }
    setState(() => isLoading = false);
  }

  Future<void> _createPdf() async {
    print("audit ${audit?.isSaved}");
    progressDialog();
    try {
      if(pdfFile == null)
        pdfFile = await createPdf(
            audit!,
            true,
            company: BlocProvider.of<UserCubit>(context).state?.company ?? "",
            manager: BlocProvider.of<UserCubit>(context).state?.name ?? "");
      await uploadFileToDrive(pdfFile!, audit?.user ?? "admin", audit?.address ?? "address", audit?.date ?? DateTime.now());

      print("audit ${audit?.isSaved}");
      if(!(audit?.isSaved ?? true)) {
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
      }
    } catch(e) { print("$e"); }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print(audit?.clientId);
    print(audit?.id);
    return Scaffold(
        appBar: AppBar(
            title: Text("client_audit".tr()),
            centerTitle: true,
            elevation: 0,
            backgroundColor: blueAccent,
            brightness: Brightness.dark,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.picture_as_pdf),
                onPressed: () async => await generatePdf()
              ),
              IconButton(
                  icon: Icon(Icons.add_to_drive_outlined),
                  onPressed:()=> _createPdf()
              )
            ]
        ),
        body: Stack(
            children: [
              Focus(
                  onFocusChange: (hasFocus) => setState(() => _hasFocus = hasFocus),
                  child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("audit_place".tr()),
                              Text(dateFormat.format(audit?.date ?? DateTime.now()), style: styleBoldP14)
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
                                    Text("main_info".tr(), style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY ),
                                    Wrap(
                                        runSpacing: blockY,
                                        children: (audit?.data ?? []).map<Widget>((data) => AuditDataItem(data, isEditable: true).marginSymmetricWidget(horizontal: margin5X)).toList()
                                    )
                                  ]
                              ).scrollWidget(),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("audit_0".tr(), style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY),
                                    ListView.separated(
                                        controller: firstAuditTitle,
                                        physics: BouncingScrollPhysics(),
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
                                                  child: Text(item.tr(), style: c == selectedAudit0 ? styleBoldP14.copyWith(color: blueAccent) : styleNormalP14)
                                              )
                                          ).center();
                                        },
                                        separatorBuilder: (_, i) => Container(width: 10, height: 1)
                                    ).width(width).height(50).marginSymmetricWidget(horizontal: margin5X),
                                    PageView(
                                        onPageChanged: (p) {
                                          if(p == 3 && selectedAudit0 == 2) {
                                            firstAuditTitle?.animateTo(firstAuditTitle?.position.maxScrollExtent ?? 0 , duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                          } else if(p == 2 && selectedAudit0 == 3) {
                                            firstAuditTitle?.animateTo(0 , duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                          }
                                          setState(() => selectedAudit0 = p);
                                        },
                                        controller: firstAuditPage,
                                        children: (audit?.auditQuestions["audit_0"] ?? {}).entries.map<Widget>((e) {
                                          return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Wrap(
                                                    runSpacing: blockY,
                                                    children: e.value.map<Widget>((v) => AuditQuestionItem(v, isEditable: true, isCached: audit?.isCached ?? true).marginSymmetricWidget(horizontal: margin5X)).toList()
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
                                    Text("audit_1".tr(), style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY),
                                    ListView.separated(
                                        controller: secondAuditTitle,
                                        physics: BouncingScrollPhysics(),
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
                                                  child: Text(item.tr(), style: c == selectedAudit1 ? styleBoldP14.copyWith(color: blueAccent) : styleNormalP14)
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
                                                  children: e.value.map<Widget>((v) => AuditQuestionItem(v, isEditable: true, isCached: audit?.isCached ?? true).marginSymmetricWidget(horizontal: margin5X)).toList()
                                              )
                                            ]
                                        ).scrollWidget()).toList()
                                    ).expanded()
                                  ]
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("audit_2".tr(), style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY),
                                    ListView.separated(
                                        controller: thirdAuditTitle,
                                        physics: BouncingScrollPhysics(),
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
                                                  child: Text(item.tr(), style: c == selectedAudit2 ? styleBoldP14.copyWith(color: blueAccent) : styleNormalP14)
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
                                                  children: e.value.map<Widget>((v) => AuditQuestionItem(v, isEditable: true, isCached: audit?.isCached ?? true).marginSymmetricWidget(horizontal: margin5X)).toList()
                                              )
                                            ]
                                        ).scrollWidget()).toList()
                                    ).expanded()
                                  ]
                              )
                            ]
                        ).expanded(),
                        if(!_hasFocus)
                          Row(
                              children: [
                                (currentPage > 0 ? AppTextButton(
                                    Text("back".tr(), style: styleBoldP14.copyWith(color: blueAccent)),
                                    onPressed: () {
                                      var p = page?.page?.toInt();
                                      if(p == 1) {
                                        var current = firstAuditPage?.page?.toInt() ?? 0;
                                        if(current > 0) {
                                          firstAuditPage?.previousPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                          if(current <= 3) {
                                            firstAuditTitle?.animateTo(0 , duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                          }
                                          return;
                                        }
                                      }
                                      else if(p == 2) {
                                        print("${secondAuditPage?.page}");
                                        var current = secondAuditPage?.page?.toInt() ?? 0;
                                        if(current > 0) {
                                          secondAuditPage?.previousPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                          if(current <= 3) {
                                            secondAuditTitle?.animateTo(0 , duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                          }
                                          return;
                                        }
                                      }
                                      else if(p == 3) {
                                        var current = thirdAuditPage?.page?.toInt() ?? 0;
                                        if(current > 0) {
                                          thirdAuditPage?.previousPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                          if(current <= 3) {
                                            thirdAuditTitle?.animateTo(0 , duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                          }
                                          return;
                                        }
                                      }
                                      selectedAudit0 = 0;
                                      selectedAudit1 = 0;
                                      selectedAudit2 = 0;

                                      page?.previousPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                    }
                                ) : Container()).expanded(),
                                Container(width: 20),
                                AppElevatedButton(
                                    Text(currentPage < 3 ? "next".tr() : "save".tr(), style: styleBoldP14.copyWith(color: Colors.white)),
                                    onPressed: () async {
                                      var p = page?.page?.toInt();
                                      FocusScope.of(context).unfocus();
                                      if(p == 1) {
                                        var current = firstAuditPage?.page?.toInt() ?? 0;
                                        var all = (audit!.auditQuestions["audit_0"]?.entries.length) ?? 0;
                                        all -= 1;
                                        if(current < all) {
                                          firstAuditPage?.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                          if(current >= 2) {
                                            firstAuditTitle?.animateTo(firstAuditTitle?.position.maxScrollExtent ?? 0 , duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                          }
                                          return;
                                        }
                                      }
                                      else if(p == 2) {
                                        var current = secondAuditPage?.page?.toInt() ?? 0;
                                        var all = (audit!.auditQuestions["audit_1"]?.entries.length) ?? 0;
                                        all -= 1;
                                        if(current < all) {
                                          secondAuditPage?.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                          if(current >= 2) {
                                            secondAuditTitle?.animateTo(secondAuditTitle?.position.maxScrollExtent ?? 0 , duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                          }
                                          return;
                                        }
                                      } else if(p == 3) {
                                        var current = thirdAuditPage?.page?.toInt() ?? 0;
                                        var all = (audit!.auditQuestions["audit_2"]?.entries.length) ?? 0;
                                        all -= 1;
                                        if(current < all) {
                                          thirdAuditPage?.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                          if(current >= 2) {
                                            thirdAuditTitle?.animateTo(thirdAuditTitle?.position.maxScrollExtent ?? 0 , duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                          }
                                          return;
                                        }
                                      }

                                      if(currentPage == 3) {
                                        var a = audit!;
                                        print("cached? ${a.id} ${a.clientId} ${a.isCached}");
                                        setState(() => isLoading = true);
                                        if(a.isCached) {
                                          await LocalStorage().removeAudit(a);
                                          await LocalStorage().deleteAuditData(a.id);
                                          await LocalStorage().deleteAuditQuestion(a.id);
                                          await LocalStorage().addAudit(a);
                                        } else {
                                          await AuditRepository.removeAudit(a.clientId, a.id);
                                          await AuditRepository.updateAudit(a);
                                        }
                                        setState(() => isLoading = false);
                                        await _createPdf();
                                      }
                                      else if(currentPage < 3) {
                                        page?.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                        return;
                                      }
                                    }
                                ).expanded()
                              ]
                          ).width(width).marginSymmetricWidget(horizontal: margin5X).marginWidget(bottom: blockY * 2.5)
                      ]
                  )
              ),
              if(isLoading)
                LoadingHud()
            ]
        )
    );
  }
}