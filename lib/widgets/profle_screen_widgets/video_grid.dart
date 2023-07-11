import 'package:casarancha/widgets/text_widget.dart';
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
          visible: videoList!.isNotEmpty,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
            ),
            itemCount: videoList!.length,
            itemBuilder: (context, index) {
              final data = videoList![index].mediaData[0];
              // print(quote);
              VideoPlayerController videoPlayerController =
                  VideoPlayerController.network(data.link);
              videoPlayerController.initialize();
              videoPlayerController.pause();

              return GestureDetector(
                  onTap: () => Get.to(() => FullScreenVideo(
                        videoPlayerController: videoPlayerController,
                        postId: videoList![index].id,
                        creatorId: videoList![index].creatorId,
                      )),
                  child: VideoPlayer(videoPlayerController));
            },
          ),
        ),
        Visibility(
          visible: videoList!.isEmpty,
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
