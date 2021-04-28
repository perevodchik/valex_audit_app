import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valex_agro_audit_app/All.dart';

class ReviewRepository {

  static Future<List<ClientReview>> getClientReviews(String clientId) async {
    var reviewsList = <ClientReview> [];
    var reviews = await FirebaseFirestore
        .instance
        .collection(tableClients)
        .doc(clientId)
        .collection(tableReviews)
        .get();
    for(var dataSet in reviews.docs) {
      try {
        var review = ClientReview.fromJson(dataSet.data());
        review.id = dataSet.id;
        print(review.toJson());
        reviewsList.add(review);
      } catch(e) {
        print("e $e");
      }
    }
    return reviewsList;
  }

  static Future<ClientReview> addReview(ClientReview review, String clientId) async {
    try {
      var oldId = review.id;
      var r = await FirebaseFirestore
          .instance
          .collection(tableClients)
          .doc(clientId)
          .collection(tableReviews)
          .add(review.toJson());
      review.id = r.id;
      await FirebaseFirestore
          .instance
          .collection(tableClientsShort)
          .doc(clientId)
          .collection(tableReviews)
          .doc(review.id)
          .set(review.toJson());
      review.id = oldId;
    } catch(e) {}
    return review;
  }

}