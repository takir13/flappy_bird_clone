import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird_clone/bloc/game/game_cubit.dart';
import 'package:flappy_bird_clone/firebase_options.dart';
import 'package:flappy_bird_clone/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlameAudio.bgm.initialize();
  FlameAudio.audioCache
    .loadAll(['8-bit.mp3', 'coin.mp3', 'quack.mp3', 'gameover.mp3']);
  
  Flame.device.fullScreen();
  Flame.device.setPortraitUpOnly();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => GameCubit(),
        child: const MaterialApp(title: "Flappy Bird Clone", home: MainPage()));
  }
}
