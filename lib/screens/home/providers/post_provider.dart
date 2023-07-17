import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// class PostProvider extends ChangeNotifier {
//   AudioPlayer audioPlayer = AudioPlayer();
//   String audioState = '';
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;
//   // bool isVisible = false;

//   var playing = "Playing";
//   var stopped = "Stopped";
//   var paused = "Paused";

//   void initialAudio() {
//     audioPlayer.onPlayerStateChanged.listen((event) {
//       if (event == PlayerState.stopped) {
//         audioState = stopped;
//       }
//       if (event == PlayerState.playing) {
//         audioState = playing;
//       }
//       if (event == PlayerState.paused) {
//         audioState = paused;
//       }
//       notifyListeners();
//     });
//     audioPlayer.onDurationChanged.listen((event) {
//       duration = event;
//       notifyListeners();
//     });
//     audioPlayer.onPositionChanged.listen((event) {
//       position = event;
//       notifyListeners();
//     });
//   }

//   void listenToChangeFrame(isVisible) {
//     if (isVisible) {
//       audioPlayer.pause();
//       audioPlayer.setVolume(0.0);
//       notifyListeners();
//     } else {
//       audioPlayer.pause();
//       audioPlayer.setVolume(0.0);
//       notifyListeners();
//     }
//   }

//   void listentoPosition() {
//     if (audioState == playing) {
//       audioPlayer.pause();
//       audioPlayer.setVolume(0.0);
//     }
//     if (audioState == paused) {
//       audioPlayer.resume();
//       audioPlayer.setVolume(1.0);
//     }
//     notifyListeners();
//   }

//   void disposeAudiPlayer() {
//     audioPlayer.pause();
//   }

//   Future setAudio(musicUrl) async {
//     await audioPlayer.setSourceUrl(musicUrl);
//   }

//   String formatTime(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));

//     return [
//       if (duration.inHours > 0) hours,
//       minutes,
//       seconds,
//     ].join(':');
//   }
// }

// audio_model.dart

class PostProvider with ChangeNotifier {
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState _audioState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String musicUrl = '';

  PostProvider() {
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
      resume();
    } else {
      pause();
    }
    notifyListeners();
  }
}
