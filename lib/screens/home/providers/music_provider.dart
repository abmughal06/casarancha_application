import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicProvider with ChangeNotifier {
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState _audioState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String musicUrl = '';

  MusicProvider() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      _audioState = state;
      notifyListeners();
    });

    audioPlayer.onPositionChanged.listen((position) {
      _position = position;
      notifyListeners();
    });

    audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
      notifyListeners();
    });
  }

  PlayerState get audioState => _audioState;
  Duration get position => _position;
  Duration get duration => _duration;

  void play(String url) async {
    await audioPlayer.setSourceUrl(url);
  }

  void resume() async {
    await audioPlayer.resume();
    notifyListeners();
  }

  void pause() async {
    await audioPlayer.pause();
    notifyListeners();
  }

  void stop() async {
    await audioPlayer.stop();
    notifyListeners();
  }

  void listenToFrameChange(isVisible) {
    if (isVisible) {
      pause();
    } else {
      pause();
    }
    notifyListeners();
  }
}
