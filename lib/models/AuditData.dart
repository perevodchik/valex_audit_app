class AuditData {
  String id;
  String auditId;
  String title;
  String value;
  String additional;

  AuditData({this.id = "", this.auditId = "", this.title = "", this.value = "", this.additional = ""});

  factory AuditData.fromJson(Map<String, dynamic> data) => AuditData(id: data["id"] ?? "", auditId: data["auditId"] ?? "", title: data["title"], value: data["value"], additional: data["additional"]);

  Map<String, dynamic> toJson() => {
    "title": title,
    "value": value,
    "additional": additional
  };

  @override
  String toString() {
    return "{title: $title, value: $value, additional: $additional}";
  }
}