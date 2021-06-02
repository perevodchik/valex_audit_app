import 'package:cloud_firestore/cloud_firestore.dart';

import '../All.dart';

class ClientsShortRepository {

  static Future<List<ClientPreview>> getClients() async {
    var clientsList = <ClientPreview> [];
    var clients = await FirebaseFirestore
        .instance
        .collection(tableClientsShort)
        .orderBy("lastAudit", descending: true)
        .get();
    for(var dataSet in clients.docs) {
      try {
        var client = ClientPreview.fromJson(dataSet.data());
        client.id = dataSet.id;
        clientsList.add(client);
      } catch(e) {}
    }
    return clientsList;
  }

  static Future<ClientPreview?> getClient(String id) async {
    var client = await FirebaseFirestore
        .instance
        .collection(tableClientsShort)
        .doc(id)
        .get();
    print(client.data());
    if(client.exists) return ClientPreview.fromJson(client.data()!);
    return null;
  }

  static Future<void> updateClient(ClientPreview client) async {
    await FirebaseFirestore
        .instance
        .collection(tableClientsShort)
        .doc(client.id)
        .update(client.toJson());
  }

  static Future<void> createClient(ClientPreview client) async {
    await FirebaseFirestore
        .instance
        .collection(tableClientsShort)
        .doc(client.id)
        .set(client.toJson());
  }

}