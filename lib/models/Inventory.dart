import 'dart:math';

class Inventory {
  String id;
  String clientId;
  String name;
  String comment;
  int count;
  bool isNeedDelete;

  Inventory({this.id = "", this.clientId = "", this.name = "", this.comment = "", this.count = 0, this.isNeedDelete = false});

  factory Inventory.fromJson(Map<String, dynamic> data) => Inventory(
      id: data["id"] ?? "",
      clientId: data["clientId"] ?? "",
      name: data["name"] ?? "",
      comment: data["comment"] ?? "",
      count: data["count"] ?? 0
  );

  factory Inventory.empty() => Inventory(id: "", clientId: "", name: "", comment: "", count: 0);

  Map<String, dynamic> toJson() => {
    "id": id,
    "clientId": clientId,
    "name": name,
    "comment": comment,
    "count": count
  };

  Inventory copyWith({id, clientId, name, comment, count}) => Inventory(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      name: name ?? this.name,
      comment: comment ?? this.comment,
      count: count ?? this.count
  );

  @override
  String toString() {
    return "{id: $id, clientId: $clientId, name: $name, comment: $comment, count: $count}";
  }
}