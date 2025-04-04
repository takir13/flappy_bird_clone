import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flappy_bird_clone/bloc/game/game_cubit.dart';
import 'package:flappy_bird_clone/components/coin.dart';
import 'package:flappy_bird_clone/components/pipes.dart';
import 'package:flappy_bird_clone/flappy_bird_clone_game.dart';

class Bird extends SpriteAnimationComponent
    with
        CollisionCallbacks,
        HasGameRef<FlappyBirdCloneGame>,
        FlameBlocReader<GameCubit, GameState> {
  Bird() : super(size: Vector2(60, 80), anchor: Anchor.center);

  final Vector2 _gravity = Vector2(0, 900.0);
  Vector2 _velocity = Vector2(0, 0);
  final Vector2 _jumpValue = Vector2(0, -350);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    var spriteImage = await Flame.images.load('yellow_bird.png');
    final spriteSheet = SpriteSheet(
        image: spriteImage, srcSize: Vector2(52, 43), margin: 2.3, spacing: 5);
    animation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 2);
    anchor = Anchor.center;
    add(RectangleHitbox(
        size: Vector2(size.x * 0.6, size.y * 0.85),
        anchor: Anchor.center,
        position: (size / 2) * 0.99));
    // debugMode = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (bloc.state.currentPlayingState == PlayingState.none) {
      return;
    } else if (bloc.state.currentPlayingState == PlayingState.gameOver) {
      animation?.loop = false;
      return;
    }
    _velocity += _gravity * dt;
    position += _velocity * dt;
  }

  void jump() {
    if (bloc.state.currentPlayingState != PlayingState.playing) {
      return;
    }
    FlameAudio.play('quack.mp3', volume: 1.5);
    _velocity = _jumpValue;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (bloc.state.currentPlayingState != PlayingState.playing) {
      return;
    }
    if (other is Coin) {
      FlameAudio.play('coin.mp3');
      bloc.increaseCoins();
      other.removeFromParent();
    } else if (other is Pipes) {
      FlameAudio.bgm.stop();
      FlameAudio.play('gameover.mp3');
      bloc.gameOver();
    }
  }
}
