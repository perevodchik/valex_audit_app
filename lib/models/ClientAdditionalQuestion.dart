import 'package:valex_agro_audit_app/All.dart';

class ClientAdditionalQuestion {
  String id;
  String reviewId;
  String question;
  String answer;
  String change;

  ClientAdditionalQuestion({this.id = "", this.reviewId = "", this.question = "", this.answer = "", this.change = ""});

  factory ClientAdditionalQuestion.fromJson(Map<String, dynamic> data) => ClientAdditionalQuestion(
      question: data["question"] ?? "",
      answer: data["answer"] ?? "",
      change: data["change"] ?? ""
  );

  factory ClientAdditionalQuestion.empty() => ClientAdditionalQuestion(id: generateCachedId(), reviewId: "", question: "", answer: "", change: "");

  Map<String, dynamic> toJson() => {
    "question": question,
    "answer": answer,
    "change": change
  };

  ClientAdditionalQuestion copyWith({question, answer, change}) => ClientAdditionalQuestion(
      question: question ?? this.question,
      answer: answer ?? this.answer,
      change: change ?? this.change
  );

  @override
  String toString() {
    return "{id: $id, question: $question, answer: $answer, change: $change}";
  }
}