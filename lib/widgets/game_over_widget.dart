import 'package:flappy_bird_clone/bloc/game/game_cubit.dart';
import 'package:flappy_bird_clone/services/player_records.dart';
import 'package:flutter/material.dart';

class GameOverWidget extends StatelessWidget {
  const GameOverWidget(
      {super.key, required this.gameCubit, required this.currentCoins});

  final GameCubit gameCubit;
  final int currentCoins;

  @override
  Widget build(BuildContext context) {

    updateScore(currentCoins, currentCoins);  

    return Container(
      color: Colors.black38,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'GAME OVER',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Text(
            'Coins earned: $currentCoins',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
              onPressed: () => gameCubit.restartGame(),
              child: const Text(
                'Play Again!',
                style: TextStyle(color: Colors.lightBlue),
              ))
        ],
      )),
    );
  }
}
