import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:casarancha/resources/image_resources.dart';

import 'package:casarancha/screens/home/CreatePost/create_post_controller.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/utils/snackbar.dart';

import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/primary_tabbar.dart';
import 'package:casarancha/widgets/primary_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../resources/color_resources.dart';

import '../../../widgets/common_button.dart';
import '../../../widgets/common_widgets.dart';

import '../../../widgets/text_widget.dart';
import 'new_post_share.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen(
      {super.key,
      this.groupId,
      this.isForum = false,
      this.isGhostPost = false});
  final String? groupId;
  final bool isForum;
  final bool isGhostPost;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
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

  late CreatePostMethods createPost;
  Future<void>? futurePlay;

  @override
  void dispose() {
    createPost.clearLists();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> createPostTabs = [
      Tab(text: appText(context).strQuote),
      Tab(text: appText(context).strPhoto),
      Tab(text: appText(context).strVideo),
      Tab(text: appText(context).strMusic),
    ];
    createPost = Provider.of<CreatePostMethods>(context, listen: false);
    return DefaultTabController(
      length: createPostTabs.length,
      child: Scaffold(
        appBar: primaryAppbar(
          elevation: 1,
          title: widget.isGhostPost
              ? appText(context).strCreateGhostPost
              : widget.isForum
                  ? appText(context).strCreateForumPost
                  : appText(context).strCreatePost,
          bottom: primaryTabBar(
            tabs: createPostTabs,
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
                      controller: createPost.quoteTextController,
                      style: const TextStyle(
                        backgroundColor: Colors.transparent,
                        fontSize: 25,
                        height: 1.6,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      maxLength: 2000,
                      decoration: InputDecoration.collapsed(
                        hintText: appText(context).strWriteQuote,
                      ),
                      textInputAction: TextInputAction.newline,
                    ),
                  ),

                  //Photo Tab

                  widget.isGhostPost
                      ? Center(
                          child: TextWidget(
                            text: appText(context).strAlertGhostPhoto,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.w,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              PrimaryTextButton(
                                onPressed: createPost.getPhoto,
                                title: appText(context).strAddPhotos,
                                icon: SvgPicture.asset(
                                  icAddPostRed,
                                ),
                              ),
                              heightBox(10.w),
                              Expanded(
                                child: Consumer<CreatePostMethods>(
                                  builder: (context, state, b) {
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.only(bottom: 100.w),
                                      itemCount: createPost.photosList.length,
                                      itemBuilder: (context, index) {
                                        final photoFile =
                                            state.photosList[index];
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
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                        10.r,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
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
                                                            state
                                                                .removePhotoFile(
                                                                    photoFile);
                                                          },
                                                          icon:
                                                              SvgPicture.asset(
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
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                  //Video Tab
                  widget.isGhostPost
                      ? Center(
                          child: TextWidget(
                            text: appText(context).strAlertGhostVideo,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.w,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              PrimaryTextButton(
                                onPressed: createPost.getVideo,
                                title: appText(context).strAddVideos,
                                icon: SvgPicture.asset(
                                  icAddPostRed,
                                ),
                              ),
                              heightBox(10.w),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * .5,
                                child: Consumer<CreatePostMethods>(
                                  builder: (context, state, b) {
                                    return ListView.builder(
                                      itemCount: state.videosList.length,
                                      cacheExtent: 10,
                                      itemBuilder: (context, index) {
                                        final videoFile =
                                            state.videosList[index];
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
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                        10.r,
                                                      ),
                                                    ),
                                                    child: VideoPlayerWithFile(
                                                      videoFile: videoFile,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        state.removeVideoFile(
                                                            videoFile);
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
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                  // Music Tab

                  widget.isGhostPost
                      ? Center(
                          child: TextWidget(
                            text: appText(context).strAlertGhostMusic,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.w,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              PrimaryTextButton(
                                onPressed: createPost.getMusic,
                                title: appText(context).strAddMusic,
                                icon: SvgPicture.asset(
                                  icAddPostRed,
                                ),
                              ),
                              heightBox(10.w),
                              Expanded(
                                child: Consumer<CreatePostMethods>(
                                    builder: (context, state, b) {
                                  return ListView.builder(
                                    itemCount: state.musicList.length,
                                    itemBuilder: (context, index) {
                                      final music = state.musicList[index];
                                      log(music.path);
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
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
            CommonButton(
              text: appText(context).strContinue,
              height: 58.w,
              verticalOutMargin: 25.h,
              horizontalOutMargin: 30.w,
              onTap: () {
                Get.to(
                  () => NewPostShareScreen(
                    isPoll: false,
                    isForum: widget.isForum,
                    isGhostPost: widget.isGhostPost,
                    groupId: widget.groupId,
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
  const VideoPlayerWithFile({super.key, required this.videoFile});

  final File videoFile;

  @override
  State<VideoPlayerWithFile> createState() => _VideoPlayerWithFileState();
}

class _VideoPlayerWithFileState extends State<VideoPlayerWithFile> {
  late VideoPlayerController videoPlayerController;
  bool isLoadingVideo = true;
  bool isPlayingVideo = false;
  bool isError = false;
  @override
  void initState() {
    super.initState();
    initVideo();
  }

  initVideo() {
    videoPlayerController = VideoPlayerController.file(
      widget.videoFile,
    );
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      videoPlayerController.initialize().then((value) {
        setState(() {
          isLoadingVideo = false;
        });
      }).catchError((e) {
        GlobalSnackBar.show(message: appText(context).strVideoNotSupported);
        isLoadingVideo = false;
        isPlayingVideo = false;
        isError = true;
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    isLoadingVideo = true;
    isPlayingVideo = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isError
        ? Center(
            child: TextWidget(text: appText(context).strFilenotSupported),
          )
        : Stack(
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
                  alignment: Alignment.center,
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
  const MusicPlayerWithFile({super.key, required this.musicFile});
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
