import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../models/post_model.dart';
import 'full_screen_video.dart';

class VideoGridView extends StatefulWidget {
  const VideoGridView({Key? key, required this.videoList}) : super(key: key);

  final List<PostModel>? videoList;

  @override
  State<VideoGridView> createState() => _VideoGridViewState();
}

class _VideoGridViewState extends State<VideoGridView> {
  late VideoPlayerController videoPlayerController;

  @override
  initState() {
    initVideo();
    super.initState();
  }

  initVideo() {
    widget.videoList!.map((e) {
      videoPlayerController = VideoPlayerController.network(e.mediaData[0].link)
        ..initialize().then((value) {
          setState(() {});
          videoPlayerController.play();
          videoPlayerController.setVolume(0);
        });
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: widget.videoList!.isNotEmpty &&
              widget.videoList!.map((e) => e.mediaData).isNotEmpty,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
            ),
            itemCount: widget.videoList!.length,
            itemBuilder: (context, index) {
              // final data = widget.videoList![index].mediaData[0];
              // print(quote);
              // VideoPlayerController videoPlayerController =
              //     VideoPlayerController.network(data.link);
              // videoPlayerController.initialize().whenComplete(() {
              //   log("video is initialized");
              //   // provider.initializeVideoPlayer();
              // });
              // videoPlayerController.pause();

              return GestureDetector(
                  onTap: () => Get.to(() => FullScreenVideo(
                        videoPlayerController: videoPlayerController,
                        postId: widget.videoList![index].id,
                        creatorId: widget.videoList![index].creatorId,
                      )),
                  child: videoPlayerController.value.isInitialized
                      ? VideoPlayer(videoPlayerController)
                      : Container(
                          decoration:
                              BoxDecoration(color: Colors.grey.shade200)));
            },
          ),
        ),
        Visibility(
          visible: widget.videoList!.isEmpty &&
              widget.videoList!.map((e) => e.mediaData).isEmpty,
          child: const Center(
            child: TextWidget(
              text: "No Videos are available to show",
            ),
          ),
        )
      ],
    );
  }
}
