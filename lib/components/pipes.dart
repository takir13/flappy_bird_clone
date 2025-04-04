import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flappy_bird_clone/bloc/game/game_cubit.dart';
import 'package:flappy_bird_clone/components/coin.dart';

class Pipes extends PositionComponent {
  Pipes({required this.flippedPipe, required super.position});

  late Sprite _pipeSprite;
  final bool flippedPipe;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _pipeSprite = await Sprite.load('pipe.png');
    size = Vector2(56, 600);
    anchor = Anchor.topCenter;
    if (flippedPipe) {
      flipVertically();
    }
    add(RectangleHitbox(
        size: Vector2(size.x * 0.75, size.y),
        position: Vector2(8, 10),
        collisionType: CollisionType.passive));
    // debugMode = true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _pipeSprite.render(canvas);
  }
}

class PipePair extends PositionComponent
    with FlameBlocReader<GameCubit, GameState> {
  PipePair({required super.position, this.gap = 125, this.speed = 100});

  final double gap;

  final double speed;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addAll([
      Pipes(flippedPipe: true, position: Vector2(0, -gap)),
      Pipes(flippedPipe: false, position: Vector2(0, gap)),
      Coin(position: Vector2.all(0))
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (bloc.state.currentPlayingState == PlayingState.none) {
      return;
    } else if (bloc.state.currentPlayingState == PlayingState.gameOver) {
      return;
    } else if (bloc.state.currentPlayingState == PlayingState.playing) {
      position.x -= speed * dt;
      return;
    }
  }
}
