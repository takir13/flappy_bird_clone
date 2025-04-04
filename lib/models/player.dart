class Player {
  final String playerID;
  final String playerName;
  final int highestScore;
  final int points;
  final List<String> ownedSkins;

  Player({
    required this.playerID,
    required this.playerName,
    required this.highestScore,
    required this.points,
    required this.ownedSkins,
  });

  factory Player.fromFirestore(Map<String, dynamic> doc) {
    return Player(
      playerID: doc['playerID'],
      playerName: doc['playerName'],
      highestScore: doc['highestScore'],
      points: doc['points'],
      ownedSkins: List<String>.from(doc['ownedSkins']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'playerID': playerID,
      'playerName': playerName,
      'highestScore': highestScore,
      'points': points,
      'ownedSkins': ownedSkins,
    };
  }
}