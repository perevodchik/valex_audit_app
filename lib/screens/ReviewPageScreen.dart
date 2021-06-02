import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:easy_localization/easy_localization.dart';

class ReviewPageScreen extends StatefulWidget {
  final Map<String, dynamic>? args;
  ReviewPageScreen(this.args);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReviewPageScreen> {
  Map<String, dynamic> args = {};
  ClientFull? client;
  ClientReview? review;
  DateTime? reviewDate;
  TextEditingController? workedCow, cowAvgByDay, milkByDay, tovarnistMilk,
      milkFat, milkProtein, zakupMilkPrice, invalidCow, mastit,
      kopyta, endometryt, bacteryZabrudMilk, bacterySomatMilk;
  bool metaSell = false, metaProduction = false, getQuestion = false;
  List<ClientAdditionalQuestion> questions = [];

  @override
  void didChangeDependencies() {
    args = widget.args ?? {};
    client = args["client"];
    review = args["review"];
    reviewDate = args["date"];
    super.didChangeDependencies();
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      workedCow = TextEditingController(text: review?.workedCow ?? "");
      cowAvgByDay = TextEditingController(text: review?.cowAvgByDay ?? "");
      milkByDay = TextEditingController(text: review?.milkByDay ?? "");
      tovarnistMilk = TextEditingController(text: review?.tovarnistMilk ?? "");
      milkFat = TextEditingController(text: review?.milkFat ?? "");
      milkProtein = TextEditingController(text: review?.milkProtein ?? "");
      zakupMilkPrice = TextEditingController(text: review?.zakupMilkPrice ?? "");
      invalidCow = TextEditingController(text: review?.invalidCow ?? "");
      mastit = TextEditingController(text: review?.mastit ?? "");
      kopyta = TextEditingController(text: review?.kopyta ?? "");
      endometryt = TextEditingController(text: review?.endometryt ?? "");
      bacteryZabrudMilk = TextEditingController(text: review?.bacteryZabrudMilk ?? "");
      bacterySomatMilk = TextEditingController(text: review?.bacterySomatMilk ?? "");
      metaSell = review?.metaSell ?? false;
      metaProduction = review?.metaProduction ?? false;
      getQuestion = review?.getQuestion ?? false;
      questions.addAll(review?.questions ?? <ClientAdditionalQuestion> []);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    workedCow?.dispose();
    cowAvgByDay?.dispose();
    milkByDay?.dispose();
    tovarnistMilk?.dispose();
    milkFat?.dispose();
    milkProtein?.dispose();
    zakupMilkPrice?.dispose();
    invalidCow?.dispose();
    mastit?.dispose();
    kopyta?.dispose();
    endometryt?.dispose();
    bacteryZabrudMilk?.dispose();
    bacterySomatMilk?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("review_client".tr()),
            elevation: 0,
            backgroundColor: blueAccent,
            brightness: Brightness.dark
        ),
        body: Stack(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(client?.name ?? "", style: styleBoldP20.copyWith(color: blueDark)).marginWidget(bottom: blockY),
                          Text(review?.user ?? "", style: styleBoldP14.copyWith(color: blueDark)).marginWidget(bottom: blockY),
                          Text("review_for".tr(args: [DateFormat("dd.MM.yy").format(reviewDate ?? DateTime.now())]),
                              style: styleBoldP12)
                        ]
                    ).marginSymmetricWidget(vertical: margin5Y / 2, horizontal: margin5X),
                    Text("general".tr(), style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X).marginWidget(bottom: blockY * 1.5),
                    Wrap(
                        runSpacing: blockY,
                        children: [
                          CustomRoundedTextField(workedCow, hint: "review_workedCow".tr(), helperText: "review_workedCow".tr(), isEnable: false),
                          CustomRoundedTextField(cowAvgByDay, hint: "review_cowAvgByDay".tr().tr(), helperText: "review_cowAvgByDay".tr(), isEnable: false),
                          CustomRoundedTextField(milkByDay, hint: "review_milkByDay".tr(), helperText: "review_milkByDay".tr(), isEnable: false),
                          CustomRoundedTextField(tovarnistMilk, hint: "review_tovarnistMilk".tr(), helperText: "review_tovarnistMilk".tr(), isEnable: false),
                          CustomRoundedTextField(milkFat, hint: "review_milkFat".tr(), helperText: "review_milkFat".tr(), isEnable: false),
                          CustomRoundedTextField(milkProtein, hint: "review_milkProtein".tr(), helperText: "review_milkProtein".tr(), isEnable: false),
                          CustomRoundedTextField(zakupMilkPrice, hint: "review_zakupMilkPrice".tr(), helperText: "review_zakupMilkPrice".tr(), isEnable: false),
                          CustomRoundedTextField(invalidCow, hint: "review_invalidCow".tr(), helperText: "review_invalidCow".tr(), isEnable: false),
                          CustomRoundedTextField(mastit, hint: "review_mastit".tr(), helperText: "review_mastit".tr(), isEnable: false),
                          CustomRoundedTextField(kopyta, hint: "review_kopyta".tr(), helperText: "review_kopyta".tr(), isEnable: false),
                          CustomRoundedTextField(endometryt, hint: "review_endometryt".tr(), helperText: "review_endometryt".tr(), isEnable: false),
                          CustomRoundedTextField(bacteryZabrudMilk, hint: "review_bacteryZabrudMilk".tr(), helperText: "review_bacteryZabrudMilk".tr(), isEnable: false),
                          CustomRoundedTextField(bacterySomatMilk, hint: "review_bacterySomatMilk".tr(), helperText: "review_bacterySomatMilk".tr(), isEnable: false)
                        ]
                    ).marginSymmetricWidget(horizontal: margin5X),
                    Wrap(
                        runSpacing: blockY,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("review_metaSell".tr(), style: styleBoldP14),
                                Switch(value: review?.metaSell ?? false, onChanged: null, inactiveTrackColor: blueAccent.withOpacity(.3), inactiveThumbColor: blueDark)
                              ]
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("review_metaProduction".tr(), style: styleBoldP14),
                                Switch(value: review?.metaProduction ?? false, onChanged: null, inactiveTrackColor: blueAccent.withOpacity(.3), inactiveThumbColor: blueDark)
                              ]
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("review_getQuestion".tr(), style: styleBoldP14),
                                Switch(value: review?.getQuestion ?? false, onChanged: null, inactiveTrackColor: blueAccent.withOpacity(.3), inactiveThumbColor: blueDark)
                              ]
                          )
                        ]
                    ).marginSymmetricWidget(horizontal: margin5X),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("review_questions".tr(), style: styleBoldP20),
                        ]
                    ).marginSymmetricWidget(horizontal: margin5X).marginWidget(bottom: blockY * 1.5),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: questions.length,
                        itemBuilder: (_, i) => Dismissible(
                            key: Key(questions[i].id),
                            child: QuestionItem(questions[i], isEditable: false).marginSymmetricWidget(horizontal: margin5X),
                            onDismissed: (direction) => setState(() => questions.removeAt(i))
                        ),
                        separatorBuilder: (_, i) => Container(height: blockY)
                    ).marginWidget(bottom: blockY * 2.5)
                  ]
              ).scrollWidget()
            ]
        )
    );
  }
}