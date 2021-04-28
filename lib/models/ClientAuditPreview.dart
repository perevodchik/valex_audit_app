class ClientAuditPreview {
  String id;
  String clientId;
  String date;
  String address;

  ClientAuditPreview({this.id = "", this.clientId = "", this.date = "", this.address = ""});

  Map<String, dynamic> toJson() => {
    "id": id,
    "clientId": clientId,
    "date": date,
    "address": address
  };

  factory ClientAuditPreview.fromJson(Map<String, dynamic> data) => ClientAuditPreview(
      id: data["id"] ?? "",
      clientId: data["clientId"] ?? "",
      date: data["date"] ?? "",
      address: data["address"] ?? ""
  );

  @override
  String toString() {
    return "{id: $id, clientId: $clientId, date: $date, address: $address}";
  }
}