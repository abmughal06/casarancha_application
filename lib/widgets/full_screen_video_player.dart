import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/widgets/video_player.dart';
import 'package:flutter/material.dart';

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
            child: CustomVideoPlayer(
          videoUrl: videoLink,
          videoAspectRatio: 9 / 16,
          isPostDetail: false,
          onVisible: () {},
        )),
      ),
    );
  }
}
