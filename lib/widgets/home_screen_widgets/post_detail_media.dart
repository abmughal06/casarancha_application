import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/media_details.dart';
import '../../resources/color_resources.dart';
import '../music_player_url.dart';
import '../text_widget.dart';
import '../video_player_Url.dart';

class CheckMediaAndShowPost extends StatelessWidget {
  const CheckMediaAndShowPost(
      {Key? key,
      required this.mediaData,
      required this.postId,
      this.iniializedFuturePlay,
      required this.ondoubleTap})
      : super(key: key);

  final MediaDetails mediaData;
  final Future<void>? iniializedFuturePlay;
  final String postId;
  final VoidCallback ondoubleTap;

  @override
  Widget build(BuildContext context) {
    switch (mediaData.type) {
      case "Photo":
        return InkWell(
            onDoubleTap: ondoubleTap,
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, progress) => Center(
                        child: SizedBox(
                          height: 30.h,
                          child: const CircularProgressIndicator(),
                        ),
                      ),
                  imageUrl: mediaData.link),
            ));

      case "Video":
        return FutureBuilder(
          future: iniializedFuturePlay,
          builder: (context, snap) {
            return InkWell(
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: VideoPlayerWidget(
                  videoUrl: mediaData.link,
                  postId: postId,
                ),
              ),
            );
          },
        );
      case "Music":
        return AspectRatio(
          aspectRatio: 13 / 9,
          child: MusicPlayerUrl(
            musicDetails: mediaData,
            ontap: () {},
          ),
        );

      default:
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(
            left: 40,
            right: 40,
            top: 110,
            bottom: 20,
          ),
          child: SingleChildScrollView(
            child: TextWidget(
              text: mediaData.link,
              textAlign: TextAlign.left,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: color221,
            ),
          ),
        );
    }
  }
}
