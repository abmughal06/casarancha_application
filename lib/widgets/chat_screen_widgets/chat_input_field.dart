import 'package:casarancha/models/message_details.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_text_field.dart';
import 'package:casarancha/widgets/chat_screen_widgets/voice_widget.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../resources/color_resources.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    super.key,
    required this.appUserId,
    required this.messageDetails,
  });
  final String appUserId;
  final MessageDetails messageDetails;

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
            padding:
                const EdgeInsets.only(left: 15, right: 20, bottom: 10, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (chatProvider.messageController.text.isEmpty &&
                    !chatProvider.isRecording &&
                    !chatProvider.isRecordingSend)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          CupertinoActionSheet(
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () {},
                                child: SizedBox(
                                  height: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                              chatProvider.getMusic();
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(10.h),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red),
                                                child: const Icon(
                                                  Icons.music_note,
                                                  color: colorWhite,
                                                )),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                              chatProvider.getVideo(context);
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(10.h),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.blue),
                                                child: const Icon(
                                                    Icons
                                                        .video_collection_outlined,
                                                    color: colorWhite)),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                              chatProvider.getPhoto(context);
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(10.h),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.orange),
                                                child: const Icon(Icons.photo,
                                                    color: colorWhite)),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                              chatProvider
                                                  .takeCameraPic(context);
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(10.h),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.deepOrange),
                                                child: const Icon(
                                                    Icons.camera_alt,
                                                    color: colorWhite)),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                              chatProvider.getMedia(context);
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(10.h),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.purple),
                                                child: const Icon(
                                                    Icons.file_copy_sharp,
                                                    color: colorWhite)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                'Cancel',
                              ),
                            ),
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        backgroundColor: colorFF4,
                        child: Icon(
                          Icons.add,
                          color: color080,
                        ),
                      ),
                    ),
                  ),
                if (!chatProvider.isRecording)
                  Expanded(
                    child: ChatTextField(
                      chatController: chatProvider.messageController,
                      ontapSend: () {},
                      currentUser: currentUser,
                      appUser: appUser,
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
                  Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: chatProvider.isRecorderLock
                        ? GestureDetector(
                            onTap: () {
                              chatProvider.stopRecording(
                                currentUser: currentUser,
                                appUser: appUser,
                                firstMessageByWho: false,
                                isGhostMessage: false,
                              );
                            },
                            child: const Icon(
                              CupertinoIcons.arrow_turn_right_up,
                              color: colorPrimaryA05,
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
                              final dragDistanceHor = details.localPosition.dx;
                              final dragDistanceVer = details.localPosition.dy;

                              if (dragDistanceHor < -50) {
                                chatProvider.deleteRecording();

                                // log('deleted');
                                isRecordingDelete = true;
                              }
                              if (dragDistanceVer < -20) {
                                chatProvider.toggleRecorderLock();
                              }
                            },
                            onLongPressEnd: (details) {
                              if (!isRecordingDelete) {
                                chatProvider.unreadMessages += 1;
                                chatProvider.stopRecording(
                                  currentUser: currentUser,
                                  appUser: appUser,
                                  firstMessageByWho: false,
                                  notificationText: appText(context)
                                      .strUnReadVoiceMessages(
                                          chatProvider.unreadMessages),
                                  isGhostMessage: false,
                                );
                              }
                              if (chatProvider.isRecorderLock) {}
                              chatProvider.cancelTimer();
                              chatProvider.deleteRecording();
                            },
                            child: Icon(
                              Icons.mic_none_sharp,
                              color: color080,
                              size: 24.sp,
                            ),
                          ),
                  ),
                // if (chatProvider.messageController.text.isEmpty)
                // Row(
                //   children: [
                //     widthBox(12.w),
                //     chatProvider.isRecorderLock
                //         ? GestureDetector(
                //             onTap: () {
                //               chatProvider.stopRecording(
                //                 currentUser: currentUser,
                //                 appUser: appUser,
                //                 firstMessageByWho: false,
                //                 isGhostMessage: false,
                //               );
                //             },
                //             child: Image.asset(
                //               imgSendComment,
                //               height: 38.h,
                //               width: 38.w,
                //             ),
                //           )
                //         : GestureDetector(
                //             onLongPress: () async {
                //               if (await chatProvider.audioRecorder
                //                   .hasPermission()) {
                //                 chatProvider.startRecording();
                //                 isRecordingDelete = false;
                //               } else {
                //                 return;
                //               }
                //             },
                //             onLongPressMoveUpdate: (details) {
                //               final dragDistanceHor =
                //                   details.localPosition.dx;
                //               final dragDistanceVer =
                //                   details.localPosition.dy;

                //               if (dragDistanceHor < -50) {
                //                 chatProvider.deleteRecording();

                //                 log('deleted');
                //                 isRecordingDelete = true;
                //               }
                //               if (dragDistanceVer < -20) {
                //                 chatProvider.toggleRecorderLock();
                //               }
                //             },
                //             onLongPressEnd: (details) {
                //               if (!isRecordingDelete) {
                //                 chatProvider.unreadMessages += 1;
                //                 chatProvider.stopRecording(
                //                   currentUser: currentUser,
                //                   appUser: appUser,
                //                   firstMessageByWho: false,
                //                   notificationText: appText(context)
                //                       .strUnReadVoiceMessages(
                //                           chatProvider.unreadMessages),
                //                   isGhostMessage: false,
                //                 );
                //               }
                //               if (chatProvider.isRecorderLock) {}
                //               chatProvider.cancelTimer();
                //               chatProvider.deleteRecording();
                //             },
                //             child: Container(
                //               padding: EdgeInsets.all(10.w),
                //               decoration: BoxDecoration(
                //                   shape: BoxShape.circle,
                //                   color: colorF03.withOpacity(0.6)),
                //               child: Icon(
                //                 Icons.mic_none_sharp,
                //                 color: color221,
                //                 size: 24.sp,
                //               ),
                //             ),
                //           )
                //   ],
                // ),
                if (chatProvider.messageController.text.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: GestureDetector(
                      onTap: () {
                        if (chatProvider.isReply) {
                          chatProvider.unreadMessages + 1;
                          chatProvider.replyMessage(
                            messageDetails: messageDetails,
                            currentUser: currentUser,
                            appUser: appUser,
                          );
                        } else {
                          chatProvider.unreadMessages + 1;
                          chatProvider.sentTextMessage(
                            currentUser: currentUser,
                            appUser: appUser,
                          );
                        }
                      },
                      child: const Icon(
                        CupertinoIcons.arrow_turn_right_up,
                        color: colorPrimaryA05,
                      ),
                    ),
                  )
              ],
            ),
          );
        },
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
