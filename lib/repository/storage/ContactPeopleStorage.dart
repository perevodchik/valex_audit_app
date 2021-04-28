import 'package:valex_agro_audit_app/All.dart';

class ContactPeopleStorage {

  Future<List<ContactPeople>> getContactPeoples(String clientId) async {
    var people = <ContactPeople> [];
    var r = await AppDatabase.database!.rawQuery("SELECT * FROM contact_people WHERE client_id = '$clientId';");
    for(var dataSet in r)
      people.add(ContactPeople.fromJson(dataSet));
    return people;
  }

  Future<ContactPeople> addContactPeople(ContactPeople contact) async {
    var id = generateCachedId();
    contact.id = id;
    await AppDatabase.database?.insert("contact_people", {
      "id": contact.id,
      "client_id": contact.clientId,
      "name": contact.name,
      "work": contact.work,
      "phone": contact.phone
    });
    return contact;
  }

  Future<ContactPeople> updateContactPeople(ContactPeople contact) async {
    await AppDatabase.database?.update("contact_people", {
      "name": contact.name,
      "work": contact.work,
      "phone": contact.phone
    }, where: "id = ?", whereArgs: [contact.id]);
    return contact;
  }

  Future<void> removeContactPeople(ContactPeople contact) async {
    await AppDatabase.database?.delete("contact_people", where: "id = ?", whereArgs: [contact.id]);
  }

  Future<void> removeContactPeoples(String clientId) async {
    await AppDatabase.database?.delete("contact_people", where: "client_id = ?", whereArgs: [clientId]);
  }

}