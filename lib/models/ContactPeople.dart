import 'dart:math';

class ContactPeople {
  String id;
  String clientId;
  String name;
  String work;
  String phone;
  bool isNeedDelete;

  ContactPeople({this.id = "", this.clientId = "", this.name = "", this.work = "", this.phone = "", this.isNeedDelete = false});

  bool get isEmpty => name.isEmpty || work.isEmpty || phone.isEmpty;
  bool get isNotEmpty => name.isNotEmpty && work.isNotEmpty && phone.isNotEmpty;

  factory ContactPeople.fromJson(Map<String, dynamic> data) => ContactPeople(
      id: data["id"] ?? "",
      clientId: data["clientId"] ?? "",
      name: data["name"] ?? "",
      work: data["work"] ?? "",
      phone: data["phone"] ?? ""
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "clientId": clientId,
    "name": name,
    "work": work,
    "phone": phone
  };

  factory ContactPeople.empty() => ContactPeople(id: "", clientId: "", name: "", work: "", phone: "");

  ContactPeople copyWith({id, clientId, name, work, phone}) => ContactPeople(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      name: name ?? this.name,
      work: work ?? this.work,
      phone: phone ?? this.phone
  );

  @override
  String toString() {
    return "{id: $id, clientId: $clientId, name: $name, work: $work, phone: $phone}";
  }
}