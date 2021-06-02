import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:easy_localization/easy_localization.dart';

class ReviewClientScreen extends StatefulWidget {
  final Map<String, dynamic>? args;
  ReviewClientScreen(this.args);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReviewClientScreen> {
  Map<String, dynamic> args = {};
  bool isLoading = false;
  DateTime? reviewDate;
  ClientFull? client;
  TextEditingController? workedCow, cowAvgByDay, milkByDay, tovarnistMilk,
      milkFat, milkProtein, zakupMilkPrice, invalidCow, mastit,
      kopyta, endometryt, bacteryZabrudMilk, bacterySomatMilk;
  bool metaSell = false, metaProduction = false, getQuestion = false;
  List<ClientAdditionalQuestion> questions = [];

  @override
  void didChangeDependencies() {
    args = widget.args ?? {};
    client = args["client"];
    reviewDate = args["date"];
    reviewDate = DateTime(reviewDate!.year, reviewDate!.month, reviewDate!.day, 0, 0, 0, 0, 0);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    workedCow = TextEditingController();
    cowAvgByDay = TextEditingController();
    milkByDay = TextEditingController();
    tovarnistMilk = TextEditingController();
    milkFat = TextEditingController();
    milkProtein = TextEditingController();
    zakupMilkPrice = TextEditingController();
    invalidCow = TextEditingController();
    mastit = TextEditingController();
    kopyta = TextEditingController();
    endometryt = TextEditingController();
    bacteryZabrudMilk = TextEditingController();
    bacterySomatMilk = TextEditingController();
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
                    Text("review_for".tr(args: [DateFormat("dd.MM.yy").format(reviewDate ?? DateTime.now())]),
                      style: styleBoldP12.copyWith(color: greyMedium))
                  ]
              ).marginSymmetricWidget(vertical: margin5Y / 2, horizontal: margin5X),
              Text("general".tr(), style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X).marginWidget(bottom: blockY * 1.5),
              Wrap(
                runSpacing: blockY,
                children: [
                  CustomRoundedTextField(workedCow, hint: "review_workedCow".tr(), helperText: "review_workedCow".tr()),
                  CustomRoundedTextField(cowAvgByDay, hint: "review_cowAvgByDay".tr(), helperText: "review_cowAvgByDay".tr()),
                  CustomRoundedTextField(milkByDay, hint: "review_milkByDay".tr(), helperText: "review_milkByDay".tr()),
                  CustomRoundedTextField(tovarnistMilk, hint: "review_tovarnistMilk".tr(), helperText: "review_tovarnistMilk".tr()),
                  CustomRoundedTextField(milkFat, hint: "review_milkFat".tr(), helperText: "review_milkFat".tr()),
                  CustomRoundedTextField(milkProtein, hint: "review_milkProtein".tr(), helperText: "review_milkProtein".tr()),
                  CustomRoundedTextField(zakupMilkPrice, hint: "review_zakupMilkPrice".tr().tr(), helperText: "review_zakupMilkPrice".tr()),
                  CustomRoundedTextField(invalidCow, hint: "review_invalidCow".tr(), helperText: "review_invalidCow".tr()),
                  CustomRoundedTextField(mastit, hint: "review_mastit".tr(), helperText: "review_mastit".tr()),
                  CustomRoundedTextField(kopyta, hint: "review_kopyta".tr(), helperText: "review_kopyta".tr()),
                  CustomRoundedTextField(endometryt, hint: "review_endometryt".tr(), helperText: "review_endometryt".tr()),
                  CustomRoundedTextField(bacteryZabrudMilk, hint: "review_bacteryZabrudMilk".tr(), helperText: "review_bacteryZabrudMilk".tr()),
                  CustomRoundedTextField(bacterySomatMilk, hint: "review_bacterySomatMilk".tr(), helperText: "review_bacterySomatMilk".tr())
                ]
              ).marginSymmetricWidget(horizontal: margin5X),
              Wrap(
                runSpacing: blockY,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("review_metaSell".tr(), style: styleBoldP14.copyWith(fontFamily: "Arial")),
                      Switch(value: metaSell, onChanged: (v) => setState(() => metaSell = v), activeTrackColor: blueAccent.withOpacity(.3), activeColor: blueDark)
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("review_metaProduction".tr(), style: styleBoldP14.copyWith(fontFamily: "Arial")),
                      Switch(value: metaProduction, onChanged: (v) => setState(() => metaProduction = v), activeTrackColor: blueAccent.withOpacity(.3), activeColor: blueDark)
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("review_getQuestion".tr(), style: styleBoldP14.copyWith(fontFamily: "Arial")),
                      Switch(value: getQuestion, onChanged: (v) => setState(() => getQuestion = v), activeTrackColor: blueAccent.withOpacity(.3), activeColor: blueDark)
                    ]
                  ),
                ]
              ).marginSymmetricWidget(horizontal: margin5X),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("review_questions".tr(), style: styleBoldP20),
                  Icon(Icons.add_circle_outline_rounded, color: blueAccent).onClick(() =>
                      setState(() => questions.add(ClientAdditionalQuestion.empty())))
                ]
              ).marginSymmetricWidget(horizontal: margin5X, vertical: blockY * 1.5),
              ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: questions.length,
                  itemBuilder: (_, i) => Dismissible(
                      key: Key(questions[i].id),
                      child: QuestionItem(questions[i]).marginSymmetricWidget(horizontal: margin5X),
                      onDismissed: (direction) => setState(() => questions.removeAt(i))
                  ),
                  separatorBuilder: (_, i) => Container(height: blockY)
              ),
              AppElevatedButton(Text("add".tr()), onPressed: () async {
                if(isLoading) return;
                setState(() => isLoading = true);
                try {
                  var review = ClientReview(
                      user: BlocProvider.of<UserCubit>(navigatorKey.currentContext!).state?.name ?? "User",
                      date: reviewDate,
                      workedCow: workedCow?.text ?? "",
                      cowAvgByDay: cowAvgByDay?.text ?? "",
                      milkByDay: milkByDay?.text ?? "",
                      tovarnistMilk: tovarnistMilk?.text ?? "",
                      milkFat: milkFat?.text ?? "",
                      milkProtein: milkProtein?.text ?? "",
                      zakupMilkPrice: zakupMilkPrice?.text ?? "",
                      invalidCow: invalidCow?.text ?? "",
                      mastit: mastit?.text ?? "",
                      kopyta: kopyta?.text ?? "",
                      endometryt: endometryt?.text ?? "",
                      bacteryZabrudMilk: bacteryZabrudMilk?.text ?? "",
                      bacterySomatMilk: bacterySomatMilk?.text ?? "",
                      metaSell: metaSell,
                      metaProduction: metaProduction,
                      getQuestion: getQuestion,
                      questions: questions,
                      createdAt: DateTime.now().millisecondsSinceEpoch
                  );

                  await NetworkRepository.refreshNetworkStatus();
                  if(BlocProvider.of<NetworkCubit>(context).state == ConnectivityResult.none || !(await NetworkRepository.hasNetwork())) {
                    review.id = generateCachedId();
                    await LocalStorage().addReview(review, client!);
                  } else {
                    await ReviewRepository.addReview(review, client!.id);
                  }
                  setState(() => isLoading = false);
                  Navigator.pop(context, review);
                } catch(e) {
                  print("e) $e");
                }
              }).width(width).marginSymmetricWidget(vertical: margin5Y / 2, horizontal: margin5X)
            ]
          ).scrollWidget(),
          if(isLoading)
            LoadingHud()
        ]
      )
    );
  }
}