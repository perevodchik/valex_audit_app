import '../../All.dart';

class AdditionalQuestionStorage {

  Future<List<ClientAdditionalQuestion>> getAdditionalQuestion(String reviewId) async {
    var questions = <ClientAdditionalQuestion> [];
    print("SELECT * FROM audit_question WHERE review_id = '$reviewId';");
    var r = await AppDatabase.database!.rawQuery("SELECT * FROM additional_question WHERE review_id = '$reviewId';");
    for(var dataSet in r) {
      questions.add(ClientAdditionalQuestion.fromJson(dataSet));
    }
    return questions;
  }

  Future<ClientAdditionalQuestion> addAdditionalQuestion(ClientAdditionalQuestion question) async {
    var id = generateCachedId();
    question.id = id;
    await AppDatabase.database?.insert("additional_question", {
      "id": question.id,
      "review_id": question.reviewId,
      "question": question.question,
      "answer": question.answer,
      "change": question.change
    });
    return question;
  }

  Future<void> removeAdditionalQuestion(ClientAdditionalQuestion question) async {
    await AppDatabase.database?.delete("additional_question", where: "id = ?", whereArgs: [question.id]);
  }

  Future<void> removeAdditionalQuestions(String reviewId) async {
    await AppDatabase.database?.delete("additional_question", where: "review_id = ?", whereArgs: [reviewId]);
  }

}