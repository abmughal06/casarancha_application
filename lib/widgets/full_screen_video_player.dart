import 'package:casarancha/resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:native_video_view/native_video_view.dart';

class FullScreenVideoPlayer extends StatelessWidget {
  const FullScreenVideoPlayer({super.key, required this.videoLink});
  final String videoLink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: colorWhite),
      ),
      body: SafeArea(
        child: Center(
          child: NativeVideoView(
            useExoPlayer: false,
            showMediaController: true,
            enableVolumeControl: true,
            keepAspectRatio: false,
            onCreated: (controller) {
              controller.setVideoSource(videoLink,
                  sourceType: VideoSourceType.network);
              controller.play();
            },
            onPrepared: (con, info) {},
            onCompletion: (con) {},
          ),
        ),
      ),
    );
  }
}
