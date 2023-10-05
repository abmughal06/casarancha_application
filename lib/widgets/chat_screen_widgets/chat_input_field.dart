import 'dart:developer';

import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_screen.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_text_field.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../models/user_model.dart';
import '../../../resources/color_resources.dart';
import '../../../resources/image_resources.dart';
import '../../../widgets/clip_pad_shadow.dart';
import '../../../widgets/common_widgets.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    Key? key,
    required this.currentUser,
    required this.appUser,
    required this.onTapSentMessage,
  }) : super(key: key);
  final UserModel currentUser;

  final UserModel appUser;
  final VoidCallback onTapSentMessage;

  @override
  Widget build(BuildContext context) {
    bool isRecordingDelete = false;

    return Consumer<ChatProvider>(
      builder: (context, chatProvider, b) {
        return chatProvider.photosList.isNotEmpty ||
                chatProvider.videosList.isNotEmpty ||
                chatProvider.mediaList.isNotEmpty ||
                chatProvider.musicList.isNotEmpty
            ? ShowMediaToSendInChat(
                currentUser: currentUser,
                appUser: appUser,
              )
            : Container(
                decoration: BoxDecoration(
                    color: colorWhite,
                    border: Border(
                        top: BorderSide(color: color221.withOpacity(0.3)))),
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 35, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: !chatProvider.isRecording &&
                          !chatProvider.isRecordingSend,
                      child: Expanded(
                        child: ChatTextField(
                          chatController: chatProvider.messageController,
                          ontapSend: () {},
                        ),
                      ),
                    ),
                    Visibility(
                      visible: chatProvider.isRecording ||
                          chatProvider.isRecordingSend,
                      child: VoiceRecordingWidget(
                          sendRecording: () => chatProvider.stopRecording(
                                currentUser: currentUser,
                                appUser: appUser,
                                firstMessageByWho: false,
                                isGhostMessage: false,
                              ),
                          isRecorderLock: chatProvider.isRecorderLock,
                          onTapDelete: () => chatProvider.deleteRecording(),
                          isRecording: chatProvider.isRecording,
                          isRecordingSend: chatProvider.isRecordingSend,
                          duration: formatTime(chatProvider.durationInSeconds)),
                    ),
                    Visibility(
                      visible: chatProvider.messageController.text.isEmpty,
                      child: Row(
                        children: [
                          widthBox(12.w),
                          chatProvider.isRecorderLock
                              ? GestureDetector(
                                  onTap: () {
                                    chatProvider.stopRecording(
                                      currentUser: currentUser,
                                      appUser: appUser,
                                      firstMessageByWho: false,
                                      isGhostMessage: false,
                                    );
                                  },
                                  child: Image.asset(
                                    imgSendComment,
                                    height: 38.h,
                                    width: 38.w,
                                  ),
                                )
                              : GestureDetector(
                                  onLongPress: () async {
                                    if (await chatProvider.audioRecorder
                                        .hasPermission()) {
                                      chatProvider.startRecording();
                                      isRecordingDelete = false;
                                    } else {
                                      return;
                                    }
                                  },
                                  onLongPressMoveUpdate: (details) {
                                    final dragDistanceHor =
                                        details.localPosition.dx;
                                    final dragDistanceVer =
                                        details.localPosition.dy;

                                    if (dragDistanceHor < -50) {
                                      chatProvider.deleteRecording();

                                      log('deleted');
                                      isRecordingDelete = true;
                                    }
                                    if (dragDistanceVer < -20) {
                                      chatProvider.toggleRecorderLock();
                                    }
                                  },
                                  onLongPressEnd: (details) {
                                    if (!isRecordingDelete) {
                                      chatProvider.stopRecording(
                                        currentUser: currentUser,
                                        appUser: appUser,
                                        firstMessageByWho: false,
                                        isGhostMessage: false,
                                      );
                                    }
                                    if (chatProvider.isRecorderLock) {}
                                    chatProvider.cancelTimer();
                                    chatProvider.deleteRecording();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorF03.withOpacity(0.6)),
                                    child: Icon(
                                      Icons.mic_none_sharp,
                                      color: color221,
                                      size: 24.sp,
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: chatProvider.messageController.text.isNotEmpty &&
                          !chatProvider.isRecording,
                      child: Row(
                        children: [
                          widthBox(12.w),
                          GestureDetector(
                            onTap: onTapSentMessage,
                            child: Image.asset(
                              imgSendComment,
                              height: 38.h,
                              width: 38.w,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
      },
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
                            : media.mediaList.isNotEmpty
                                ? media.mediaList.length
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
                      if (media.mediaList.isNotEmpty) {
                        return Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * .1,
                              width: MediaQuery.of(context).size.width * .6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: colorPrimaryA05,
                              ),
                              child: Center(
                                  child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.file_copy,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextWidget(
                                      color: Colors.white,
                                      text: media.mediaList[index].path
                                          .split('/')
                                          .last,
                                    ),
                                  )
                                ],
                              )),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: InkWell(
                                onTap: () {
                                  media.removeMediaFile(media.mediaList[index]);
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
                media.photosList.isNotEmpty ||
                        media.videosList.isNotEmpty ||
                        media.mediaList.isNotEmpty
                    ? GestureDetector(
                        onTap: () => media.photosList.isNotEmpty
                            ? media.getPhoto()
                            : media.mediaList.isNotEmpty
                                ? media.getMedia()
                                : media.getVideo(),
                        child: Image.asset(
                          imgAddPost,
                          height: 38.h,
                          width: 38.w,
                        ),
                      )
                    : widthBox(0),
                media.isUploading
                    ? centerLoader()
                    : GestureDetector(
                        onTap: () {
                          media.pickImageAndSentViaMessage(
                            currentUser: currentUser,
                            appUser: appUser,
                            mediaType: media.photosList.isNotEmpty
                                ? 'InChatPic'
                                : media.videosList.isNotEmpty
                                    ? 'InChatVideo'
                                    : media.mediaList.isNotEmpty
                                        ? 'InChatDoc'
                                        : 'InChatMusic',
                          );

                          // Get.defaultDialog(
                          //   title: 'Sending Attachments',
                          //   titleStyle: TextStyle(
                          //     fontSize: 14.sp,
                          //     color: color221,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          //   content: Consumer<ChatProvider>(
                          //     builder: (context, state, b) {
                          //       if (state.mediaUploadTasks.isNotEmpty) {
                          //         return Padding(
                          //           padding: EdgeInsets.symmetric(
                          //               horizontal: 15.w, vertical: 8.h),
                          //           child: Column(
                          //             children: [
                          //               LinearProgressIndicator(
                          //                 value: state.tasksProgress,
                          //                 minHeight: 10.h,
                          //               ),
                          //               heightBox(5.h),
                          //               TextWidget(
                          //                 text:
                          //                     '${(100 * state.tasksProgress).roundToDouble().toInt()}%',
                          //               ),
                          //             ],
                          //           ),
                          //         );
                          //       } else {
                          //         return ElevatedButton(
                          //           onPressed: () {
                          //             Get.back();
                          //           },
                          //           child: const Text('Done'),
                          //         );
                          //       }
                          //     },
                          //   ),
                          // );
                        },
                        child: Image.asset(
                          imgSendComment,
                          height: 38.h,
                          width: 38.w,
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

class VoiceRecordingWidget extends StatelessWidget {
  const VoiceRecordingWidget(
      {Key? key,
      required this.isRecording,
      required this.isRecordingSend,
      required this.duration,
      required this.onTapDelete,
      required this.isRecorderLock,
      required this.sendRecording})
      : super(key: key);

  final bool isRecording;
  final bool isRecordingSend;
  final String duration;
  final VoidCallback onTapDelete;
  final bool isRecorderLock;
  final VoidCallback sendRecording;

  @override
  Widget build(BuildContext context) {
    if (isRecording) {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            isRecorderLock
                ? IconButton(
                    onPressed: onTapDelete,
                    icon: const Icon(Icons.delete, color: colorPrimaryA05))
                : Container(),
            Padding(
              padding: EdgeInsets.only(left: isRecorderLock ? 50 : 0),
              child: TextWidget(
                text: duration,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: colorPrimaryA05,
              ),
            ),
            isRecorderLock
                ? Container()
                : TextWidget(
                    text: 'Slide to Cancel',
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: color221,
                  ),
            isRecorderLock
                ? Container()
                : const Icon(Icons.swipe_left_alt_rounded),
          ],
        ),
      );
    }
    if (isRecordingSend) {
      return Expanded(
        child: Container(
            height: 40.h,
            decoration: BoxDecoration(
                color: colorFF4, borderRadius: BorderRadius.circular(30)),
            child: centerLoader(size: 20.w)),
      );
    }
    return Container();
  }
}
