import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valex_agro_audit_app/All.dart';

class ClientsRepository {

  static Future<void> removeClientById(String clientId) async {
    var audits = await AuditRepository.getAuditList(clientId);
    for(var auditId in audits)
      await AuditRepository.removeAudit(clientId, auditId);
    await FirebaseFirestore
        .instance
        .collection(tableClients)
        .doc(clientId)
        .delete();
    await FirebaseFirestore
        .instance
        .collection(tableClientsShort)
        .doc(clientId)
        .delete();
  }

  static Future<void> updateClient(ClientFull client) async {
    await FirebaseFirestore
        .instance
        .collection(tableClients)
        .doc(client.id)
        .set(client.toJson());
    await ClientsShortRepository.updateClient(ClientPreview.fromClient(client));
  }

  static Future<void> createClient(ClientFull client) async {
    if(client.id.isNotEmpty) {
      var r = await FirebaseFirestore
          .instance
          .collection(tableClients)
          .doc(client.id)
          .set(client.toJson());
    } else {
      var r = await FirebaseFirestore
          .instance
          .collection(tableClients)
          .add(client.toJson());
      client.id = r.id;
    }

    await ClientsShortRepository.createClient(ClientPreview.fromClient(client));
  }

  static Future<ClientFull?> getClientById(String clientId) async {
    var r = await FirebaseFirestore
        .instance
        .collection(tableClients)
        .doc(clientId)
        .get();
    if(!r.exists) return null;
    var client = ClientFull.fromJson(r.data()!);
    client.id = r.id;
    return client;
  }
}