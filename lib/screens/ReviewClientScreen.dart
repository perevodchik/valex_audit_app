import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:valex_agro_audit_app/All.dart';

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
        title: Text("client_review"),
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
                    Text("review_for_${DateFormat("dd.MM.yy").format(reviewDate ?? DateTime.now())}",
                      style: styleBoldP12.copyWith(color: greyMedium))
                  ]
              ).marginSymmetricWidget(vertical: margin5Y / 2, horizontal: margin5X),
              Text("general", style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X).marginWidget(bottom: blockY * 1.5),
              Wrap(
                runSpacing: blockY,
                children: [
                  CustomRoundedTextField(workedCow, hint: "workedCow", helperText: "workedCow"),
                  CustomRoundedTextField(cowAvgByDay, hint: "cowAvgByDay", helperText: "cowAvgByDay"),
                  CustomRoundedTextField(milkByDay, hint: "milkByDay", helperText: "milkByDay"),
                  CustomRoundedTextField(tovarnistMilk, hint: "tovarnistMilk", helperText: "tovarnistMilk"),
                  CustomRoundedTextField(milkFat, hint: "milkFat", helperText: "milkFat"),
                  CustomRoundedTextField(milkProtein, hint: "milkProtein", helperText: "milkProtein"),
                  CustomRoundedTextField(zakupMilkPrice, hint: "zakupMilkPrice", helperText: "zakupMilkPrice"),
                  CustomRoundedTextField(invalidCow, hint: "invalidCow", helperText: "invalidCow"),
                  CustomRoundedTextField(mastit, hint: "mastit", helperText: "mastit"),
                  CustomRoundedTextField(kopyta, hint: "kopyta", helperText: "kopyta"),
                  CustomRoundedTextField(endometryt, hint: "endometryt", helperText: "endometryt"),
                  CustomRoundedTextField(bacteryZabrudMilk, hint: "bacteryZabrudMilk", helperText: "bacteryZabrudMilk"),
                  CustomRoundedTextField(bacterySomatMilk, hint: "bacterySomatMilk", helperText: "bacterySomatMilk")
                ]
              ).marginSymmetricWidget(horizontal: margin5X),
              Wrap(
                runSpacing: blockY,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("metaSell", style: styleBoldP14.copyWith(fontFamily: "Arial")),
                      Switch(value: metaSell, onChanged: (v) => setState(() => metaSell = v), activeTrackColor: blueAccent.withOpacity(.3), activeColor: blueDark)
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("metaProduction", style: styleBoldP14.copyWith(fontFamily: "Arial")),
                      Switch(value: metaProduction, onChanged: (v) => setState(() => metaProduction = v), activeTrackColor: blueAccent.withOpacity(.3), activeColor: blueDark)
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("getQuestion", style: styleBoldP14.copyWith(fontFamily: "Arial")),
                      Switch(value: getQuestion, onChanged: (v) => setState(() => getQuestion = v), activeTrackColor: blueAccent.withOpacity(.3), activeColor: blueDark)
                    ]
                  ),
                ]
              ).marginSymmetricWidget(horizontal: margin5X),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("questions", style: styleBoldP20),
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
              AppElevatedButton(Text("add"), onPressed: () async {
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