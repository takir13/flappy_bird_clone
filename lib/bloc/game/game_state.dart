part of 'game_cubit.dart';

class GameState with EquatableMixin {
  const GameState(
      {this.currentCoins = 0, this.currentPlayingState = PlayingState.none});

  final int currentCoins;
  final PlayingState currentPlayingState;

  GameState copyWith({int? currentCoins, PlayingState? currentPlayingState}) =>
      GameState(
          currentCoins: currentCoins ?? this.currentCoins,
          currentPlayingState: currentPlayingState ?? this.currentPlayingState);

  @override
  List<Object> get props => [currentCoins, currentPlayingState];
}

enum PlayingState {
  none,
  playing,
  paused,
  gameOver,
  settings,
  leaderboard,
  signin
}
