import '../All.dart';

class ClientReview {
  String id;
  String clientId;
  String user;
  String workedCow;
  String cowAvgByDay;
  String milkByDay;
  String tovarnistMilk;
  String milkFat;
  String milkProtein;
  String zakupMilkPrice;
  String invalidCow;
  String mastit;
  String kopyta;
  String endometryt;
  String bacteryZabrudMilk;
  String bacterySomatMilk;
  DateTime? date;
  int createdAt;
  bool metaSell;
  bool metaProduction;
  bool getQuestion;
  List<ClientAdditionalQuestion> questions;

  ClientReview(
      {this.id = "",
        this.clientId = "",
        this.user = "",
        this.date,
        this.workedCow = "",
        this.cowAvgByDay = "",
        this.milkByDay = "",
        this.tovarnistMilk = "",
        this.milkFat = "",
        this.milkProtein = "",
        this.zakupMilkPrice = "",
        this.invalidCow = "",
        this.mastit = "",
        this.kopyta = "",
        this.endometryt = "",
        this.bacteryZabrudMilk = "",
        this.bacterySomatMilk = "",
        this.createdAt = 0,
        this.metaSell = false,
        this.metaProduction = false,
        this.getQuestion = false,
        this.questions = const <ClientAdditionalQuestion>[]});

  factory ClientReview.fromJson(Map<String, dynamic> data) => ClientReview(
      id: data["id"] ?? "",
      clientId: data["client_id"] ?? "",
      user: data["user"] ?? "",
      date: DateTime.fromMillisecondsSinceEpoch(data["date"] is String ? DateTime.tryParse(data["date"])?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch : data["date"]?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch),
      workedCow: data["workedCow"] ?? "",
      cowAvgByDay: data["cowAvgByDay"] ?? "",
      milkByDay: data["milkByDay"] ?? "",
      tovarnistMilk: data["tovarnistMilk"] ?? "",
      milkFat: data["milkFat"] ?? "",
      milkProtein: data["milkProtein"] ?? "",
      zakupMilkPrice: data["zakupMilkPrice"] ?? "",
      invalidCow: data["invalidCow"] ?? "",
      mastit: data["mastit"] ?? "",
      kopyta: data["kopyta"] ?? "",
      endometryt: data["endometryt"] ?? "",
      bacteryZabrudMilk: data["bacteryZabrudMilk"] ?? "",
      bacterySomatMilk: data["bacterySomatMilk"] ?? "",
      createdAt: data["createdAt"] ?? 0,
      metaSell: data["metaSell"] is int ? data["metaSell"] == 1 : data["metaSell"] ?? false,
      metaProduction: data["metaProduction"] is int ? data["metaProduction"] == 1 : data["metaProduction"] ?? false,
      getQuestion: data["getQuestion"] is int ? data["getQuestion"] == 1 : data["getQuestion"] ?? false,
      questions: data["questions"] != null ? (data["questions"] ?? []).map<ClientAdditionalQuestion>((data) => ClientAdditionalQuestion.fromJson(data)).toList() : []
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "date": date,
    "workedCow": workedCow,
    "cowAvgByDay": cowAvgByDay,
    "milkByDay": milkByDay,
    "tovarnistMilk": tovarnistMilk,
    "milkFat": milkFat,
    "milkProtein": milkProtein,
    "zakupMilkPrice": zakupMilkPrice,
    "invalidCow": invalidCow,
    "mastit": mastit,
    "kopyta": kopyta,
    "endometryt": endometryt,
    "bacteryZabrudMilk": bacteryZabrudMilk,
    "bacterySomatMilk": bacterySomatMilk,
    "createdAt": createdAt,
    "metaSell": metaSell,
    "metaProduction": metaProduction,
    "getQuestion": getQuestion,
    "questions": questions.map<Map<String, dynamic>>((q) => q.toJson()).toList()
  };

  ClientReview copyWith({id, user, date, workedCow, cowAvgByDay, milkByDay,
    tovarnistMilk, milkFat, milkProtein, zakupMilkPrice,
    invalidCow, mastit, kopyta, endometryt,
    bacteryZabrudMilk, bacterySomatMilk, createdAt, metaSell, metaProduction,
    getQuestion, questions}) => ClientReview(
      id: id ?? this.id,
      user: user ?? this.user,
      date: date ?? this.date,
      workedCow: workedCow ?? this.workedCow,
      cowAvgByDay: cowAvgByDay ?? this.cowAvgByDay,
      milkByDay: milkByDay ?? this.milkByDay,
      tovarnistMilk: tovarnistMilk ?? this.tovarnistMilk,
      milkFat: milkFat ?? this.milkFat,
      milkProtein: milkProtein ?? this.milkProtein,
      zakupMilkPrice: zakupMilkPrice ?? this.zakupMilkPrice,
      invalidCow: invalidCow ?? this.invalidCow,
      mastit: mastit ?? this.mastit,
      kopyta: kopyta ?? this.kopyta,
      endometryt: endometryt ?? this.endometryt,
      bacteryZabrudMilk: bacteryZabrudMilk ?? this.bacteryZabrudMilk,
      bacterySomatMilk: bacterySomatMilk ?? this.bacterySomatMilk,
      createdAt: createdAt ?? this.createdAt,
      metaSell: metaSell ?? this.metaSell,
      metaProduction: metaProduction ?? this.metaProduction,
      getQuestion: getQuestion ?? this.getQuestion,
      questions: questions ?? this.questions
  );

  @override
  String toString() {
    return "{id: $id, user: $user, date: $date, workedCow: $workedCow, cowAvgByDay: $cowAvgByDay, milkByDay: $milkByDay, tovarnistMilk: $tovarnistMilk, milkFat: $milkFat, milkProtein: $milkProtein, zakupMilkPrice: $zakupMilkPrice, invalidCow: $invalidCow, mastit: $mastit, kopyta: $kopyta, endometryt: $endometryt, bacteryZabrudMilk: $bacteryZabrudMilk, bacterySomatMilk: $bacterySomatMilk, metaSell: $metaSell, metaProduction: $metaProduction, getQuestion: $getQuestion, questions: $questions}";
  }
}