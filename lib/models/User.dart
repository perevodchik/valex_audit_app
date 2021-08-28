import 'package:shared_preferences/shared_preferences.dart';

class User {
  String? id;
  String? name;
  String? company;
  String? rang;
  bool canDelete;
  bool canEdit;
  bool canCreate;

  User({this.id, this.name, this.company, this.rang,
    this.canDelete = false, this.canEdit = false, this.canCreate = false});

  factory User.fromJson(Map<String, dynamic> data) => User(
      id: data["id"] ?? "",
      name: data["name"] ?? "",
      company: data["company"] ?? "",
      rang: data["rang"] ?? "",
      canDelete: data["canDelete"] ?? false,
      canEdit: data["canEdit"] ?? false,
      canCreate: data["canCreate"] ?? false,
  );

  factory User.fromShared(SharedPreferences s) => User(
      id: s.getString("user"),
      name: s.getString("name"),
      company: s.getString("company"),
      rang: s.getString("rang"),
      canDelete: s.getBool("canDelete") ?? false,
      canEdit: s.getBool("canEdit") ?? false,
      canCreate: s.getBool("canCreate") ?? false
  );

  void toShared(SharedPreferences s) {
    s.setString("user", id ?? "");
    s.setString("name", name ?? "");
    s.setString("company", company ?? "");
    s.setString("rang", rang ?? "");
    s.setBool("canDelete", canDelete);
    s.setBool("canEdit", canEdit);
    s.setBool("canCreate", canCreate);
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "company": company,
    "rang": rang,
    "canDelete": canDelete,
    "canEdit": canEdit,
    "canCreate": canCreate
  };

  User copyWith({id, name, company, rang}) => User(
      id: id ?? this.id,
      name: name ?? this.name,
      company: name ?? this.company,
      rang: name ?? this.rang
  );

  @override
  String toString() => toJson().toString();
}