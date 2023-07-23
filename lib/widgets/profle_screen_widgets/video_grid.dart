import 'package:casarancha/widgets/text_widget.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../models/post_model.dart';
import 'full_screen_video.dart';

class VideoGridView extends StatelessWidget {
  const VideoGridView({Key? key, required this.videoList}) : super(key: key);

  final List<PostModel>? videoList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: videoList!.isNotEmpty &&
              videoList!.map((e) => e.mediaData).isNotEmpty,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
            ),
            itemCount: videoList!.length,
            itemBuilder: (context, index) {
              final data = videoList![index].mediaData[0];
              VideoPlayerController videoPlayerController =
                  VideoPlayerController.network(data.link);

              return GestureDetector(
                onTap: () => Get.to(() => FullScreenVideo(
                      videoPlayerController: videoPlayerController,
                      postId: videoList![index].id,
                      creatorId: videoList![index].creatorId,
                    )),
                child: Container(
                  color: Colors.black,
                  child: FutureBuilder(
                    future: videoPlayerController.initialize(),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return Container(
                          decoration:
                              BoxDecoration(color: Colors.grey.shade200),
                        );
                      }
                      final chwie = ChewieController(
                        videoPlayerController: videoPlayerController,
                        showControls: false,
                        autoPlay: false,
                        autoInitialize: true,
                      );
                      return Chewie(
                        controller: chwie,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Visibility(
          visible:
              videoList!.isEmpty && videoList!.map((e) => e.mediaData).isEmpty,
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
