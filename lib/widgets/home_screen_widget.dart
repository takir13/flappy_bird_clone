import 'package:flappy_bird_clone/bloc/game/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenWidget extends StatelessWidget {
  const HomeScreenWidget({super.key, required this.gameCubit});
  final GameCubit gameCubit;

  @override
  Widget build(BuildContext context) {
    return 
            Center(
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Text(
                        "FLAPPY BIRD CLONE",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.titanOne(
                            fontSize: 50, color: Colors.white),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 500),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  elevation: WidgetStatePropertyAll(20),
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.lightBlue),
                                  shadowColor:
                                      WidgetStatePropertyAll(Colors.black)),
                              onPressed: () => gameCubit.settingsScreen(),
                              child: const Text("Settings",
                                  style: TextStyle(color: Colors.white))),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  elevation: WidgetStatePropertyAll(20),
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.lightBlue),
                                  shadowColor:
                                      WidgetStatePropertyAll(Colors.black)),
                              onPressed: () => gameCubit.customizationScreen(),
                              child: const Text("Leaderboard",
                                  style: TextStyle(color: Colors.white)))
                        ],
                      ))
                ],
              ),
            );
  }
}

