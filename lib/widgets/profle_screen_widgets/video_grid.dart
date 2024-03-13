import 'package:casarancha/widgets/home_screen_widgets/post_detail_media.dart';
import 'package:casarancha/widgets/shared/video_thumbnail.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../shared/alert_text.dart';

class VideoGridView extends StatelessWidget {
  const VideoGridView({super.key, required this.videoList});

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

              return GestureDetector(
                  onTap: () => Get.to(() => ProfilePostFullScreenView(
                        postsList: videoList!,
                        index: index,
                        postType: appText(context).strVideo,
                        isPostDetail: true,
                      )),
                  child: VideoThumbnailWidget(
                    videoUrl: data.link,
                  ));
            },
          ),
        ),
        Visibility(
          visible:
              videoList!.isEmpty && videoList!.map((e) => e.mediaData).isEmpty,
          child: AlertText(
            text: appText(context).strAlertVideo,
          ),
        )
      ],
    );
  }
}
