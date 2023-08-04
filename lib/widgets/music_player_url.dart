import 'package:audioplayers/audioplayers.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/home/providers/music_provider.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/common_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../models/post_model.dart';
import '../screens/home/providers/post_provider.dart';

class MusicPlayerUrl extends StatefulWidget {
  const MusicPlayerUrl(
      {Key? key,
      required this.musicDetails,
      required this.ontap,
      required this.border,
      required this.postModel})
      : super(key: key);
  final MediaDetails musicDetails;
  final Function ontap;
  final double border;
  final PostModel postModel;

  @override
  State<MusicPlayerUrl> createState() => _MusicPlayerWithFileState();
}

class _MusicPlayerWithFileState extends State<MusicPlayerUrl> {
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Consumer<MusicProvider>(builder: (context, provider, b) {
      provider.play(widget.musicDetails.link);
      postProvider.countVideoViews(postModel: widget.postModel);
      return VisibilityDetector(
          key: Key(widget.musicDetails.link),
          onVisibilityChanged: (visibilityInfo) {
            var isVisible = visibilityInfo.visibleFraction > 0.5;
            provider.listenToFrameChange(isVisible);
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.border),
                  image: DecorationImage(
                    image: AssetImage(
                      musicImgUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.border),
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
              Positioned(
                left: 15,
                right: 15,
                bottom: 15,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        provider.audioState == PlayerState.playing
                            ? provider.pause()
                            : provider.resume();
                      },
                      child: SvgPicture.asset(
                        provider.audioState == PlayerState.playing
                            ? icMusicPauseBtn
                            : icMusicPlayBtn,
                        width: 35,
                        height: 35,
                      ),
                    ),
                    widthBox(
                      5.w,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              overlayShape: SliderComponentShape.noOverlay,
                            ),
                            child: Slider.adaptive(
                              thumbColor: Colors.yellow,
                              activeColor: Colors.yellow,
                              min: 0.0,
                              max: provider.duration.inSeconds.toDouble() + 1.0,
                              value:
                                  provider.position.inSeconds.toDouble() + 1.0,
                              onChanged: (value) async {
                                final position =
                                    Duration(seconds: value.toInt());
                                await provider.audioPlayer.seek(position);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatTime(
                                    provider.position,
                                  ),
                                ),
                                Text(
                                  formatTime(
                                    provider.duration,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ));
    });
  }
}

class MusicPlayerTile extends StatefulWidget {
  const MusicPlayerTile(
      {Key? key,
      required this.musicDetails,
      required this.ontap,
      required this.border})
      : super(key: key);
  final MediaDetails musicDetails;
  final Function ontap;
  final double border;

  @override
  State<MusicPlayerTile> createState() => _MusicPlayerTileState();
}

class _MusicPlayerTileState extends State<MusicPlayerTile> {
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(builder: (context, provider, b) {
      provider.play(widget.musicDetails.link);

      return Container(
        height: 120,
        // margin: const EdgeInsets.symmetric(vertical: 25),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: colorF03.withOpacity(0.6),
          borderRadius: BorderRadius.circular(widget.border),
        ),
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // widthBox(
            //   5.w,
            // ),
            Expanded(
              // flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider.adaptive(
                      thumbColor: Colors.orange,
                      activeColor: Colors.red,
                      min: 0.0,
                      max: provider.duration.inSeconds.toDouble() + 1.0,
                      value: provider.position.inSeconds.toDouble() + 1.0,
                      onChanged: (value) async {
                        final position = Duration(seconds: value.toInt());
                        await provider.audioPlayer.seek(position);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatTime(
                            provider.position,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.audioState == PlayerState.playing
                                ? provider.pause()
                                : provider.resume();
                          },
                          child: SvgPicture.asset(
                            provider.audioState == PlayerState.playing
                                ? icMusicPauseBtn
                                : icMusicPlayBtn,
                            color: Colors.grey.shade800,
                            width: 35,
                            height: 35,
                          ),
                        ),
                        Text(
                          formatTime(
                            provider.duration,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
