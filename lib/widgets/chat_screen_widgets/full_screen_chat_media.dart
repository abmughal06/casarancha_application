import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/media_details.dart';
import '../../resources/color_resources.dart';
import '../custom_dialog.dart';
import '../music_player_url.dart';
import '../video_player.dart';

class CheckMediaAndShow extends StatelessWidget {
  const CheckMediaAndShow({
    super.key,
    required this.mediaData,
    this.iniializedFuturePlay,
  });

  final MediaDetails mediaData;
  final Future<void>? iniializedFuturePlay;

  @override
  Widget build(BuildContext context) {
    switch (mediaData.type) {
      case "InChatPic":
        return CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) => Center(
                  child: SizedBox(
                    height: 30.h,
                    child: const CircularProgressIndicator.adaptive(),
                  ),
                ),
            imageUrl: mediaData.link);
      case "Photo":
        return CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) => Center(
                  child: SizedBox(
                    height: 30.h,
                    child: const CircularProgressIndicator.adaptive(),
                  ),
                ),
            imageUrl: mediaData.link);

      case "InChatVideo":
        return VideoPlayerWidget(
          videoUrl: mediaData.link,
          media: mediaData,
        );
      case "Video":
        return VideoPlayerWidget(
          videoUrl: mediaData.link,
          media: mediaData,
        );
      case "InChatMusic":
        return MusicPlayerUrl(
          isPostDetail: false,
          border: 0,
          musicDetails: mediaData,
          ontap: () {},
        );
      case "Music":
        return MusicPlayerUrl(
          isPostDetail: false,
          border: 0,
          musicDetails: mediaData,
          ontap: () {},
        );

      default:
        return const Center(
          child: TextWidget(
            text: 'Error Loading media',
            color: colorWhite,
          ),
        );
    }
  }
}

class ChatMediaWidget extends StatelessWidget {
  const ChatMediaWidget({
    super.key,
    required this.media,
  });

  final List<MediaDetails> media;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: media
          .map(
            (e) => Stack(
              children: [
                CheckMediaAndShow(
                  mediaData: e,
                ),
                Visibility(
                  visible: media.length > 1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: media
                            .map(
                              (i) => Container(
                                height: 8.h,
                                width: 8.h,
                                margin: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i.id != e.id
                                      ? colorDD9.withOpacity(0.3)
                                      : colorFF7,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
          .toList(),
      options: CarouselOptions(
        aspectRatio: 9 / 16,
        viewportFraction: 1,
        enableInfiniteScroll: false,
      ),
    );
  }
}

class ChatMediaFullScreenView extends StatelessWidget {
  const ChatMediaFullScreenView({super.key, required this.media});
  final List<MediaDetails> media;

  @override
  Widget build(BuildContext context) {
    // printLog(media.toString());
    var link = media.map((e) => e.link).join(", ");
    var name = media.map((e) => e.name).join(", ");
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: colorWhite),
      ),
      body: InkWell(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (c) => CustomDownloadDialog(
              path: name,
              url: link,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: ChatMediaWidget(
            media: media,
          ),
        ),
      ),
    );
  }
}
