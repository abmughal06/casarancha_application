import 'dart:io';

import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_detail_media.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../models/post_model.dart';

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

              return GestureDetector(
                onTap: () => Get.to(() => PostFullScreenView(
                    post: videoList![index], isPostDetail: false)),
                child: FutureBuilder<String?>(
                  future: videoThumbnail(data.link),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: colorWhite,
                        image: snap.data != null
                            ? DecorationImage(
                                image: FileImage(File(snap.data!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    );
                  },
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
