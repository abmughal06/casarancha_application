import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_input_field.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../models/post_model.dart';
import '../resources/color_resources.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget(
      {Key? key,
      required this.videoUrl,
      this.postModel,
      this.isPostDetailScreen = false,
      this.groupId})
      : super(key: key);
  final String? videoUrl;
  final PostModel? postModel;
  final bool? isPostDetailScreen;

  final String? groupId;
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;
  bool isVisible = false;

  late ChewieController chewieController;
  late Future<void>? initializeVideoPlayer;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;
  bool showControlls = true;

  void checkIfVideoPlaying() {
    if (isPlaying) {
      showControlls = true;
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            showControlls = false;
          });
        }
      });
    } else {
      showControlls = true;
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.videoUrl != null) {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        widget.videoUrl!,
      ))
        ..initialize().then((value) {
          if (mounted) {
            setState(() {});
          }
        });
      videoPlayerController.setVolume(0.0); // Mute the video initially
      videoPlayerController.setLooping(true);
    }

    videoPlayerController.addListener(() {
      duration = videoPlayerController.value.duration;
      position = videoPlayerController.value.position;
      isPlaying = videoPlayerController.value.isPlaying;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    return VisibilityDetector(
      key: ValueKey(widget.videoUrl!),
      onVisibilityChanged: (visibilityInfo) {
        isVisible = visibilityInfo.visibleFraction > 0.6;
        if (isVisible) {
          postProvider.countVideoViews(
            postModel: widget.postModel,
            groupId: widget.groupId,
          );
          videoPlayerController.play();
          videoPlayerController.setVolume(0.0);
          // toggleControls();
        } else {
          videoPlayerController.pause();
          videoPlayerController.setVolume(0.0);
        }
      },
      child: GestureDetector(
        onTap: () {
          if (isPlaying) {
            videoPlayerController.pause();
          } else {
            videoPlayerController.play();
          }
        },
        onLongPress: () {
          videoPlayerController.pause();
        },
        onLongPressEnd: (c) {
          videoPlayerController.play();
        },
        child: Center(
          child: videoPlayerController.value.isInitialized
              ? Stack(
                  children: [
                    VideoPlayer(videoPlayerController),
                    Container(
                      color: isPlaying
                          ? Colors.transparent
                          : Colors.black.withOpacity(0.3),
                    ),
                    AnimatedOpacity(
                      opacity: isPlaying ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            if (isPlaying) {
                              videoPlayerController.pause();
                            } else {
                              videoPlayerController.play();
                            }
                          },
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: isPlaying
                                ? SvgPicture.asset(
                                    icVideoPauseBtn,
                                    height: 45.h,
                                    width: 45.h,
                                  )
                                : SvgPicture.asset(
                                    icVideoPlayBtn,
                                    height: 45.h,
                                    width: 45.h,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: widget.isPostDetailScreen! ? 50.h : 15.h,
                      right: 15.w,
                      child: TextWidget(
                        text: formatTime(duration - position),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colorWhite,
                        shadow: [
                          Shadow(
                            blurRadius: 3.0,
                            color: colorBlack.withOpacity(0.5),
                          ),
                          Shadow(
                            blurRadius: 8.0,
                            color: colorBlack.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 25.h,
                      right: 15.w,
                      child: GestureDetector(
                        onTap: () {
                          if (videoPlayerController.value.volume == 0.0) {
                            videoPlayerController.setVolume(1.0);
                          } else {
                            videoPlayerController.setVolume(0.0);
                          }
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: videoPlayerController.value.volume == 0.0
                              ? SvgPicture.asset(
                                  icVideoSoundOff,
                                  height: 22.h,
                                  width: 22.h,
                                )
                              : SvgPicture.asset(
                                  icVideoSoundOn,
                                  height: 22.h,
                                  width: 22.h,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.h,
                      left: 15.w,
                      right: 15.w,
                      child: SizedBox(
                        height: 30,
                        child: SliderTheme(
                          data: SliderThemeData(
                            overlayShape: SliderComponentShape.noThumb,
                            thumbShape: SliderComponentShape.noThumb,
                            trackHeight: 1.h,
                          ),
                          child: Slider(
                            thumbColor: Colors.transparent,
                            activeColor: colorWhite,
                            inactiveColor: color55F,
                            min: 0.0,
                            max: duration.inMilliseconds.toDouble(),
                            value: position.inMilliseconds.toDouble(),
                            onChanged: (value) async {
                              final position =
                                  Duration(milliseconds: value.toInt());
                              await videoPlayerController.seekTo(position);
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Container(
                  color: colorBlack.withOpacity(0.04),
                ),
        ),
      ),
    );
  }
}
