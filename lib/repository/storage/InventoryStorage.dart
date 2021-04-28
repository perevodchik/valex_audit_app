import 'package:valex_agro_audit_app/All.dart';

class InventoryStorage {

  Future<List<Inventory>> getInventory(String clientId) async {
    var inventory = <Inventory> [];
    var r = await AppDatabase.database!.rawQuery("SELECT * FROM inventory WHERE client_id = '$clientId';");
    for(var dataSet in r)
      inventory.add(Inventory.fromJson(dataSet));
    return inventory;
  }

  Future<Inventory> addInventory(Inventory inventory) async {
    var id = generateCachedId();
    inventory.id = id;
    await AppDatabase.database?.insert("inventory", {
      "id": inventory.id,
      "client_id": inventory.clientId,
      "name": inventory.name,
      "comment": inventory.comment,
      "count": inventory.count
    });
    return inventory;
  }

  Future<Inventory> updateInventory(Inventory inventory) async {
    await AppDatabase.database?.update("inventory", {
      "name": inventory.name,
      "comment": inventory.comment,
      "count": inventory.count
    }, where: "id = ?", whereArgs: [inventory.id]);
    return inventory;
  }

  Future<void> removeInventory(Inventory inventory) async {
    await AppDatabase.database?.delete("inventory", where: "id = ?", whereArgs: [inventory.id]);
  }

  Future<void> removeInventories(String clientId) async {
    await AppDatabase.database?.delete("inventory", where: "client_id = ?", whereArgs: [clientId]);
  }

}