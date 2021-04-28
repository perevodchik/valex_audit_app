class Potential {
  String id;
  String clientId;
  int? year;
  int? potential;
  int? releasedPotential;
  String? washed;
  String? milkingGuma;
  String? udderProcessing;
  String? originalFunds;
  String? inventoryForComfort;
  bool isNeedDelete;

  Potential(
      {this.id = "",
      this.clientId = "",
      this.year,
      this.potential,
      this.releasedPotential,
      this.washed,
      this.milkingGuma,
      this.udderProcessing,
      this.originalFunds,
      this.inventoryForComfort,
      this.isNeedDelete = false});

  factory Potential.fromJson(Map<String, dynamic> data) => Potential(
        id: data["id"] ?? "",
        clientId: data["clientId"] ?? "",
        year: data["year"] ?? 0,
        potential: data["potential"] ?? 0,
        releasedPotential: data["releasedPotential"] ?? 0,
        washed: data["washed"] ?? "",
        milkingGuma: data["milkingGuma"] ?? "",
        udderProcessing: data["udderProcessing"] ?? "",
        originalFunds: data["originalFunds"] ?? "",
        inventoryForComfort: data["inventoryForComfort"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "clientId": clientId,
    "year": year,
    "potential": potential,
    "releasedPotential": releasedPotential,
    "washed": washed,
    "milkingGuma": milkingGuma,
    "udderProcessing": udderProcessing,
    "originalFunds": originalFunds,
    "inventoryForComfort": inventoryForComfort
  };

  Potential copyWith({
    id,
    clientId,
    year,
    potential,
    releasedPotential,
    washed,
    milkingGuma,
    udderProcessing,
    originalFunds,
    inventoryForComfort}) => Potential(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      year: year ?? this.year,
      potential: potential ?? this.potential,
      releasedPotential: releasedPotential ?? this.releasedPotential,
      washed: washed ?? this.washed,
      milkingGuma: milkingGuma ?? this.milkingGuma,
      udderProcessing: udderProcessing ?? this.udderProcessing,
      originalFunds: originalFunds ?? this.originalFunds,
      inventoryForComfort: inventoryForComfort ?? this.inventoryForComfort);

  @override
  String toString() {
    return "{id: $id, clientId: $clientId, ear: $year, potential: $potential, releasedPotential: $releasedPotential, washed: $washed, milkingGuma: $milkingGuma, udderProcessing: $udderProcessing, originalFunds: $originalFunds, inventoryForComfort: $inventoryForComfort}";
  }
}
