import 'package:valex_agro_audit_app/All.dart';
import 'package:valex_agro_audit_app/utils/Utils.dart';

class ReviewsStorage {
  
  Future<List<ClientReview>> getReviews(String clientId) async {
    var reviews = < ClientReview> [];
    var r = await AppDatabase.database!.rawQuery("SELECT * FROM reviews WHERE client_id = '$clientId';");
    for(var dataSet in r) {
      try {
        reviews.add(ClientReview.fromJson(dataSet));
      } catch(e) {
        print(e);
      }
    }
    return reviews;
  }

  Future<List<ClientReview>> getAllReviews() async {
    var reviews = < ClientReview> [];
    var r = await AppDatabase.database!.rawQuery("SELECT * FROM reviews;");
    for(var dataSet in r) {
      try {
        reviews.add(ClientReview.fromJson(dataSet));
      } catch(e) {
        print(e);
      }
    }
    return reviews;
  }

  Future<ClientReview> addReview(ClientReview review, ClientFull client) async {
    await AppDatabase.database?.insert("reviews", {
      "id": review.id,
      "client_id": client.id,
      "user": review.user,
      "date": review.date.toString(),
      "workedCow": review.workedCow,
      "cowAvgByDay": review.cowAvgByDay,
      "milkByDay": review.milkByDay,
      "tovarnistMilk": review.tovarnistMilk,
      "milkFat": review.milkFat,
      "milkProtein": review.milkProtein,
      "zakupMilkPrice": review.zakupMilkPrice,
      "invalidCow": review.invalidCow,
      "mastit": review.mastit,
      "kopyta": review.kopyta,
      "endometryt": review.endometryt,
      "bacteryZabrudMilk": review.bacteryZabrudMilk,
      "bacterySomatMilk": review.bacterySomatMilk,
      "createdAt": review.createdAt,
      "metaSell": review.metaSell ? 1 : 0,
      "metaProduction": review.metaProduction ? 1 : 0,
      "getQuestion": review.getQuestion ? 1 : 0
    });
    return review;
  }

  Future<void> removeReview(ClientReview review) async {
    await AppDatabase.database?.delete("reviews", where: "id = ?", whereArgs: [review.id]);
  }

  Future<void> removeReviews(String clientId) async {
    await AppDatabase.database?.delete("reviews", where: "client_id = ?", whereArgs: [clientId]);
  }
}