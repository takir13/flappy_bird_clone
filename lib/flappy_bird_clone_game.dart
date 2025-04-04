import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flappy_bird_clone/bloc/game/game_cubit.dart';
import 'package:flappy_bird_clone/components/audio_manager.dart';
import 'package:flappy_bird_clone/components/bird.dart';
import 'package:flappy_bird_clone/components/pipes.dart';
import 'package:flutter/foundation.dart';

class FlappyBirdCloneGame extends FlameGame<FlappyBirdCloneWorld>
    with HasCollisionDetection {
  FlappyBirdCloneGame(this.gameCubit) : super(world: FlappyBirdCloneWorld());

  final GameCubit gameCubit;
  

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    AudioManager audioManager = AudioManager();
    // debugPrint('${audioManager.isBgmPlaying}');
    if (audioManager.isBgmPlaying) {
        audioManager.playBgm();
    }
    

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('No user is signed in!');
        gameCubit.signInScreen();
      } else {
        debugPrint('User is signed in anonymously with UID: ${user.uid}');
      }
    });
  }
}

//World Class
class FlappyBirdCloneWorld extends World
    with TapCallbacks, HasGameRef<FlappyBirdCloneGame> {
  late FlappyBirdCloneRootComponent _rootComponent;
  late TapDownEvent event;

  @override
  void onLoad() {
    super.onLoad();
    add(FlameBlocProvider<GameCubit, GameState>(
        create: () => game.gameCubit,
        children: [_rootComponent = FlappyBirdCloneRootComponent()]));
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _rootComponent.onTapDown(event);
  }
}

class WorldBackground extends ParallaxComponent<FlappyBirdCloneGame>
    with FlameBlocReader<GameCubit, GameState> {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    parallax = await game.loadParallax([ParallaxImageData('sky.png')],
        baseVelocity: Vector2(75, 0));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (bloc.state.currentPlayingState == PlayingState.gameOver) {
      parallax?.baseVelocity = Vector2.all(0);
    }
  }
}

class FlappyBirdCloneRootComponent extends Component
    with
        HasGameRef<FlappyBirdCloneGame>,
        FlameBlocReader<GameCubit, GameState> {
  late Bird _bird;
  late PipePair _lastPipe;
  late TextComponent _totalCoins;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(WorldBackground());
    _generatePipes();
    add(_bird = Bird());
    game.camera.viewfinder.add(_totalCoins = TextComponent(
        anchor: Anchor.topCenter,
        position: Vector2(0, -(game.size.y / 2) + 10),
        size: Vector2.all(50)));

    //  game.camera.viewfinder.zoom = 0.05;
  }

  void _generatePipes({double distance = 250}) {
    for (var i = 1; i < 5; i++) {
      const area = 600;
      final y = (Random().nextDouble() * area) - (area / 2);
      add(_lastPipe = PipePair(position: Vector2(i * distance, y)));
    }
  }

  void _removePipes() {
    final pipes = children.whereType<PipePair>();
    final remove = max(pipes.length - 5, 0);
    pipes.take(remove).forEach((pipe) {
      pipe.removeFromParent();
    });
  }

  void onTapDown(TapDownEvent event) {
    tapToStart();
    _bird.jump();
  }

  void tapToStart() {
    if (bloc.state.currentPlayingState == PlayingState.none) {
      bloc.startPlaying();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (bloc.state.currentPlayingState == PlayingState.playing) {
      _totalCoins.text = "Coins: ${bloc.state.currentCoins}";
    }

    if (_bird.x >= _lastPipe.x) {
      _generatePipes();
    }
    _removePipes();
  }
}
