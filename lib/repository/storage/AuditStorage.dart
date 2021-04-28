import 'package:valex_agro_audit_app/All.dart';

class AuditStorage {

  Future<List<ClientAudit>> getAudits(String clientId) async {
    var audits = <ClientAudit> [];
    var r = await AppDatabase.database!.rawQuery("SELECT * FROM audits WHERE clientId = '$clientId';");
    for(var dataSet in r) {
      var a = ClientAudit.fromJson(dataSet);
      audits.add(a);
    }
    return audits;
  }

  Future<List<ClientAudit>> getAuditsAll() async {
    var audits = <ClientAudit> [];
    var r = await AppDatabase.database!.rawQuery("SELECT * FROM audits;");
    for(var dataSet in r) {
      var a = ClientAudit.fromJson(dataSet);
      audits.add(a);
    }
    return audits;
  }

  Future<ClientAudit?> getAudit(String auditId) async {
    var r = await AppDatabase.database!.rawQuery("SELECT * FROM audits WHERE id = '$auditId';");
    if(r.isEmpty) return null;
    return ClientAudit.fromJson(r.first);
  }

  Future<ClientAudit> addAudit(ClientAudit audit) async {
    audit.id = generateCachedId();
    await AppDatabase.database?.insert("audits", {
      "id": audit.id,
      "clientId": audit.clientId,
      "date": audit.date,
      "address": audit.address,
      "place": audit.place,
      "user": audit.user
    });
    return audit;
  }

  Future<void> removeAudit(ClientAudit audit) async {
    await AppDatabase.database!.rawQuery("DELETE FROM audits WHERE id = '${audit.id}';");
  }

  Future<void> removeAudits(String clientId) async {
    await AppDatabase.database!.rawQuery("DELETE FROM audits WHERE clientId = '$clientId';");
  }
}