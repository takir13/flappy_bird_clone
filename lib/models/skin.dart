class Skin {
  final String skinID;
  final int cost;
  final String description;

  Skin({
    required this.skinID,
    required this.cost,
    required this.description,
  });

  factory Skin.fromFirestore(Map<String, dynamic> doc) {
    return Skin(
      skinID: doc['skinID'],
      cost: doc['cost'],
      description: doc['description'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'skinID': skinID,
      'cost': cost,
      'description': description,
    };
  }
}