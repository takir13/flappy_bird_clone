// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState());

  void startPlaying() {
    emit(state.copyWith(
        currentPlayingState: PlayingState.playing, currentCoins: 0));
        debugPrint('STATE SET TO PLAYING');
  }

  void gameOver() {
    emit(state.copyWith(currentPlayingState: PlayingState.gameOver));
    debugPrint('STATE SET TO GAMEOVER');
  }

  void increaseCoins() {
    emit(state.copyWith(
      currentCoins: state.currentCoins + 1,
    ));
  }

  void restartGame() {
    emit(state.copyWith(
        currentPlayingState: PlayingState.none, currentCoins: 0));
        debugPrint('STATE SET TO NONE');
  }

  void settingsScreen() {
    emit(state.copyWith(currentPlayingState: PlayingState.settings));
    debugPrint('STATE SET TO SETTINGS');
  }

  void customizationScreen() {
    emit(state.copyWith(currentPlayingState: PlayingState.leaderboard));
    debugPrint('STATE SET TO LEADERBOARD');
  }

  void signInScreen() {
    emit(state.copyWith(currentPlayingState: PlayingState.signin));
    debugPrint("STATE SET TO SIGNIN");
  }
}
