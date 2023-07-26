import 'dart:io';

import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../models/post_model.dart';
import 'full_screen_video.dart';

class VideoGridView extends StatelessWidget {
  const VideoGridView({Key? key, required this.videoList}) : super(key: key);

  final List<PostModel>? videoList;

  Future<String?> videoThumbnail(value) async {
    return await VideoThumbnail.thumbnailFile(
      video: value,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 1024,
      maxWidth: 1024,
      quality: 10,
    );
  }

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
                  color: Colors.white,
                  child: FutureBuilder<String?>(
                    future: videoThumbnail(data.link),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      return Image.file(
                        File(snap.data!),
                        fit: BoxFit.cover,
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
