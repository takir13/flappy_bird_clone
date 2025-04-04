import 'package:flappy_bird_clone/bloc/game/game_cubit.dart';
import 'package:flappy_bird_clone/services/player_records.dart';
import 'package:flappy_bird_clone/services/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.gameCubit});
  final GameCubit gameCubit;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter a Username!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, color: Colors.lightBlue),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _usernameController,
                autofocus: true,
                decoration: InputDecoration(iconColor: Colors.lightBlue,
                  labelText: "Username",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.lightBlue,
                        width: 2.0), 
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.lightBlue,
                        width: 1.0), 
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = await signInAnonymously();
                if (user != null) {
                  await savePlayerName(_usernameController.text);
                  widget.gameCubit.restartGame();
                  debugPrint('User signed in successfully: ${user.uid}');
                }
              },
              child: const Text("Sign In", style: TextStyle(color: Colors.lightBlue),),
            ),
          ],
        ),
      ),
    );
  }
}
