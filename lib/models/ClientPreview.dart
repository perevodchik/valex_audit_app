import 'package:valex_agro_audit_app/All.dart';

class ClientPreview{
  String id;
  String? name;
  String? address;
  String? dateLastAudit;
  String? userLastAudit;
  int? createdAt;

  bool get isCached => id.length > 30 && id.contains("_");
  String get firebaseId => isCached ? id.split("_")[0] : id;

  ClientPreview(
      {this.id = "",
      this.name,
      this.address,
      this.dateLastAudit,
      this.userLastAudit,
      this.createdAt});

  factory ClientPreview.fromJson(Map<String, dynamic> data) => ClientPreview(
      id: data["id"] ?? "",
      name: data["name"] ?? "", 
      address: data["address"] ?? "", 
      dateLastAudit: data["dateLastAudit"] ?? "", 
      userLastAudit: data["userLastAudit"] ?? "",
      createdAt: data["createdAt"] ?? 0
  );

  factory ClientPreview.fromClient(ClientFull client) => ClientPreview(
    id: client.id,
    name: client.name,
    address: client.address,
    dateLastAudit: null,
    userLastAudit: null,
    createdAt: client.createdAt
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address,
    "dateLastAudit": dateLastAudit,
    "userLastAudit": userLastAudit,
    "createdAt": createdAt
  };

  void update(ClientPreview client) {
    name = client.name ?? name;
    address = client.address ?? this.address;
    name = client.name ?? this.name;
  }

  ClientPreview copyWith({id, name, address, dateLastAudit, userLastAudit, createdAt}) => ClientPreview(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address ?? this.address,
    dateLastAudit: dateLastAudit ?? this.dateLastAudit,
    userLastAudit: userLastAudit ?? this.userLastAudit,
    createdAt: createdAt ?? this.createdAt
  );

  @override
  String toString() {
    return '{id: $id, name: $name, address: $address, dateLastAudit: $dateLastAudit, userLastAudit: $userLastAudit}';
  }
}
