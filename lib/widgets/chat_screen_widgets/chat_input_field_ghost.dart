import 'dart:developer';

import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/chat_screen_widgets/add_media_widget.dart';
import 'package:casarancha/widgets/chat_screen_widgets/chat_text_field.dart';
import 'package:casarancha/widgets/chat_screen_widgets/voice_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../resources/color_resources.dart';
import '../../../widgets/common_widgets.dart';
import '../../screens/dashboard/provider/dashboard_provider.dart';
import '../text_widget.dart';
import 'chat_input_field.dart';

class ChatInputFieldGhost extends StatefulWidget {
  const ChatInputFieldGhost({
    super.key,
    required this.appUserId,
    required this.firstMessage,
  });
  final String appUserId;
  final bool firstMessage;

  @override
  State<ChatInputFieldGhost> createState() => _ChatInputFieldGhostState();
}

class _ChatInputFieldGhostState extends State<ChatInputFieldGhost> {
  bool isRecordingDelete = false;

  @override
  Widget build(BuildContext context) {
    final ghostProvider = context.watch<DashboardProvider>();

    return StreamProvider.value(
      value: DataProvider().allUsers(),
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
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!chatProvider.isRecording)
                  AddMediaWidget(chatProvider: chatProvider),
                Visibility(
                  visible: !chatProvider.isRecording,
                  child: Expanded(
                    child: ChatTextField(
                      chatController: chatProvider.messageController,
                      ontapSend: () {},
                    ),
                  ),
                ),
                Visibility(
                  visible: chatProvider.isRecording,
                  child: VoiceRecordingWidget(
                      sendRecording: () => chatProvider.stopRecording(
                            currentUser: currentUser,
                            appUser: appUser,
                            firstMessageByWho: widget.firstMessage,
                            isGhostMessage: true,
                          ),
                      isRecorderLock: chatProvider.isRecorderLock,
                      onTapDelete: () => chatProvider.deleteRecording(),
                      isRecording: chatProvider.isRecording,
                      isRecordingSend: chatProvider.isRecordingSend,
                      duration: formatTime(chatProvider.durationInSeconds)),
                ),
                Visibility(
                  visible: !chatProvider.textFieldFocus.hasFocus,
                  child: Row(
                    children: [
                      widthBox(12.w),
                      chatProvider.isRecorderLock
                          ? GestureDetector(
                              onTap: () {
                                chatProvider.stopRecording(
                                    currentUser: currentUser,
                                    appUser: appUser,
                                    firstMessageByWho: widget.firstMessage,
                                    isGhostMessage: true);
                              },
                              child: const Icon(
                                CupertinoIcons.arrow_turn_right_up,
                                color: colorPrimaryA05,
                              ))
                          : Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: GestureDetector(
                                onLongPressStart: (c) async {
                                  if (ghostProvider.checkGhostMode) {
                                    if (await chatProvider.audioRecorder
                                        .hasPermission()) {
                                      chatProvider.startRecording();
                                    }
                                    isRecordingDelete = false;
                                  } else {
                                    GlobalSnackBar.show(
                                        message: appText(context)
                                            .strEnableGhModeAudio);
                                  }
                                },
                                onLongPressMoveUpdate: (details) {
                                  if (ghostProvider.checkGhostMode) {
                                    final dragDistanceHor =
                                        details.localPosition.dx;
                                    final dragDistanceVer =
                                        details.localPosition.dy;

                                    if (dragDistanceHor < -50) {
                                      chatProvider.deleteRecording();
                                      isRecordingDelete = true;
                                    }
                                    if (dragDistanceVer < -20) {
                                      chatProvider.toggleRecorderLock();
                                    }
                                  } else {
                                    GlobalSnackBar.show(
                                        message: appText(context)
                                            .strEnableGhModeAudio);
                                  }
                                },
                                onLongPressEnd: (details) {
                                  if (ghostProvider.checkGhostMode) {
                                    if (!isRecordingDelete) {
                                      chatProvider.unreadMessages += 1;
                                      chatProvider.stopRecording(
                                        currentUser: currentUser,
                                        appUser: appUser,
                                        notificationText: appText(context)
                                            .strUnReadVoiceMessages(
                                                chatProvider.unreadMessages),
                                        firstMessageByWho: widget.firstMessage,
                                        isGhostMessage: true,
                                      );
                                    }
                                  } else {
                                    GlobalSnackBar.show(
                                        message: appText(context)
                                            .strEnableGhModeAudio);
                                  }
                                },
                                child: const Icon(
                                  Icons.mic_none_sharp,
                                  color: color080,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
                Visibility(
                  visible: chatProvider.textFieldFocus.hasFocus,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          chatProvider.unreadMessages += 1;
                          // print('sent');
                          ghostProvider.checkGhostMode
                              ? chatProvider.sentMessageGhost(
                                  currentUser: currentUser,
                                  appUser: appUser,
                                  firstMessageByMe: widget.firstMessage,
                                  notificationText: appText(context)
                                      .strUnReadMessagesInGhost(
                                          chatProvider.unreadMessages))
                              : GlobalSnackBar.show(
                                  message:
                                      appText(context).strEnableGhModeMessage);
                        },
                        child: const Icon(
                          CupertinoIcons.arrow_turn_right_up,
                          color: colorPrimaryA05,
                        )),
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
