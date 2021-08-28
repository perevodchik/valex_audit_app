import '../../All.dart';

class ClientStorage {
  Future<List<ClientFull>> getClients() async {
    var clients = <ClientFull> [];
    print(AppDatabase.database == null);
    var r = await AppDatabase.database!.rawQuery("SELECT * FROM clients;");

    for(var dataSet in r) {
      print(dataSet);
      var c = ClientFull.fromJson(dataSet);
      c.contactPeoples = await LocalStorage().getContactPeoples(c.id);
      // c.contactPeoples = await LocalStorage.potentialStorage().getContactPeoples(c.id);
      c.clientInventory = await LocalStorage().getInventory(c.id);
      clients.add(c);
    }

    return clients;
  }

  Future<ClientFull?> getClient(String clientId) async {
    var r = await AppDatabase.database!.rawQuery("SELECT * FROM clients WHERE id = '$clientId';");
    if(r.isEmpty) return null;

    print(r.first);

    var client = ClientFull.fromJson(r.first);
    client.contactPeoples = await LocalStorage().getContactPeoples(client.id);
    client.clientInventory = await LocalStorage().getInventory(client.id);

    return client;
  }

  Future<List<ClientPreview>> getClientsPreview() async {
    var clients = <ClientPreview> [];
    print(AppDatabase.database == null);
    var r = await AppDatabase.database!.rawQuery("SELECT * FROM clients;");

    for(var dataSet in r) {
      print(dataSet);
      var c = ClientPreview.fromJson(dataSet);
      clients.add(c);
    }

    return clients;
  }

  Future<ClientFull> addClient(ClientFull client) async {
    var id = generateCachedId();
    client.id = id;
    print("addClient ${client.toJson()}");
    await AppDatabase.database?.insert("clients", {
      "id": client.id,
      "name": client.name,
      "address": client.address,
      "inventory": client.inventory,
      "count_pc": client.countPC,
      "count_cow": client.countCow,
      "created_at": client.createdAt
    });

    return client;
  }

  Future<ClientFull> updateClient(ClientFull client) async {
    var r = await AppDatabase.database?.update("clients", {
      "name": client.name,
      "address": client.address,
      "inventory": client.inventory,
      "count_pc": client.countPC,
      "count_cow": client.countCow
    }, where: "id = ?", whereArgs: [client.id]);
    return client;
  }

  Future<void> removeClient(ClientFull client) async {
    await AppDatabase.database?.delete("clients", where: "id = ?", whereArgs: [client.id]);
  }

  Future<void> removeClientById(String id) async {
    await AppDatabase.database?.delete("clients", where: "id = ?", whereArgs: [id]);
  }

  Future<void> removeClients(List<ClientFull> clients) async {
    var batch = AppDatabase.database!.batch();
    for(var client in clients)
      batch.delete("clients", where: "id = ?", whereArgs: [client.id]);
    await batch.commit();
  }
}