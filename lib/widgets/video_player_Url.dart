import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key, required this.videoUrl, this.postId})
      : super(key: key);
  final String videoUrl;
  final String? postId;
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;
  bool isVisible = false;

  late ChewieController chewieController;
  @override
  void initState() {
    super.initState();

    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    // countVideoViews();

    videoPlayerController.setVolume(0.0); // Mute the video initially

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      showOptions: false,
      autoPlay: false,
      allowPlaybackSpeedChanging: true,
      autoInitialize: true,
      showControlsOnInitialize: true,
      allowFullScreen: true,
      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.portraitUp],
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      aspectRatio: 9 / 16,
      looping: false,
      allowMuting: true,
      showControls: true,
    );
  }

  countVideoViews() async {
    var postRef =
        FirebaseFirestore.instance.collection("posts").doc(widget.postId);
    var data = await postRef.get();
    if (data.data()!.containsKey("viedoViews")) {
      List viwers = data.data()!['videoViews'];
      if (viwers.contains(FirebaseAuth.instance.currentUser!.uid)) {
      } else {
        postRef.update({
          "videoViews":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        });
      }
    } else {
      postRef.update({
        "videoViews":
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (visibilityInfo) {
        isVisible = visibilityInfo.visibleFraction > 0.6;
        if (isVisible) {
          videoPlayerController.play();
          videoPlayerController.setVolume(0.0);
        } else {
          videoPlayerController.pause();
          videoPlayerController.setVolume(0.0);
        }
      },
      child: Chewie(controller: chewieController),
    );
  }
}
