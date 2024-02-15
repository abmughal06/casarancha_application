import 'dart:developer';

import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/strings.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_screen.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_text_field.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../resources/color_resources.dart';
import '../../../resources/image_resources.dart';
import '../../../widgets/common_widgets.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    super.key,
    required this.appUserId,
  });
  final String appUserId;

  @override
  Widget build(BuildContext context) {
    bool isRecordingDelete = false;

    return StreamProvider.value(
      value: DataProvider().filterUserList([currentUserUID] + [appUserId]),
      initialData: null,
      catchError: (context, error) => null,
      child: Consumer2<ChatProvider, List<UserModel>?>(
        builder: (context, chatProvider, allUsers, b) {
          if (allUsers == null) {
            return Container();
          }
          var currentUser =
              allUsers.where((element) => element.id == currentUserUID).first;
          var appUser =
              allUsers.where((element) => element.id == appUserId).first;
          return Container(
            decoration: BoxDecoration(
                color: colorWhite,
                border:
                    Border(top: BorderSide(color: color221.withOpacity(0.3)))),
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 35, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!chatProvider.isRecording)
                  Expanded(
                    child: ChatTextField(
                      chatController: chatProvider.messageController,
                      ontapSend: () {},
                    ),
                  ),
                if (chatProvider.isRecording)
                  VoiceRecordingWidget(
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
                if (chatProvider.messageController.text.isEmpty)
                  Row(
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
                if (chatProvider.messageController.text.isNotEmpty)
                  Row(
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
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ShowMediaToSendInChat extends StatelessWidget {
  const ShowMediaToSendInChat(
      {super.key, required this.currentUser, required this.appUser});
  final UserModel currentUser;
  final UserModel appUser;

  @override
  Widget build(BuildContext context) {
    final media = Provider.of<ChatProvider>(context);
    return Scaffold(
      backgroundColor: colorBlack,
      appBar: AppBar(
        backgroundColor: colorBlack,
        title: TextWidget(
          text: 'Send Media',
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: colorWhite,
        ),
        leadingWidth: 50,
        leading: GestureDetector(
          onTap: () {
            media.clearLists();
          },
          child: const Icon(
            Icons.navigate_before,
            size: 40,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
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
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          heightBox(15.h),
          SizedBox(
            height: MediaQuery.of(context).size.height * .70,
            child: Center(
              child: AspectRatio(
                aspectRatio: 9 / 13,
                child: PageView.builder(
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
                      return AspectRatio(
                        aspectRatio: 9 / 13,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: NativeVideoView(
                                useExoPlayer: false,
                                keepAspectRatio: false,
                                showMediaController: true,
                                onCreated: (VideoViewController controller) {
                                  controller.setVideoSource(
                                      media.videosList[index].path,
                                      sourceType: VideoSourceType.file);
                                },
                                onPrepared: (VideoViewController controller,
                                    VideoInfo videoInfo) {
                                  controller
                                      .play()
                                      .then((value) =>
                                          const Duration(milliseconds: 1000))
                                      .then((value) => controller.pause());
                                },
                                onCompletion:
                                    (VideoViewController controller) {},
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: InkWell(
                                onTap: () {
                                  media
                                      .removeVideoFile(media.videosList[index]);
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
                                  media.removeMusicFile(media.musicList[index]);
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
                                media.removePhotoFile(media.photosList[index]);
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: appText(context).strWriteCommentHere,
                hintStyle: TextStyle(
                  color: colorWhite,
                  fontSize: 14.sp,
                  fontFamily: strFontName,
                  fontWeight: FontWeight.w400,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: svgImgButton(
                    svgIcon: icStoryCmtSend,
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
                    },
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(
                    color: colorWhite,
                    width: 1.h,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide(
                    color: colorWhite,
                    width: 1.h,
                  ),
                ),
              ),
            ),
          ),
          heightBox(30.h),
        ],
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
      {super.key,
      required this.isRecording,
      required this.isRecordingSend,
      required this.duration,
      required this.onTapDelete,
      required this.isRecorderLock,
      required this.sendRecording});

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
                    text: appText(context).slideCancel,
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
