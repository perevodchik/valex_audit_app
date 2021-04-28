import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valex_agro_audit_app/All.dart';

class UserRepository {

  static Future<User?> getUserById(String id) async {
    var r = await FirebaseFirestore
        .instance
        .collection(tableUsers)
        .doc(id)
        .get();
    if(r.exists)
      return User.fromJson(r.data()!);
    return null;
  }

  static Future<void> createUser(User user) async {
    var r = await FirebaseFirestore
        .instance
        .collection(tableUsers)
        .add(user.toJson());
    user.id = r.id;
  }

  static Future<void> getUsers() async {}
}