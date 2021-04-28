import 'package:firebase_storage/firebase_storage.dart';

import '../All.dart';

class ClientAudit {
  String id;
  String clientId;
  String user;
  String place;
  String date;
  String address;
  bool isSaved;
  List<AuditData> data;
  Map<String, Map<String, List<ClientAuditQuestion>>> auditQuestions;

  bool get isCached => id.length > 30 && id.contains("_");
  String get firebaseId => isCached ? id.split("_")[0] : id;

  ClientAudit(this.id, this.clientId, this.user, this.place, this.date,
      this.address, this.isSaved, this.data, this.auditQuestions);

  Map<String, dynamic> toJson() {
    var auditQuestions = {};
    for(var q in this.auditQuestions.entries) {
      auditQuestions[q.key] = <Map<String, dynamic>>[];
      for(var qq in q.value.entries) {
        for(var question in qq.value) {
          question.questionTitle = qq.key;
          auditQuestions[q.key].add(question.toJson());
        }
      }
    }
    return {
      "clientId": clientId,
      "user": user,
      "place": place,
      "date": date,
      "address": address,
      "isSaved": isSaved,
      "data": data.map<Map<String, dynamic>>((d) => d.toJson()).toList(),
      "auditQuestions": auditQuestions
    };
  }

  Map<String, dynamic> toJsonShort() {
    return {
      "clientId": clientId,
      "date": date,
      "place": place,
      "user": user,
      "address": address,
      "isSaved": isSaved
    };
  }

  factory ClientAudit.fromJson(Map<String, dynamic> data) {
    var auditData = <AuditData> [];
    var questions = <String, Map<String, List<ClientAuditQuestion>>> {};
    if(data.containsKey("data")) {
      for(var dataSet in data["data"])
        auditData.add(AuditData.fromJson(dataSet));
    }

    if(data.containsKey("auditQuestions")) {
      for(var e in data["auditQuestions"].entries) {
        if(questions[e.key] == null)
          questions[e.key] = <String, List<ClientAuditQuestion>> {};
        for(var q in e.value) {
          var question = ClientAuditQuestion.fromJson(q);
          if(questions[e.key]![question.questionTitle] == null) {
            print(question.questionTitle);
            questions[e.key]![question.questionTitle] = <ClientAuditQuestion>[];
          }
          questions[e.key]![question.questionTitle]?.add(question);
        }
      }
    }
    return ClientAudit(
        data["id"] ?? "",
        data["clientId"] ?? "",
        data["user"] ?? "",
        data["place"] ?? "",
        data["date"],
        data["address"],
        data["isSaved"] ?? false,
        auditData,
        questions
    );
  }

  @override
  String toString() {
    return 'ClientAudit{id: $id}';
  }
}