class Score {
  final String playerID;
  final String playerName;
  final int highestScore;

  Score({
    required this.playerID,
    required this.playerName,
    required this.highestScore,
  });

  factory Score.fromFirestore(Map<String, dynamic> doc) {
    return Score(
      playerID: doc['playerID'],
      playerName: doc['playerName'],
      highestScore: doc['highestScore'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'playerID': playerID,
      'playerName': playerName,
      'highestScore': highestScore,
    };
  }
}