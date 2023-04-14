import 'package:audioplayers/audioplayers.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/common_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';

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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await audioPlayer.pause();
        widget.ontap;
      },
      child: AspectRatio(
        aspectRatio: 13 / 9,
        child: Container(
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(
            //   10.r,
            // ),
            image: DecorationImage(
              image: AssetImage(
                musicImgUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(
              15.w,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (isPlaying) {
                      audioPlayer.pause();
                    } else {
                      audioPlayer.resume();
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider.adaptive(
                          thumbColor: Colors.yellow,
                          activeColor: Colors.yellow,
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
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
        ),
      ),
    );
  }
}
