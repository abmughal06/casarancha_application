import 'package:casarancha/models/media_details.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:video_player/video_player.dart';

class VideoPlayerUrl extends StatefulWidget {
  VideoPlayerUrl({
    Key? key,
    required this.mediaDetails,
    required this.pageIndex,
    this.videoPlayerController,
    this.pageController,
  }) : super(key: key);
  final MediaDetails mediaDetails;
  final int pageIndex;

  PageController? pageController;

  final VideoPlayerController? videoPlayerController;

  @override
  State<VideoPlayerUrl> createState() => _VideoPlayerUrlState();
}

class _VideoPlayerUrlState extends State<VideoPlayerUrl>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? videoPlayerController;

  late ChewieController chewieController;

  @override
  void initState() {
    widget.pageController?.addListener(() {
      setState(() {});
    });
    super.initState();
    if (widget.videoPlayerController == null) {
      videoPlayerController =
          VideoPlayerController.network(widget.mediaDetails.link);
    } else {
      videoPlayerController = widget.videoPlayerController!;
    }
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        showOptions: false,
        autoPlay: false,
        allowPlaybackSpeedChanging: false,
        autoInitialize: true,
        allowFullScreen: false,
        showControlsOnInitialize: false,
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ],
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        aspectRatio: 2 / 3,
        looping: false);
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
        controller:
            chewieController); /* Stack(
      children: [
        (videoPlayerController?.value.isInitialized ?? false)
            ? VideoPlayer(videoPlayerController!)
            : const Center(child: CircularProgressIndicator.adaptive()),
        if (videoPlayerController?.value.isInitialized ?? false)
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              onPressed: () async {
                if (videoPlayerController?.value.isPlaying ?? false) {
                  await videoPlayerController?.pause();
                } else {
                  await videoPlayerController?.play();
                }
              },
              icon: Icon(
                (videoPlayerController?.value.isPlaying ?? false)
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_fill_rounded,
              ),
            ),
          )
      ],
    ); */
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class VideoPlayerWidget extends StatefulWidget {
  VideoPlayerWidget(
      {Key? key, required this.videoUrl, this.videoPlayerController})
      : super(key: key);
  final String videoUrl;
  VideoPlayerController? videoPlayerController;
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? videoPlayerController;

  late ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    if (widget.videoPlayerController == null) {
      videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    } else {
      videoPlayerController = widget.videoPlayerController!;
    }
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        showOptions: false,
        autoPlay: false,
        allowPlaybackSpeedChanging: false,
        autoInitialize: true,
        showControlsOnInitialize: false,
        allowFullScreen: false,
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ],
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        aspectRatio: 2 / 3,
        looping: false);
  }

  // @override
  // void dispose() {
  //   videoPlayerController?.dispose();
  //   chewieController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Chewie(
        controller:
            chewieController); /* Stack(
      children: [
        (videoPlayerController?.value.isInitialized ?? false)
            ? VideoPlayer(videoPlayerController!)
            : const Center(child: CircularProgressIndicator.adaptive()),
        if (videoPlayerController?.value.isInitialized ?? false)
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              onPressed: () async {
                if (videoPlayerController?.value.isPlaying ?? false) {
                  await videoPlayerController?.pause();
                } else {
                  await videoPlayerController?.play();
                }
              },
              icon: Icon(
                (videoPlayerController?.value.isPlaying ?? false)
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_fill_rounded,
              ),
            ),
          )
      ],
    ); */
  }
}
