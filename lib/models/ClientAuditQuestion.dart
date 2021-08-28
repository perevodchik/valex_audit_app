import 'dart:io';

class ClientAuditQuestion {
  String id;
  String? auditId;
  String audit;
  String question;
  String questionTitle;
  String comment;
  String rateParam;
  String firstRate;
  String secondRate;
  bool withRate;
  bool withSelector;
  bool isChangePhoto;
  List<File>? photos;
  List<String>? photosSrc;

  ClientAuditQuestion({
        this.id = "",
        this.auditId,
        this.audit = "",
        this.question = "",
        this.questionTitle = "",
        this.comment = "",
        this.rateParam = "",
        this.firstRate = "",
        this.secondRate = "",
        this.withRate = true,
        this.withSelector = true,
        this.isChangePhoto = false,
        this.photos,
        this.photosSrc});

  factory ClientAuditQuestion.fromJson(Map<String, dynamic> data) {
    var photoSrc = <String> [];
    if(data["photosSrc"] is List)
      photoSrc = data["photosSrc"].map<String>((i) => "$i").toList();
    else if(data["photosSrc"] is String)
      photoSrc.addAll(data["photosSrc"].split(","));
    photoSrc.removeWhere((el) => el.isEmpty);

    return ClientAuditQuestion(
        id: data["id"] ?? "",
        auditId: data["auditId"] ?? "",
        audit: data["audit"] ?? "",
        question: data["question"] ?? "",
        questionTitle: data["questionTitle"] ?? "",
        comment: data["comment"] ?? "",
        firstRate: "${data["firstRate"] ?? ""}",
        secondRate: "${data["secondRate"] ?? ""}",
        withRate: data["withRate"] is int ? data["withRate"] == 1 : data["withRate"] ?? true,
        withSelector: data["withSelector"] is int ? data["withSelector"] == 1 : data["withSelector"] ?? true,
        rateParam: data["rateParam"] ?? "",
        photosSrc: photoSrc
    );
  }

  Map<String, dynamic> toJson() => {
    "auditId": auditId,
    "audit": audit,
    "question": question,
    "questionTitle": questionTitle,
    "comment": comment,
    "rateParam": rateParam,
    "firstRate": firstRate,
    "secondRate": secondRate,
    "withRate": withRate,
    "withSelector": withSelector,
    "photosSrc": photosSrc
  };
  
}