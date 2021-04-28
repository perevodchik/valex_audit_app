import '../All.dart';

class ClientFull {
  String id;
  String name;
  String address;
  String inventory;
  int countPC;
  int countCow;
  int createdAt;
  List<ContactPeople> contactPeoples;
  List<Inventory> clientInventory;
  List<Potential> clientPotential;
  List<ClientAudit> audits;

  bool get isCached => id.length > 30 && id.contains("_");
  String get firebaseId => isCached ? id.split("_")[0] : id;

  ClientFull(
      this.id,
      this.name,
      this.address,
      this.inventory,
      this.countPC,
      this.countCow,
      this.createdAt,
      this.contactPeoples,
      this.clientInventory,
      this.clientPotential,
      this.audits);

  factory ClientFull.fromJson(Map<String, dynamic> data) => ClientFull(
      data["id"] ?? "",
      data["name"] ?? "",
      data["address"] ?? "",
      data["inventory"] ?? "",
      data["countPC"] ?? data["count_pc"] ?? 0,
      data["countCow"] ?? data["count_cow"] ?? 0,
      data["createdAt"] ?? data["created_at"] ?? 0,
      data["contactPeoples"] == null ? [] : data["contactPeoples"].map<ContactPeople>((dataSet) => ContactPeople.fromJson(dataSet)).toList(),
      data["clientInventory"] == null ? [] : data["clientInventory"].map<Inventory>((dataSet) => Inventory.fromJson(dataSet)).toList(),
      data["clientPotential"] == null ? [] : data["clientPotential"].map<Potential>((dataSet) => Potential.fromJson(dataSet)).toList(),
      []
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address,
    "inventory": inventory,
    "countPC": countPC,
    "countCow": countCow,
    "createdAt": createdAt,
    "contactPeoples": contactPeoples.map<Map<String, dynamic>>((p) => p.toJson()).toList(),
    "clientInventory": clientInventory.map<Map<String, dynamic>>((i) => i.toJson()).toList(),
    "clientPotential": clientPotential.map<Map<String, dynamic>>((p) => p.toJson()).toList()
  };

  ClientFull copyWith({id, name, address, inventory, countPC, countCow, createdAt, contactPeoples, clientInventory, clientPotential, audits}) => ClientFull(
      id ?? this.id,
      name ?? this.name,
      address ?? this.address,
      inventory ?? this.inventory,
      countPC ?? this.countPC,
      countCow ?? this.countCow,
      createdAt ?? this.createdAt,
      contactPeoples ?? this.contactPeoples,
      clientInventory ?? this.clientInventory,
      clientPotential ?? this.clientPotential,
      audits ?? this.audits
  );

  @override
  String toString() {
    return "{id: $id, name: $name, address: $address, inventory: $inventory, countPC: $countPC, countCow: $countCow, createdAt: $createdAt, contactPeoples: $contactPeoples, clientInventory: $clientInventory, clientPotential: $clientPotential}";
  }
}