import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  // Singleton instance
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  // Private constructor
  AudioManager._internal();

  bool _isBgmPlaying = true;

  void playBgm() {
    FlameAudio.bgm.play('8-bit.mp3', volume: 0.2);
    _isBgmPlaying = true;
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
    _isBgmPlaying = false;
  }

  void toggleBgm() {
    if (_isBgmPlaying) {
      stopBgm();
    } else {
      playBgm();
    }
  }

  bool get isBgmPlaying => _isBgmPlaying;
}
