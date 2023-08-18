import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/home/post_detail_screen.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/text_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../models/post_model.dart';
import '../screens/home/providers/post_provider.dart';
import 'home_screen_widgets/post_detail_media.dart';

class MusicPlayerUrl extends StatefulWidget {
  const MusicPlayerUrl(
      {Key? key,
      required this.musicDetails,
      required this.ontap,
      required this.border,
      this.postModel,
      required this.isPostDetail})
      : super(key: key);
  final MediaDetails musicDetails;
  final Function ontap;
  final double border;
  final PostModel? postModel;
  final bool isPostDetail;

  @override
  State<MusicPlayerUrl> createState() => _MusicPlayerWithFileState();
}

class _MusicPlayerWithFileState extends State<MusicPlayerUrl> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    setAudio();
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event == PlayerState.playing;
        });
      }
    });
    audioPlayer.onDurationChanged.listen((event) {
      if (mounted) {
        setState(() {
          duration = event;
        });
      }
    });
    audioPlayer.onPositionChanged.listen((event) {
      if (mounted) {
        setState(() {
          position = event;
        });
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.pause();
    super.dispose();
  }

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

  Future setAudio() async {
    audioPlayer.setSourceUrl(widget.musicDetails.link);
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        audioPlayer.pause();
        widget.isPostDetail
            ? Get.to(() => PostFullScreenView(
                post: widget.postModel!, isPostDetail: widget.isPostDetail))
            : Get.to(() => PostDetailScreen(postModel: widget.postModel!));
      },
      child: VisibilityDetector(
          key: Key(widget.musicDetails.link),
          onVisibilityChanged: (visibilityInfo) {
            audioPlayer.pause();
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
                    color: color221.withOpacity(0.35),
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
                        isPlaying ? audioPlayer.pause() : audioPlayer.resume();
                        postProvider.countVideoViews(
                            postModel: widget.postModel);
                      },
                      child: SvgPicture.asset(
                        isPlaying ? icMusicPauseBtn : icMusicPlayBtn,
                        width: 35.h,
                        height: 35.h,
                      ),
                    ),
                    widthBox(5.w),
                    Expanded(
                      // flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              overlayShape: SliderComponentShape.noThumb,
                            ),
                            child: Slider(
                              thumbColor: colorF03,
                              activeColor: colorF03,
                              inactiveColor: colorEE5,
                              min: 0.0,
                              max: duration.inSeconds.toDouble() + 1.0,
                              value: position.inSeconds.toDouble() + 1.0,
                              onChanged: (value) async {
                                final position =
                                    Duration(seconds: value.toInt());
                                await audioPlayer.seek(position);
                              },
                            ),
                          ),
                          heightBox(5.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  text: formatTime(position),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: colorWhite,
                                ),
                                TextWidget(
                                  text: formatTime(duration),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: colorWhite,
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
          )),
    );
    //   },
    // );
  }
}

class MusicPlayerTile extends StatefulWidget {
  const MusicPlayerTile(
      {Key? key,
      required this.musicDetails,
      required this.ontap,
      required this.border,
      required this.isMe})
      : super(key: key);
  final MediaDetails musicDetails;
  final Function ontap;
  final double border;
  final bool isMe;

  @override
  State<MusicPlayerTile> createState() => _MusicPlayerTileState();
}

class _MusicPlayerTileState extends State<MusicPlayerTile> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    setAudio();
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event == PlayerState.playing;
        });
      }
    });
    audioPlayer.onDurationChanged.listen((event) {
      if (mounted) {
        setState(() {
          duration = event;
        });
      }
    });
    audioPlayer.onPositionChanged.listen((event) {
      if (mounted) {
        setState(() {
          position = event;
        });
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.pause();
    super.dispose();
  }

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

  Future setAudio() async {
    audioPlayer.setSourceUrl(widget.musicDetails.link);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: colorPrimaryA05,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(
              widget.isMe ? 16.r : 0,
            ),
            bottomRight: Radius.circular(
              widget.isMe ? 0 : 16.r,
            )),
      ),
      alignment: Alignment.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widthBox(
            5.w,
          ),
          GestureDetector(
            onTap: () {
              isPlaying ? audioPlayer.pause() : audioPlayer.resume();
            },
            child: SvgPicture.asset(
              isPlaying ? icMusicPauseBtn : icMusicPlayBtn,
              width: 35,
              height: 35,
            ),
          ),
          widthBox(10.w),
          Expanded(
            // flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    overlayShape: SliderComponentShape.noThumb,
                  ),
                  child: Slider(
                    thumbColor: colorF03,
                    activeColor: colorF03,
                    inactiveColor: colorEE5,
                    min: 0.0,
                    max: duration.inSeconds.toDouble() + 1.0,
                    value: position.inSeconds.toDouble() + 1.0,
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                    },
                  ),
                ),
                heightBox(5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: formatTime(position),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: colorWhite,
                      ),
                      TextWidget(
                        text: formatTime(duration),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: colorWhite,
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
  }
}
