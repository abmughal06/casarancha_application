import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../models/post_model.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key, required this.videoUrl, this.postModel})
      : super(key: key);
  final String videoUrl;
  final PostModel? postModel;
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

    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

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
      looping: true,
      allowMuting: true,
      showControls: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (visibilityInfo) {
        isVisible = visibilityInfo.visibleFraction > 0.6;
        if (isVisible) {
          postProvider.countVideoViews(postModel: widget.postModel);
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
