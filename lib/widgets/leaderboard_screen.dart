import 'package:flappy_bird_clone/services/player_records.dart';
import 'package:flutter/material.dart';
import 'package:flappy_bird_clone/bloc/game/game_cubit.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key, required this.gameCubit});
  final GameCubit gameCubit;

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> topScores = [];
  Map<String, dynamic>? playerRank;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    Map<String, dynamic> leaderboardData = await getLeaderboard();

    setState(() {
      topScores =
          List<Map<String, dynamic>>.from(leaderboardData['topScores'] ?? []);
      playerRank = leaderboardData['playerRank'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Leaderboard",
              style: TextStyle(fontSize: 65, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                color: Colors.white,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Rank')),
                    DataColumn(label: Text('Player Name')),
                    DataColumn(label: Text('Highest Score')),
                  ],
                  rows: topScores.asMap().entries.map((entry) {
                    int rank = entry.key + 1;
                    Map<String, dynamic> data = entry.value;

                    return DataRow(cells: [
                      DataCell(Text(rank.toString())),
                      DataCell(Text(data['playerName'] ?? 'Unknown')),
                      DataCell(Text(data['highestScore'].toString())),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            if (playerRank != null) ...[
              const SizedBox(height: 20),
              Text('${playerRank!['playerName']}',
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              Text(
                "Your HighScore: ${playerRank!['highestScore']}",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text('Total Coins Earned: ${playerRank!['points']}',
                  style: const TextStyle(fontSize: 18, color: Colors.white))
            ],
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => widget.gameCubit.restartGame(),
              child: const Text(
                "Go Back",
                style: TextStyle(color: Colors.lightBlue),
              ),
            )
          ],
        ),
      ),
    );
  }
}
