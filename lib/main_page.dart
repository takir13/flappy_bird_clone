import 'package:flame/game.dart';
import 'package:flappy_bird_clone/bloc/game/game_cubit.dart';
import 'package:flappy_bird_clone/flappy_bird_clone_game.dart';
import 'package:flappy_bird_clone/widgets/leaderboard_screen.dart';
import 'package:flappy_bird_clone/widgets/game_over_widget.dart';
import 'package:flappy_bird_clone/widgets/home_screen_widget.dart';
import 'package:flappy_bird_clone/widgets/settings_screen.dart';
import 'package:flappy_bird_clone/widgets/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late FlappyBirdCloneGame _flappyBirdCloneGame;
  late GameCubit gameCubit;
  PlayingState? _latestState;

  @override
  void initState() {
    gameCubit = BlocProvider.of<GameCubit>(context);
    _flappyBirdCloneGame = FlappyBirdCloneGame(gameCubit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(listener: (context, state) {
      if (state.currentPlayingState == PlayingState.none &&
              _latestState == PlayingState.gameOver ||
          _latestState == PlayingState.settings ||
          _latestState == PlayingState.leaderboard ||
          _latestState == PlayingState.signin) {
        setState(() {
          _flappyBirdCloneGame = FlappyBirdCloneGame(gameCubit);
        });
      }
      _latestState = state.currentPlayingState;
    }, builder: (context, state) {
      return Scaffold(
          body: Stack(
        children: [
          GameWidget(game: _flappyBirdCloneGame),
          if (state.currentPlayingState ==
              PlayingState.gameOver) // Game over Screen
            GameOverWidget(gameCubit: gameCubit, currentCoins: gameCubit.state.currentCoins,)
          else if (state.currentPlayingState ==
              PlayingState.none) // Home Screen
            HomeScreenWidget(gameCubit: gameCubit)
          else if (state.currentPlayingState ==
              PlayingState.settings) // Setting screen
            SettingScreen(gameCubit: gameCubit)
          else if (state.currentPlayingState ==
              PlayingState.leaderboard) // customization screen
            LeaderboardScreen(gameCubit: gameCubit)
          else if (state.currentPlayingState ==
              PlayingState.signin) // Sign in screen
            SignInScreen(gameCubit: gameCubit)
        ],
      ));
    });
  }
}
