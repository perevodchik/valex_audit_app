import '../../All.dart';

class AuditQuestionStorage {

  Future<Map<String, Map<String, List<ClientAuditQuestion>>>> getAuditQuestions(String auditId) async {
    var questions = <String, Map<String, List<ClientAuditQuestion>>> {};
    print("SELECT * FROM audit_question WHERE auditId = '$auditId';");
    var r = await AppDatabase.database!.rawQuery("SELECT * FROM audit_question WHERE auditId = '$auditId';");
    print(r.length);
    for(var dataSet in r) {
      var audit = "${dataSet["audit"]}";
      var question = "${dataSet["questionTitle"]}";
      if(questions[audit] == null)
        questions[audit] = <String, List<ClientAuditQuestion>> {};
      if(questions[audit]![question] == null)
        questions[audit]![question] = <ClientAuditQuestion>[];
      var q = ClientAuditQuestion.fromJson(dataSet);
      questions[audit]![question]?.add(q);
      print(q);
    }
    print(questions);
    return questions;
  }

  Future<ClientAuditQuestion> addAuditQuestion(ClientAuditQuestion question) async {
    var id = generateCachedId();
    question.id = id;
    await AppDatabase.database!.insert("audit_question", {
      "id": id,
      "auditId": question.auditId,
      "audit": question.audit,
      "question": question.question,
      "questionTitle": question.questionTitle,
      "comment": question.comment,
      "rateParam": question.rateParam,
      "firstRate": question.firstRate,
      "secondRate": question.secondRate,
      "withRate": question.withRate ? 1 : 0,
      "withSelector": question.withSelector ? 1 : 0,
      "photosSrc": (question.photosSrc ?? []).join(",")
    });
    if((question.photosSrc ?? []).isNotEmpty)
    print("$addAuditQuestion ${
        {
          "id": id,
          "auditId": question.auditId,
          "audit": question.audit,
          "question": question.question,
          "questionTitle": question.questionTitle,
          "comment": question.comment,
          "rateParam": question.rateParam,
          "firstRate": question.firstRate,
          "secondRate": question.secondRate,
          "withRate": question.withRate ? 1 : 0,
          "withSelector": question.withSelector ? 1 : 0,
          "photos": (question.photosSrc ?? []).join(",")
        }
    }");
    return question;
  }

  Future<void> deleteAuditQuestion(String auditId) async {
    await AppDatabase.database!.delete("audit_question", where: "auditId = ?", whereArgs: [auditId]);
  }

}