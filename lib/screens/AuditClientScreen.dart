import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

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
  TabController? tab;
  int selectedAudit0 = 0;
  int selectedAudit1 = 0;
  int selectedAudit2 = 0;
  final DateFormat dateFormat = DateFormat('hh:mm dd.MM.yyyy');

  @override
  void didChangeDependencies() {
    args = widget.args;
    clientPreview = args["client"]!;

    audit = ClientAudit("",
    clientPreview!.id,
    BlocProvider.of<UserCubit>(navigatorKey.currentContext!).state?.name ?? "",
    "place",
    DateTime.now().toString(),
    clientPreview!.address!,
    false,
    <AuditData>[], {
      "audit_0": {
        "vacuum_system": [
          ClientAuditQuestion(question: "vacuum_nasos", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "vacuum_glushnyk", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "vacuum_reciever", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "vacuumetr", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "vacuum_reguljator", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "sanitarna_camera", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: [])
        ],
        "milk_system": [
          ClientAuditQuestion(question: "molokopryjmach", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "milk_nasos", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "milk_filter", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "molokoprovid_vid", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "molokoprovody_do", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: [])
        ],
        "ohlad_system": [
          ClientAuditQuestion(question: "tanker", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "compresorny_agregaty", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "promyvka_na_jakosty_zberigannja", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: [])
        ],
        "doilny_aparaty": [
          ClientAuditQuestion(question: "colector", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "stakany", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "polsatory", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "diykova_guma", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "large_molk_shlangy", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "pulsator", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: [])
        ],
        "vykachka_moloka": [
          ClientAuditQuestion(question: "milk_nasos", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "shlang_vykachly", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: [])
        ],
        "system_promyvky": [
          ClientAuditQuestion(question: "bak_avtomata_promyvky", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "gnizda_promyvky", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: [])
        ]
      },
      "audit_1": {
        "audit_1": [
          ClientAuditQuestion(question: "zahalni", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "prepare", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "pidcluchennhja", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "doinnja", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "znjattja", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "pisljadijna", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
        ]
      },
      "audit_2": {
        "jakist_vody": [
          ClientAuditQuestion(question: "zhorskist", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: [])
        ],
        "wash_zasoby": [
          ClientAuditQuestion(question: "mijuchi_zasoby", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", withRate: false, withSelector: false, photos: [], photosSrc: []),
          ClientAuditQuestion(question: "luzhi", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", withRate: false, withSelector: false, photos: [], photosSrc: []),
          ClientAuditQuestion(question: "kislotni", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", withRate: false, withSelector: false, photos: [], photosSrc: []),
          ClientAuditQuestion(question: "upakovka", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "vyrobnik", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
        ],
        "promyvka_systemy": [
          ClientAuditQuestion(question: "first_opoliskuvannja", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "ph_rob_rozchynu", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "circul_promyvka_water", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "gnizda_promyvky_temp", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "gnizda_promyvky_hour", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "gnizda_promyvky_probky", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: []),
          ClientAuditQuestion(question: "gnizda_promyvky_fact", auditId: "", comment: "", rateParam: "", firstRate: "1", secondRate: "", photos: [], photosSrc: [])
        ]
      }
    });

    audit?.data.add(AuditData(title: "address", value: "", additional: ""));
    audit?.data.add(AuditData(title: "ustanovka", value: "", additional: ""));
    audit?.data.add(AuditData(title: "place_count", value: "2", additional: ""));
    audit?.data.add(AuditData(title: "cow_count", value: "1", additional: ""));
    audit?.data.add(AuditData(title: "milk_by_day", value: "12", additional: ""));
    audit?.data.add(AuditData(title: "milk", value: "", additional: ""));
    audit?.data.add(AuditData(title: "milk_bakterii", value: "", additional: ""));
    audit?.data.add(AuditData(title: "milk_somat", value: "", additional: ""));
    audit?.data.add(AuditData(title: "milk_fat", value: "", additional: ""));
    audit?.data.add(AuditData(title: "milk_protein", value: "", additional: ""));
    audit?.data.add(AuditData(title: "milk_price", value: "", additional: ""));
    audit?.data.add(AuditData(title: "inner_number", value: "", additional: ""));

    super.didChangeDependencies();
  }

  @override
  void initState() {
    page = PageController();
    firstAuditPage = PageController();
    secondAuditPage = PageController();
    thirdAuditPage = PageController();
    tab = TabController(length: audit?.auditQuestions.length ?? 6, vsync: this);
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
    print(audit?.date);
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
                    Text(dateFormat.format(DateTime.tryParse(audit?.date ?? "") ?? DateTime.now()), style: styleBoldP14)
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
                        Text("main_info", style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY),
                        Wrap(
                          runSpacing: blockY,
                          children: (audit?.data ?? []).map<Widget>((data) => AuditDataItem(data).marginSymmetricWidget(horizontal: margin5X)).toList()
                        )
                      ]
                    ).scrollWidget(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("audit", style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY),
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
                        Text("back", style: styleBoldP14.copyWith(color: blueAccent)),
                        onPressed: () => page?.previousPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn)
                    ) : Container()).expanded(),
                    Container(width: 20),
                    AppElevatedButton(
                        Text(currentPage < 3 ? "next" : "save", style: styleBoldP14.copyWith(color: Colors.white)),
                        onPressed: () async {
                          if(currentPage == 3) {
                            if(isLoading) return;
                            setState(() => isLoading = true);

                            try {
                              await NetworkRepository.refreshNetworkStatus();
                              if(BlocProvider.of<NetworkCubit>(context).state == ConnectivityResult.none || !(await NetworkRepository.hasNetwork())) {
                              if(Platform.isIOS) {
                                var r = await Permission.photos.request();
                                print(r);
                              } else {
                                var r = await Permission.storage.request();
                                print(r);
                              }
                                await LocalStorage().addAudit(audit!);
                                try {
                                  await createPdf(audit!, false);
                                } catch(e) {
                                  print("$e");
                                }
                              } else {
                                audit?.isSaved = true;
                                await AuditRepository.addAudit(audit!);
                                try {
                                  await createPdf(audit!, true);
                                } catch(e) {
                                  print("$e");
                                }
                              }
                            } catch(e) {
                              print("$e");
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