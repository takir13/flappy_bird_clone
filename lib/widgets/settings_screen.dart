import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_clone/components/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:flappy_bird_clone/bloc/game/game_cubit.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key, required this.gameCubit});
  final GameCubit gameCubit;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final AudioManager _audioManager = AudioManager();
  String? playerName;

  @override
  void initState() {
    super.initState();
    _fetchPlayerName();
  }

  Future<void> _fetchPlayerName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch player data from Firestore instead of using displayName
      final playerDoc =
          FirebaseFirestore.instance.collection('players').doc(user.uid);
      final playerData = await playerDoc.get();

      if (playerData.exists) {
        setState(() {
          playerName = playerData['playerName'] ?? "Anonymous";
        });
      } else {
        setState(() {
          playerName = "Guest";
        });
      }
    } else {
      setState(() {
        playerName = "Guest";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Settings",
              style: TextStyle(fontSize: 70, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              "Player Name: ${playerName ?? "Loading..."}",
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Toggle Background Music ',
                    style: const TextStyle(fontSize: 24, color: Colors.white)),
                Switch(
                    activeColor: Colors.blue,
                    activeTrackColor: Colors.white,
                    value: _audioManager.isBgmPlaying,
                    onChanged: (value) {
                      setState(() {
                        _audioManager.toggleBgm();
                      });
                    })
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => widget.gameCubit.restartGame(),
              child: const Text(
                "Go Back",
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
