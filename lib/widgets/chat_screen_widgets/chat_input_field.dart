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
          var currentUser = allUsers.first;
          var appUser = allUsers.last;
          return TapRegion(
            onTapOutside: (event) {
              chatProvider.textFieldFocus.unfocus();
              chatProvider.notifyUI();
            },
            child: Container(
              padding: const EdgeInsets.only(
                  left: 15, right: 20, bottom: 10, top: 5),
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
                      padding: EdgeInsets.only(left: 12.w),
                      child: GestureDetector(
                        onTap: () {
                          if (chatProvider.isReply) {
                            chatProvider.unreadMessages + 1;
                            chatProvider.replyMessage(
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

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  double startedDraggingX = -1;
  double distCanMove = 80.0; // initial value, adjust as needed
  double slideTextWidth = 100.0; // example value, replace with actual width
  double recordPanelWidth = 200.0; // example value, replace with actual width
  bool locked = false;

  void startRecord() {
    // Your start recording logic here
    print('start');
  }

  void stopRecord() {
    // Your stop recording logic here
    print('stop');
  }

  void lockRecorder() {
    setState(() {
      locked = true;
    });
    print('lock');

    // Additional logic if needed when recorder is locked
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (LongPressStartDetails details) {
        setState(() {
          startedDraggingX = -1;
          startRecord();
          // Set your recordPanel visibility logic here
        });
      },
      onLongPressEnd: (LongPressEndDetails details) {
        setState(() {
          startedDraggingX = -1;
          stopRecord();
          // Set your recordPanel visibility logic here
        });
      },
      onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
        if (locked) return; // Do nothing if recorder is locked
        double x = details.localPosition.dx;
        double y = details.localPosition.dy;

        if (y < -10) {
          lockRecorder();
          return;
        }

        if (x < -distCanMove) {
          stopRecord();
          // Set your recordPanel visibility logic here
        }
        x += MediaQuery.of(context).size.width /
            2; // Adjust according to your layout
        setState(() {
          if (startedDraggingX != -1) {
            double dist = (x - startedDraggingX);
            double newMargin = 30 + dist;
            if (newMargin <= 30) {
              newMargin = 30;
            }
            double alpha = 1.0 + dist / distCanMove;
            if (alpha > 1) {
              alpha = 1;
            } else if (alpha < 0) {
              alpha = 0;
            }
            // Update UI accordingly
          }
          if (x <=
              MediaQuery.of(context).size.width / 2 + slideTextWidth + 30) {
            if (startedDraggingX == -1) {
              startedDraggingX = x;
              distCanMove = (recordPanelWidth - slideTextWidth - 48) / 2.0;
              if (distCanMove <= 0) {
                distCanMove = 80;
              } else if (distCanMove > 80) {
                distCanMove = 80;
              }
            }
          }
        });
      },
      child: const Icon(
          Icons.mic), // Replace YourButtonWidget with your actual button
    );
  }
}
