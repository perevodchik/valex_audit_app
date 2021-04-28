import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? database;

  Future<void> init() async {
    database = await openDatabase("valex.db", version: 1, onCreate: (Database db, int version) async {
      var inventory = "CREATE TABLE inventory (id TEXT, client_id TEXT, name TEXT, comment TEXT, count INTEGER)";
      var contactPeople = "CREATE TABLE contact_people (id TEXT, client_id TEXT, name TEXT, work TEXT, phone TEXT)";
      var client = "CREATE TABLE clients (id TEXT, name TEXT, address TEXT, inventory TEXT, count_pc INTEGER, count_cow INTEGER, created_at INTEGER)";
      var review = "CREATE TABLE reviews (id TEXT, client_id TEXT, user TEXT, workedCow TEXT, cowAvgByDay TEXT, milkByDay TEXT, "
          "tovarnistMilk TEXT, milkFat TEXT, milkProtein TEXT, zakupMilkPrice TEXT, invalidCow TEXT, "
          "mastit TEXT, kopyta TEXT, endometryt TEXT, bacteryZabrudMilk TEXT, bacterySomatMilk TEXT, "
          "createdAt INTEGER, date TEXT, metaSell BOOL, metaProduction BOOL, getQuestion BOOL)";
      var additionalQuestion = "CREATE TABLE additional_question(id TEXT, review_id TEXT, question TEXT, answer TEXT, change TEXT)";
      var auditData = "CREATE TABLE audit_data (id TEXT, auditId TEXT, title TEXT, value TEXT, additional TEXT)";
      var clientAuditQuestion = "CREATE TABLE audit_question(id TEXT, audit TEXT, auditId TEXT, category TEXT, question TEXT, questionTitle TEXT, comment TEXT, rateParam TEXT, firstRate TEXT, secondRate TEXT, photosSrc TEXT, withRate BOOL, withSelector BOOL)";
      var audit = "CREATE TABLE audits(id TEXT, clientId TEXT, user TEXT, place TEXT, date TEXT, address TEXT)";

      await db.execute(inventory);
      print("execute $inventory");

      await db.execute(contactPeople);
      print("execute $contactPeople");

      await db.execute(client);
      print("execute $client");

      await db.execute(review);
      print("execute $review");

      await db.execute(additionalQuestion);
      print("execute $additionalQuestion");

      await db.execute(auditData);
      print("execute $auditData");

      await db.execute(clientAuditQuestion);
      print("execute $clientAuditQuestion");

      await db.execute(audit);
      print("execute $audit");
    });
    print("init finish");
  }


}