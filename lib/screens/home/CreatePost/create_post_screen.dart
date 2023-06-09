import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:casarancha/resources/image_resources.dart';

import 'package:casarancha/screens/home/CreatePost/create_post_controller.dart';
import 'package:casarancha/utils/app_constants.dart';

import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:casarancha/widgets/primary_tabbar.dart';
import 'package:casarancha/widgets/primary_textButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:video_player/video_player.dart';

import '../../../resources/color_resources.dart';
import '../../../resources/localization_text_strings.dart';

import '../../../widgets/common_button.dart';
import '../../../widgets/common_widgets.dart';

import '../../../widgets/text_widget.dart';
import 'new_post_share.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({Key? key, this.groupId}) : super(key: key);
  final String? groupId;

  final CreatePostController createPostController =
      Get.put(CreatePostController());

  final List<Widget> _createPostTabs = const [
    Tab(text: strQuote),
    Tab(text: 'Photo'),
    Tab(text: 'Video'),
    Tab(text: strMusic),
  ];

  Widget musicTitle({required double width, required String title}) {
    return Container(
      height: 45.h,
      width: width,
      decoration: BoxDecoration(
        color: colorFF4,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextWidget(
            text: title,
            color: color887,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _createPostTabs.length,
      child: Scaffold(
        appBar: primaryAppbar(
          elevation: 1,
          title: 'Create Post',
          bottom: primaryTabBar(
            tabs: _createPostTabs,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  //Quote
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.w,
                    ),
                    child: TextField(
                      controller: createPostController.quoteTextController,
                      style: const TextStyle(
                        backgroundColor: Colors.transparent,
                        fontSize: 25,
                        height: 1.6,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      maxLength: 2000,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Write Quote',
                      ),
                      textInputAction: TextInputAction.newline,
                    ),
                  ),

                  //Photo Tab

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.w,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        PrimaryTextButton(
                          onPressed: createPostController.getPhoto,
                          title: 'Add Photos',
                          icon: SvgPicture.asset(
                            icAddPostRed,
                          ),
                        ),
                        heightBox(10.w),
                        Expanded(
                          child: Obx(
                            () => ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(bottom: 100.w),
                              itemCount: createPostController.photosList.length,
                              itemBuilder: (context, index) {
                                final photoFile =
                                    createPostController.photosList[index];
                                return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 10.w,
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 2 / 3,
                                      child: Center(
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                10.r,
                                              ),
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    10.r,
                                                  ),
                                                ),
                                                child: Image.file(
                                                  photoFile,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              Positioned(
                                                top: 2,
                                                left: 2,
                                                child: IconButton(
                                                  onPressed: () {
                                                    createPostController
                                                        .removePhotoFile(
                                                            photoFile);
                                                  },
                                                  icon: SvgPicture.asset(
                                                    icRemovePost,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  //Video Tab
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.w,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        PrimaryTextButton(
                          onPressed: createPostController.getVideo,
                          title: 'Add Videos',
                          icon: SvgPicture.asset(
                            icAddPostRed,
                          ),
                        ),
                        heightBox(10.w),
                        Expanded(
                          child: Obx(
                            () => ListView.builder(
                              itemCount: createPostController.videosList.length,
                              itemBuilder: (context, index) {
                                final videoFile =
                                    createPostController.videosList[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 10.w,
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 2 / 3,
                                    child: Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            10.r,
                                          ),
                                        ),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                10.r,
                                              ),
                                            ),
                                            child: VideoPlayerWithFile(
                                              videoFile: videoFile,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              onPressed: () {
                                                createPostController
                                                    .removeVideoFile(videoFile);
                                              },
                                              icon: SvgPicture.asset(
                                                icRemovePost,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Music Tab

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.w,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        PrimaryTextButton(
                          onPressed: createPostController.getMusic,
                          title: 'Add Music',
                          icon: SvgPicture.asset(
                            icAddPostRed,
                          ),
                        ),
                        heightBox(10.w),
                        Expanded(
                          child: Obx(
                            () => ListView.builder(
                              itemCount: createPostController.musicList.length,
                              itemBuilder: (context, index) {
                                final music =
                                    createPostController.musicList[index];
                                return Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10.r,
                                    ),
                                  ),
                                  child: MusicPlayerWithFile(
                                    musicFile: music,
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 20.w),
                  //   child: Column(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       heightBox(18.h),

                  //       // SizedBox(
                  //       //   height: 500.h,
                  //       //   width: screenSize.width,
                  //       //   child: CustomPaint(
                  //       //     foregroundPainter: CustomNotepadPainter(),
                  //       //     child: TextEditingWidget(
                  //       //       height: screenSize.height,
                  //       //       borderRadius: 0,
                  //       //       hintColor: color887,
                  //       //       hint: "",
                  //       //       textHeight: screenSize.height * .0023,
                  //       //       color: colorFF4,
                  //       //       contentPadding: 0,
                  //       //       textInputType: TextInputType.multiline,
                  //       //       maxLines: 14,
                  //       //       maxLength: 500,
                  //       //       textInputAction: TextInputAction.done,
                  //       //       onEditingComplete: () =>
                  //       //           FocusScope.of(context).unfocus(),
                  //       //     ),
                  //       //   ),
                  //       // ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            CommonButton(
              text: 'Continue',
              height: 58.w,
              verticalOutMargin: 25.h,
              horizontalOutMargin: 30.w,
              onTap: () {
                Get.to(
                  () => NewPostShareScreen(
                    createPostController: createPostController,
                    groupId: groupId,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWithFile extends StatefulWidget {
  const VideoPlayerWithFile({Key? key, required this.videoFile})
      : super(key: key);

  final File videoFile;

  @override
  State<VideoPlayerWithFile> createState() => _VideoPlayerWithFileState();
}

class _VideoPlayerWithFileState extends State<VideoPlayerWithFile> {
  late VideoPlayerController videoPlayerController;
  bool isLoadingVideo = true;
  bool isPlayingVideo = false;
  @override
  void initState() {
    videoPlayerController = VideoPlayerController.file(
      widget.videoFile,
    );
    videoPlayerController.initialize().then((value) {
      setState(() {
        isLoadingVideo = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoPlayer(
          videoPlayerController,
        ),
        Center(
          child: isLoadingVideo
              ? const CircularProgressIndicator.adaptive()
              : Container(),
        ),
        if (!isLoadingVideo)
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              onPressed: () async {
                if (isPlayingVideo) {
                  await videoPlayerController.pause();
                  isPlayingVideo = false;
                } else {
                  await videoPlayerController.play();
                  isPlayingVideo = true;
                }
                setState(() {});
              },
              icon: Icon(
                isPlayingVideo
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_fill_rounded,
              ),
            ),
          )
      ],
    );
  }
}

class MusicPlayerWithFile extends StatefulWidget {
  const MusicPlayerWithFile({Key? key, required this.musicFile})
      : super(key: key);
  final File musicFile;

  @override
  State<MusicPlayerWithFile> createState() => _MusicPlayerWithFileState();
}

class _MusicPlayerWithFileState extends State<MusicPlayerWithFile> {
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
    audioPlayer.setSourceDeviceFile(widget.musicFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 13 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10.r,
          ),
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
    );
  }
}
