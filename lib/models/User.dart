class User {
  String? id;
  String? name;
  String? company;
  String? rang;

  User({this.id, this.name, this.company, this.rang});

  factory User.fromJson(Map<String, dynamic> data) => User(
      id: data["id"] ?? "",
      name: data["name"] ?? "",
      company: data["company"] ?? "",
      rang: data["rang"] ?? ""
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "company": company,
    "rang": rang
  };

  User copyWith({id, name, company, rang}) => User(
      id: id ?? this.id,
      name: name ?? this.name,
      company: name ?? this.company,
      rang: name ?? this.rang
  );

  @override
  String toString() {
    return "{id: $id, name: $name, company: $company, rang: $rang}";
  }
}