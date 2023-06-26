import 'package:audioplayers/audioplayers.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/common_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MusicPlayerUrl extends StatefulWidget {
  const MusicPlayerUrl(
      {Key? key, required this.musicDetails, required this.ontap})
      : super(key: key);
  final MediaDetails musicDetails;
  final Function ontap;

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
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.pause();
    audioPlayer.dispose();
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

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.musicDetails.link),
      onVisibilityChanged: (visibilityInfo) {
        setState(() {
          isVisible = visibilityInfo.visibleFraction > 0.5;
          if (isVisible) {
            audioPlayer.pause();
            // isPlaying = true;
            audioPlayer.setVolume(0.0);
          } else {
            audioPlayer.pause();
            // isPlaying = false;
            audioPlayer.setVolume(0.0);
          }
        });
      },
      child: InkWell(
        onTap: () async {
          await audioPlayer.pause();
          widget.ontap;
        },
        child: AspectRatio(
          aspectRatio: 13 / 9,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      musicImgUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.3)),
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
                        if (isPlaying) {
                          audioPlayer.pause();
                          audioPlayer.setVolume(0.0);
                        } else {
                          audioPlayer.resume();
                          audioPlayer.setVolume(1.0);
                        }
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
                                final position =
                                    Duration(seconds: value.toInt());
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
          ),
        ),
      ),
    );
  }
}
