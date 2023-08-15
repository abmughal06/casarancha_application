import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:casarancha/screens/home/providers/music_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/media_details.dart';
import '../../resources/color_resources.dart';
import '../music_player_url.dart';
import '../video_player_url.dart';

class CheckMediaAndShow extends StatelessWidget {
  const CheckMediaAndShow({
    Key? key,
    required this.mediaData,
    this.iniializedFuturePlay,
  }) : super(key: key);

  final MediaDetails mediaData;
  final Future<void>? iniializedFuturePlay;

  @override
  Widget build(BuildContext context) {
    switch (mediaData.type) {
      case "Photo":
        return CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) => Center(
                  child: SizedBox(
                    height: 30.h,
                    child: const CircularProgressIndicator.adaptive(),
                  ),
                ),
            imageUrl: mediaData.link);

      case "Video":
        return FutureBuilder(
            future: iniializedFuturePlay,
            builder: (context, snapshot) {
              return VideoPlayerWidget(
                videoUrl: mediaData.link,
              );
            });
      case "Music":
        return ChangeNotifierProvider<MusicProvider>(
          create: (context) => MusicProvider(),
          child: MusicPlayerUrl(
            border: 0,
            musicDetails: mediaData,
            ontap: () {},
          ),
        );

      default:
        return Container();
      // postProvider.countVideoViews(postModel: postModel);
      // return Container(
      //   width: MediaQuery.of(context).size.width,
      //   padding: EdgeInsets.only(
      //     left: isPostDetail ? 20 : 15,
      //     right: isPostDetail ? 20 : 15,
      //     top: isPostDetail ? 110 : 10,
      //     bottom: 20,
      //   ),
      //   child: SingleChildScrollView(
      //     child: TextWidget(
      //       text: mediaData.link,
      //       textAlign: isFullScreen ? TextAlign.center : TextAlign.left,
      //       fontSize: 16.sp,
      //       fontWeight: FontWeight.w500,
      //       color: isFullScreen ? colorFF3 : color221,
      //     ),
      //   ),
      // );
    }
  }
}

double getQouteAspectRatio(String text, bool isPostDetail) {
  if (isPostDetail) {
    if (text.length > 400) {
      return 9 / 13;
    } else {
      return 1 / 1;
    }
  } else {
    if (text.length > 400) {
      return 9 / 13;
    } else {
      return 17 / 9;
    }
  }
}

class ChatMediaWidget extends StatelessWidget {
  const ChatMediaWidget({
    Key? key,
    required this.media,
  }) : super(key: key);

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
        aspectRatio: media[0].type == 'Qoute'
            ? getQouteAspectRatio(media[0].link, false)
            : media[0].type == 'Music'
                ? 13 / 9
                : media[0].type == 'Photo'
                    ? double.parse(media[0].imageWidth!) /
                        double.parse(media[0].imageHeight!)
                    : 9 / 16,
        viewportFraction: 1,
        enableInfiniteScroll: false,
      ),
    );
  }
}

class ChatMediaFullScreenView extends StatelessWidget {
  const ChatMediaFullScreenView({Key? key, required this.media})
      : super(key: key);
  final List<MediaDetails> media;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: colorWhite),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: ChatMediaWidget(
          media: media,
        ),
      ),
    );
  }
}
