// // import 'package:audioplayers/audioplayers.dart';
// // import 'package:flutter/material.dart';

// // class MusicProvider extends ChangeNotifier {
// //   AudioPlayer audioPlayer = AudioPlayer();
// //   PlayerState _audioState = PlayerState.stopped;
// //   Duration _position = Duration.zero;
// //   Duration _duration = Duration.zero;
// //   bool isPlaying = false;
// //   // String musicUrl = '';
// //   // List<String> musicUrls = [];
// //   // int currentIndex = 0;

// //   // changeIndex(c) {
// //   //   currentIndex = c;
// //   //   notifyListeners();
// //   // }

// //   listenToStateChange(url) async {
// //     await audioPlayer.setSourceUrl(url);

// //     audioPlayer.onPlayerStateChanged.listen((state) {
// //       _audioState = state;
// //       isPlaying = state == PlayerState.playing;
// //       notifyListeners();
// //     });

// //     audioPlayer.onPositionChanged.listen((position) {
// //       _position = position;
// //       notifyListeners();
// //     });

// //     audioPlayer.onDurationChanged.listen((duration) {
// //       _duration = duration;
// //       notifyListeners();
// //     });
// //   }

// //   PlayerState get audioState => _audioState;
// //   Duration get position => _position;
// //   Duration get duration => _duration;

// //   void resume() async {
// //     await audioPlayer.resume();
// //     notifyListeners();
// //   }

// //   void pause() async {
// //     await audioPlayer.pause();
// //     notifyListeners();
// //   }

// //   void stop() async {
// //     await audioPlayer.stop();
// //     notifyListeners();
// //   }

// //   void listenToFrameChange(isVisible) {
// //     if (isVisible) {
// //       pause();
// //     } else {
// //       pause();
// //     }
// //     // notifyListeners();
// //   }
// // }

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';

// enum PlaybackState { stopped, playing, paused }

// class MusicProvider extends ChangeNotifier {
//   AudioPlayer audioPlayer = AudioPlayer();
//   PlaybackState _playbackState = PlaybackState.stopped;
//   PlaybackState get playbackState => _playbackState;

//   void play() {
//     _playbackState = PlaybackState.playing;
//     notifyListeners();
//     // Implement audio or video playback logic here
//   }

//   void pause() {
//     _playbackState = PlaybackState.paused;
//     notifyListeners();
//     // Pause audio or video playback logic here
//   }

//   void stop() {
//     _playbackState = PlaybackState.stopped;
//     notifyListeners();
//     // Stop audio or video playback logic here
//   }

//   void updateState() {
//     notifyListeners();
//   }
// }
