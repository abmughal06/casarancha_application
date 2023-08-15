import 'package:audioplayers/audioplayers.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/text_widget.dart';

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
      this.postModel})
      : super(key: key);
  final MediaDetails musicDetails;
  final Function ontap;
  final double border;
  final PostModel? postModel;

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

    return VisibilityDetector(
        key: Key(widget.musicDetails.link),
        onVisibilityChanged: (visibilityInfo) {
          var isVisible = visibilityInfo.visibleFraction > 0.5;
          if (isVisible) {
            audioPlayer.pause();
          } else {
            audioPlayer.pause();
          }
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
                      isPlaying ? audioPlayer.pause() : audioPlayer.resume();
                      postProvider.countVideoViews(postModel: widget.postModel);
                    },
                    child: SvgPicture.asset(
                      isPlaying ? icMusicPauseBtn : icMusicPlayBtn,
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
                            max: duration.inSeconds.toDouble() + 1.0,
                            value: position.inSeconds.toDouble() + 1.0,
                            onChanged: (value) async {
                              final position = Duration(seconds: value.toInt());
                              await audioPlayer.seek(position);
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
                                  position,
                                ),
                              ),
                              Text(
                                formatTime(
                                  duration,
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
        color: !widget.isMe ? colorFF3 : colorF03.withOpacity(0.6),
        borderRadius: BorderRadius.circular(widget.border),
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
              color: Colors.grey.shade800,
              width: 35,
              height: 35,
            ),
          ),
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
                    max: duration.inSeconds.toDouble() + 1.0,
                    value: position.inSeconds.toDouble() + 1.0,
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: formatTime(
                          position,
                        ),
                        fontSize: 11.sp,
                      ),
                      TextWidget(
                        text: formatTime(
                          duration,
                        ),
                        fontSize: 11.sp,
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
