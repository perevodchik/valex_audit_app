import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valex_agro_audit_app/All.dart';

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
                          Text(review?.user ?? "", style: styleBoldP14.copyWith(color: blueDark)).marginWidget(bottom: blockY),
                          Text("review_for_${DateFormat("dd.MM.yy").format(reviewDate ?? DateTime.now())}",
                              style: styleBoldP12)
                        ]
                    ).marginSymmetricWidget(vertical: margin5Y / 2, horizontal: margin5X),
                    Text("general", style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X).marginWidget(bottom: blockY * 1.5),
                    Wrap(
                        runSpacing: blockY,
                        children: [
                          CustomRoundedTextField(workedCow, hint: "workedCow", helperText: "workedCow", isEnable: false),
                          CustomRoundedTextField(cowAvgByDay, hint: "cowAvgByDay", helperText: "cowAvgByDay", isEnable: false),
                          CustomRoundedTextField(milkByDay, hint: "milkByDay", helperText: "milkByDay", isEnable: false),
                          CustomRoundedTextField(tovarnistMilk, hint: "tovarnistMilk", helperText: "tovarnistMilk", isEnable: false),
                          CustomRoundedTextField(milkFat, hint: "milkFat", helperText: "milkFat", isEnable: false),
                          CustomRoundedTextField(milkProtein, hint: "milkProtein", helperText: "milkProtein", isEnable: false),
                          CustomRoundedTextField(zakupMilkPrice, hint: "zakupMilkPrice", helperText: "zakupMilkPrice", isEnable: false),
                          CustomRoundedTextField(invalidCow, hint: "invalidCow", helperText: "invalidCow", isEnable: false),
                          CustomRoundedTextField(mastit, hint: "mastit", helperText: "mastit", isEnable: false),
                          CustomRoundedTextField(kopyta, hint: "kopyta", helperText: "kopyta", isEnable: false),
                          CustomRoundedTextField(endometryt, hint: "endometryt", helperText: "endometryt", isEnable: false),
                          CustomRoundedTextField(bacteryZabrudMilk, hint: "bacteryZabrudMilk", helperText: "bacteryZabrudMilk", isEnable: false),
                          CustomRoundedTextField(bacterySomatMilk, hint: "bacterySomatMilk", helperText: "bacterySomatMilk", isEnable: false)
                        ]
                    ).marginSymmetricWidget(horizontal: margin5X),
                    Wrap(
                        runSpacing: blockY,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("metaSell", style: styleBoldP14),
                                Switch(value: review?.metaSell ?? false, onChanged: null, inactiveTrackColor: blueAccent.withOpacity(.3), inactiveThumbColor: blueDark)
                              ]
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("metaProduction", style: styleBoldP14),
                                Switch(value: review?.metaProduction ?? false, onChanged: null, inactiveTrackColor: blueAccent.withOpacity(.3), inactiveThumbColor: blueDark)
                              ]
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("getQuestion", style: styleBoldP14),
                                Switch(value: review?.getQuestion ?? false, onChanged: null, inactiveTrackColor: blueAccent.withOpacity(.3), inactiveThumbColor: blueDark)
                              ]
                          )
                        ]
                    ).marginSymmetricWidget(horizontal: margin5X),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("questions", style: styleBoldP20),
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