import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_screen.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_text_field.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../models/user_model.dart';
import '../../../resources/color_resources.dart';
import '../../../resources/image_resources.dart';
import '../../../widgets/chat_screen_widgets/chat_screen_message_tiles.dart';
import '../../../widgets/chat_screen_widgets/chat_user_app_bar.dart';
import '../../../widgets/clip_pad_shadow.dart';
import '../../../widgets/common_widgets.dart';

class ChatScreen extends StatefulWidget {
  final String appUserId;
  final CreatorDetails creatorDetails;
  final String? val;

  const ChatScreen({
    Key? key,
    required this.appUserId,
    required this.creatorDetails,
    this.val,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin<ChatScreen> {
  late ChatProvider chatProvider;

  @override
  void dispose() {
    chatProvider.clearMessageController();
    chatProvider.clearListsondispose();
    chatProvider.voiceFile = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final currentUser = context.watch<UserModel>();
    final users = context.watch<List<UserModel>>();
    final appUser =
        users.where((element) => element.id == widget.appUserId).first;
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(icIosBackArrow),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0.1,
        automaticallyImplyLeading: false,
        backgroundColor: colorWhite,
        title: ChatScreenUserAppBar(
          creatorDetails: widget.creatorDetails,
          appUserId: widget.appUserId,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: svgImgButton(
                svgIcon: icChatVideo,
                onTap: () {
                  GlobalSnackBar.show(message: "Comming Soon");
                }),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 20.w),
            child: svgImgButton(
                svgIcon: icChatCall,
                onTap: () {
                  GlobalSnackBar.show(message: "Comming Soon");
                }),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamProvider.value(
            value: DataProvider().messages(widget.appUserId, false),
            initialData: null,
            child: Consumer<List<Message>?>(
              builder: (context, messages, b) {
                if (messages == null) {
                  return const CircularProgressIndicator.adaptive();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    reverse: true,
                    // padding: EdgeInsets.only(bottom: 100.h),
                    addAutomaticKeepAlives: true,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      final isMe = message.sentToId == widget.appUserId;
                      if (messages.isNotEmpty && message.type == 'Text') {
                        chatProvider.resetMessageCount(
                          currentUserId: currentUser.id,
                          appUserId: appUser.id,
                          messageid: message.id,
                        );
                      }
                      return MessageTiles(
                        isMe: isMe,
                        message: message,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Consumer<ChatProvider>(
            builder: (context, v, b) {
              return v.voiceFile == null
                  ? chatProvider.photosList.isNotEmpty ||
                          chatProvider.videosList.isNotEmpty ||
                          chatProvider.musicList.isNotEmpty
                      ? ShowMediaToSendInChat(
                          currentUser: currentUser,
                          appUser: appUser,
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border(
                                  top: BorderSide(
                                      color: color221.withOpacity(0.3)))),
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 35, top: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: ChatTextField(
                                  chatController:
                                      chatProvider.messageController,
                                  ontapSend: () {},
                                ),
                              ),
                              Visibility(
                                visible:
                                    chatProvider.messageController.text.isEmpty,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // widthBox(8.w),
                                    SpeedDial(
                                      closeDialOnPop: true,
                                      backgroundColor: Colors.transparent,
                                      activeBackgroundColor: colorPrimaryA05,
                                      activeChild: const Icon(
                                        Icons.close,
                                        color: colorWhite,
                                      ),
                                      buttonSize: Size(40.h, 40.h),
                                      overlayColor: Colors.black,
                                      overlayOpacity: 0.4,
                                      elevation: 0,
                                      spacing: 5,
                                      childMargin: EdgeInsets.zero,
                                      children: [
                                        SpeedDialChild(
                                          child: Icon(
                                            Icons
                                                .photo_size_select_actual_rounded,
                                            size: 18.sp,
                                          ),
                                          onTap: () {
                                            chatProvider.getPhoto();
                                          },
                                          label: 'Image',
                                        ),
                                        SpeedDialChild(
                                          child: Icon(
                                            Icons.video_collection_sharp,
                                            size: 18.sp,
                                          ),
                                          onTap: () {
                                            chatProvider.getVideo();
                                          },
                                          label: 'Video',
                                        ),
                                        SpeedDialChild(
                                          child: Icon(
                                            Icons.music_note_outlined,
                                            size: 20.sp,
                                          ),
                                          onTap: () {
                                            chatProvider.getMusic();
                                          },
                                          label: 'Music',
                                        ),
                                      ],
                                      child: SvgPicture.asset(
                                        icChatPaperClip,
                                        height: 25.h,
                                        color: color221,
                                      ),
                                    ),
                                    // widthBox(8.w),
                                    Container(
                                      padding: EdgeInsets.all(9.w),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorF03.withOpacity(0.6)),
                                      child: const Icon(
                                        Icons.mic_none_sharp,
                                        color: color221,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                child: Visibility(
                                  visible: chatProvider
                                      .messageController.text.isNotEmpty,
                                  child: Row(
                                    children: [
                                      widthBox(12.w),
                                      GestureDetector(
                                        onTap: () {
                                          chatProvider.sentMessage(
                                            currentUser: currentUser,
                                            appUser: appUser,
                                          );
                                        },
                                        child: Image.asset(
                                          imgSendComment,
                                          height: 38.h,
                                          width: 38.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                  : VoiceRecordingPlayer(voiceFile: v.voiceFile!);
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class VoiceRecordingPlayer extends StatefulWidget {
  const VoiceRecordingPlayer({
    Key? key,
    required this.voiceFile,
  }) : super(key: key);
  final File voiceFile;

  @override
  State<VoiceRecordingPlayer> createState() => _VoiceRecordingPlayerState();
}

class _VoiceRecordingPlayerState extends State<VoiceRecordingPlayer> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    audioPlayer = AudioPlayer()..setSourceDeviceFile(widget.voiceFile.path);

    log(widget.voiceFile.path);
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

    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        clipper: const ClipPad(padding: EdgeInsets.only(top: 30)),
        child: Container(
          // height: 100.h,
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            bottom: 20.h,
          ),
          decoration: BoxDecoration(
            color: colorWhite,
            boxShadow: [
              BoxShadow(
                color: colorPrimaryA05.withOpacity(.36),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(4, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        overlayShape: SliderComponentShape.noOverlay,
                      ),
                      child: Slider.adaptive(
                        thumbColor: colorPrimaryA05,
                        activeColor: colorPrimaryA05,
                        min: 0.0,
                        max: duration.inSeconds.toDouble() + 1.0,
                        value: position.inSeconds.toDouble() + 1.0,
                        onChanged: (value) async {
                          final position = Duration(seconds: value.toInt());
                          await audioPlayer.seek(position);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextWidget(
                          text: formatTime(position),
                        ),
                        InkWell(
                          onTap: () {
                            audioPlayer.setSourceDeviceFile(
                                context.read<ChatProvider>().voiceFile!.path);
                            isPlaying
                                ? audioPlayer.pause()
                                : audioPlayer.resume();
                          },
                          child: Icon(isPlaying
                              ? Icons.pause
                              : Icons.play_arrow_rounded),
                        ),
                        TextWidget(
                          text: formatTime(duration),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<ChatProvider>().clearVoiceFile();
                },
                icon: const Icon(Icons.close_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowMediaToSendInChat extends StatelessWidget {
  const ShowMediaToSendInChat(
      {Key? key, required this.currentUser, required this.appUser})
      : super(key: key);
  final UserModel currentUser;
  final UserModel appUser;

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<ChatProvider>(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        clipper: const ClipPad(padding: EdgeInsets.only(top: 30)),
        child: Container(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            bottom: 20.h,
          ),
          decoration: BoxDecoration(
            color: colorWhite,
            boxShadow: [
              BoxShadow(
                color: colorPrimaryA05.withOpacity(.36),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(4, 0),
              ),
            ],
          ),
          child: SizedBox(
            height: 150.h,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: media.photosList.isNotEmpty
                        ? media.photosList.length
                        : media.videosList.isNotEmpty
                            ? media.videosList.length
                            : media.musicList.length,
                    itemBuilder: (context, index) {
                      if (media.videosList.isNotEmpty) {
                        VideoPlayerController videoPlayerController;
                        videoPlayerController =
                            VideoPlayerController.file(media.videosList[index])
                              ..initialize().then((value) {});
                        return AspectRatio(
                          aspectRatio: 9 / 13,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: VideoPlayer(
                                  videoPlayerController,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    media.removeVideoFile(
                                        media.videosList[index]);
                                  },
                                  child: SvgPicture.asset(icRemovePost),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      if (media.musicList.isNotEmpty) {
                        return AspectRatio(
                          aspectRatio: 13 / 9,
                          child: Stack(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MusicPlayerWithFile(
                                      musicFile: media.musicList[index])),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    media.removeMusicFile(
                                        media.musicList[index]);
                                  },
                                  child: SvgPicture.asset(icRemovePost),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      if (media.photosList.isNotEmpty) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                media.photosList[index],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: InkWell(
                                onTap: () {
                                  media
                                      .removePhotoFile(media.photosList[index]);
                                },
                                child: SvgPicture.asset(icRemovePost),
                              ),
                            )
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                // GestureDetector(
                //   onTap: () => media.photosList.isNotEmpty
                //       ? media.getPhoto()
                //       : media.videosList.isNotEmpty
                //           ? media.getVideo()
                //           : media.getMusic(),
                //   child: Image.asset(
                //     imgAddPost,
                //     height: 38.h,
                //     width: 38.w,
                //   ),
                // ),
                GestureDetector(
                  onTap: () => media.pickImageAndSentViaMessage(
                    currentUser: currentUser,
                    appUser: appUser,
                    mediaType: media.photosList.isNotEmpty
                        ? 'InChatPic'
                        : media.videosList.isNotEmpty
                            ? 'InChatVideo'
                            : 'InChatMusic',
                  ),
                  child: Image.asset(
                    imgSendComment,
                    height: 38.h,
                    width: 38.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Expanded(
//
//                 ),