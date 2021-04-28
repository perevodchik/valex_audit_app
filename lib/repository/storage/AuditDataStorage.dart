import '../../All.dart';

class AuditDataStorage {

  Future<List<AuditData>> getAuditData(String auditId) async {
    var data = <AuditData> [];
    var r = await AppDatabase.database!.rawQuery("SELECT * FROM audit_data WHERE auditId = '$auditId';");
    for(var dataSet in r) {
      data.add(AuditData.fromJson(dataSet));
    }
    return data;
  }

  Future<AuditData> addAuditData(AuditData data) async {
    var id = generateCachedId();
    data.id = id;
    await AppDatabase.database!.insert("audit_data", {
      "id": id,
      "auditId": data.auditId,
      "title": data.title,
      "value": data.value,
      "additional": data.additional
    });
    return data;
  }


  Future<void> deleteAuditData(String auditId) async {
    await AppDatabase.database!.delete("audit_data", where: "auditId = ?", whereArgs: [auditId]);
  }

}