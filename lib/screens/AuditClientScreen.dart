import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:valex_agro_audit_app/widgets/ProgressDialog.dart';

import '../All.dart';

class AuditClientScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  AuditClientScreen(this.args);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AuditClientScreen> with SingleTickerProviderStateMixin{
  Map<String, dynamic> args = {};
  ClientPreview? clientPreview;
  PageController? page, firstAuditPage, secondAuditPage, thirdAuditPage;
  bool isLoading = false;
  int currentPage = 0;
  ClientAudit? audit;
  int selectedAudit0 = 0;
  int selectedAudit1 = 0;
  int selectedAudit2 = 0;
  final DateFormat dateFormat = DateFormat('hh:mm dd.MM.yyyy');
  List<Widget> auditDataWidgets = [];

  @override
  void didChangeDependencies() {
    args = widget.args;
    clientPreview = args["client"]!;

    if(audit == null) {
      audit = ClientAudit(
          "",
          clientPreview!.id,
          BlocProvider
              .of<UserCubit>(navigatorKey.currentContext!)
              .state
              ?.name ?? "",
          "place",
          "",
          DateTime.now(),
          clientPreview!.address!,
          false,
          <AuditData>[],
          {
            "audit_0": {
              "audit_title_vacuum_system": [
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_vacuum_nasos",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_vacuum_glushnyk",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_vacuum_reciever",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_vacuumetr",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_vacuum_reguljator",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_sanitarna_camera",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: [])
              ],
              "audit_title_milk_system": [
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_molokopryjmach",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_milk_nasos",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_milk_filter",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_molokoprovid_vid",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_molokoprovody_do",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: [])
              ],
              "audit_title_ohlad_system": [
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_tanker",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_compresorny_agregaty",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_promyvka_na_jakosty_zberigannja",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: [])
              ],
              "audit_title_doilny_aparaty": [
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_colector",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_stakany",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_polsatory",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_diykova_guma",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_large_molk_shlangy",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_pulsator",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: [])
              ],
              "audit_title_vykachka_moloka": [
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_milk_nasos",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_shlang_vykachly",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: [])
              ],
              "audit_title_system_promyvky": [
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_bak_avtomata_promyvky",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_gnizda_promyvky",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: [])
              ]
            },
            "audit_1": {
              "audit_title_audit_1": [
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_zahalni",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_prepare",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_pidcluchennhja",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_doinnja",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_znjattja",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_pisljadijna",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
              ]
            },
            "audit_2": {
              "audit_title_jakist_vody": [
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_zhorskist",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: [])
              ],
              "audit_title_wash_zasoby": [
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_mijuchi_zasoby",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    withRate: false,
                    withSelector: false,
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_luzhi",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    withRate: false,
                    withSelector: false,
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_kislotni",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    withRate: false,
                    withSelector: false,
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_upakovka",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_vyrobnik",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
              ],
              "audit_title_promyvka_systemy": [
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_first_opoliskuvannja",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_ph_rob_rozchynu",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_circul_promyvka_water",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_gnizda_promyvky_temp",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_gnizda_promyvky_hour",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_gnizda_promyvky_probky",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: []),
                ClientAuditQuestion(id: generate(12),
                    question: "audit_question_gnizda_promyvky_fact",
                    auditId: "",
                    comment: "",
                    rateParam: "",
                    firstRate: "1",
                    secondRate: "",
                    photos: [],
                    photosSrc: [])
              ]
            }
          });

      audit?.data.add(AuditData(title: "audit_address", value: audit?.address ?? "", additional: ""));
      audit?.data.add(AuditData(title: "audit_ustanovka", value: "", additional: ""));
      audit?.data.add(
          AuditData(title: "audit_place_count", value: "", additional: ""));
      audit?.data.add(
          AuditData(title: "audit_cow_count", value: "", additional: ""));
      audit?.data.add(
          AuditData(title: "audit_milk_by_day", value: "", additional: ""));
      audit?.data.add(AuditData(title: "audit_milk", value: "", additional: ""));
      audit?.data.add(
          AuditData(title: "audit_milk_bakterii", value: "", additional: ""));
      audit?.data.add(
          AuditData(title: "audit_milk_somat", value: "", additional: ""));
      audit?.data.add(AuditData(title: "audit_milk_fat", value: "", additional: ""));
      audit?.data.add(
          AuditData(title: "audit_milk_protein", value: "", additional: ""));
      audit?.data.add(
          AuditData(title: "audit_milk_price", value: "", additional: ""));
      audit?.data.add(
          AuditData(title: "audit_inner_number", value: "", additional: ""));

      auditDataWidgets.addAll((audit?.data ?? [])
          .map<Widget>((data) =>
          AuditDataItem(data).marginSymmetricWidget(horizontal: margin5X))
          .toList());
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    page = PageController();
    firstAuditPage = PageController();
    secondAuditPage = PageController();
    thirdAuditPage = PageController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("client_audit".tr()),
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
                    Text(dateFormat.format(audit?.date ?? DateTime.now()), style: styleBoldP14)
                  ]
              ).marginSymmetricWidget(horizontal: margin5X, vertical: blockY * 1),
              PageView(
                  onPageChanged: (newPage) => setState(() => currentPage = newPage),
                  controller: page,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("main_info".tr(), style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY),
                        Wrap(
                          runSpacing: blockY,
                          children: auditDataWidgets
                        )
                      ]
                    ).scrollWidget(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("audit".tr(), style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY),
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
                                  child: Text(item.tr(), style: c == selectedAudit0 ? styleBoldP14.copyWith(color: blueAccent) : styleNormalP14)
                              )
                            ).center();
                          },
                          separatorBuilder: (_, i) => Container(width: 10, height: 1)
                        ).width(width).height(50).marginSymmetricWidget(horizontal: margin5X),
                        PageView(
                          onPageChanged: (p) => setState(() => selectedAudit0 = p),
                          controller: firstAuditPage,
                          children: (audit?.auditQuestions["audit_0"] ?? {}).entries.map<Widget>((e) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                    runSpacing: blockY,
                                    children: e.value.map<Widget>((v) => AuditQuestionItem(v).marginSymmetricWidget(horizontal: margin5X)).toList()
                                )
                              ]
                          ).scrollWidget()).toList()
                        ).expanded()
                      ]
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("audit_1".tr(), style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY),
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
                                    children: e.value.map<Widget>((v) => AuditQuestionItem(v).marginSymmetricWidget(horizontal: margin5X)).toList()
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
                                    children: e.value.map<Widget>((v) => AuditQuestionItem(v).marginSymmetricWidget(horizontal: margin5X)).toList()
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
                        Text("back".tr(), style: styleBoldP14.copyWith(color: blueAccent)),
                        onPressed: () => page?.previousPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn)
                    ) : Container()).expanded(),
                    Container(width: 20),
                    AppElevatedButton(
                        Text(currentPage < 3 ? "next".tr() : "save".tr(), style: styleBoldP14.copyWith(color: Colors.white)),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if(currentPage == 3) {
                            var controller = new StreamController<String>();
                            progressDialogStream(controller.stream);
                            try {
                              controller.add("Перевірка мережі");
                              controller.add("qwe");
                              await NetworkRepository.refreshNetworkStatus();
                              if(BlocProvider.of<NetworkCubit>(context).state != ConnectivityResult.wifi || !(await NetworkRepository.hasNetwork())) {
                                if(Platform.isIOS) {
                                  var r = await Permission.photos.request();
                                  print(r);
                                } else {
                                  var r = await Permission.storage.request();
                                  print(r);
                                }
                                try {
                                  controller.add("Локальне збереження");
                                  await LocalStorage().addAudit(audit!);
                                  controller.add("Локальне збереження завершено");
                                } catch(e) {
                                  controller.add("Помилка локального збереження");
                                  await Future.delayed(Duration(seconds: 10));
                                }
                                try {
                                  FocusScope.of(context).unfocus();
                                  controller.add("Створення pdf файлу");
                                  var file = await createPdf(audit!, false, company: BlocProvider.of<UserCubit>(context).state?.company ?? "", manager: BlocProvider.of<UserCubit>(context).state?.name ?? "");
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(navigatorKey.currentContext!, CupertinoPageRoute(builder: (_) =>  PdfFileViewPage(file, audit!)));
                                } catch(e) {
                                  controller.add("Помилка: $e");
                                  print("$e");
                                  await Future.delayed(Duration(seconds: 10));
                                  Navigator.pop(context);
                                }
                              } else {
                                audit?.isSaved = true;
                                await AuditRepository.addAudit(audit!, s: controller);
                                if(clientPreview?.lastAudit == null || clientPreview!.lastAudit!.millisecondsSinceEpoch < audit!.date.millisecondsSinceEpoch) {
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
                                  FocusScope.of(context).unfocus();
                                  var file = await createPdf(audit!, true, company: BlocProvider.of<UserCubit>(context).state?.company ?? "", manager: BlocProvider.of<UserCubit>(context).state?.name ?? "");
                                  Navigator.pushReplacement(navigatorKey.currentContext!, CupertinoPageRoute(builder: (_) =>  PdfFileViewPage(file, audit!)));
                                } catch(e) {
                                  print("$e");
                                }
                              }
                            } catch(e) {
                              controller.add("Помилка: $e");
                              print("$e");
                              await Future.delayed(Duration(seconds: 10));
                              Navigator.pop(context);
                            }
                            controller.close();
                            // setState(() => isLoading = false);
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
          // if(isLoading)
          //   LoadingHud()
        ]
      )
    );
  }
}