import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/chat_screen_widgets/add_media_widget.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_text_field.dart';
import 'package:casarancha/widgets/chat_screen_widgets/voice_widget.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../resources/color_resources.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key, required this.appUserId});
  final String appUserId;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool isRecordingDelete = false;

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value:
          DataProvider().filterUserList([currentUserUID] + [widget.appUserId]),
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
              allUsers.where((element) => element.id == widget.appUserId).first;
          return TapRegion(
            onTapOutside: (event) {
              chatProvider.textFieldFocus.unfocus();
              // chatProvider.notifyUI();
            },
            child: Container(
              padding: const EdgeInsets.only(
                  left: 15, right: 10, bottom: 10, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!chatProvider.isRecording &&
                      !chatProvider.isRecordingSend)
                    AddMediaWidget(chatProvider: chatProvider),
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
                  if (!chatProvider.textFieldFocus.hasFocus)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
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
                          // : YourWidget()
                          : GestureDetector(
                              onLongPress: () async {
                                if (await chatProvider.audioRecorder
                                    .hasPermission()) {
                                  chatProvider.startRecording();
                                  isRecordingDelete = false;
                                  setState(() {});
                                } else {
                                  return;
                                }
                              },
                              onLongPressMoveUpdate: (details) {
                                final dragDistanceHor =
                                    details.localPosition.dx;
                                final dragDistanceVer =
                                    details.localPosition.dy;

                                if (dragDistanceHor < -20) {
                                  chatProvider.deleteRecording();

                                  // log('deleted');
                                  isRecordingDelete = true;
                                  setState(() {});
                                }
                                if (dragDistanceVer < -10) {
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
                  if (chatProvider.textFieldFocus.hasFocus)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.w,
                        horizontal: 12.w,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (chatProvider.isReply) {
                            chatProvider.unreadMessages + 1;
                            chatProvider.replyMessage(
                              currentUser: currentUser,
                              appUser: appUser,
                            );
                          } else if (chatProvider.isMessageEditing) {
                            chatProvider.editMessage(
                                false, chatProvider.editMessageId);
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
                    ),
                ],
              ),
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
