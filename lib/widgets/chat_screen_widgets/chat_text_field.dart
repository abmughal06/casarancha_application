import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/strings.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField(
      {super.key,
      required this.ontapSend,
      required this.chatController,
      required this.currentUser,
      required this.appUser});
  final VoidCallback ontapSend;
  final TextEditingController chatController;
  final UserModel currentUser;
  final UserModel appUser;

  void _onTextChanged() {
    final text = chatController.text;
    if (text.isNotEmpty) {
      // Capitalize the first letter
      String newText = text.substring(0, 1).toUpperCase() + text.substring(1);

      // Capitalize letter after a period (.)
      for (int i = 1; i < text.length - 1; i++) {
        if (text[i - 1] == '.' && text[i] == ' ') {
          newText = newText.substring(0, i + 1) +
              text[i + 1].toUpperCase() +
              newText.substring(i + 2);
          i++; // Skip the next character since it has already been capitalized
        }
      }

      if (text != newText) {
        chatController.value = chatController.value.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool isRecordingDelete = false;

    return Consumer<ChatProvider>(
      builder: (context, chat, b) {
        return TextField(
          minLines: 1,
          maxLines: 3,
          controller: chatController,
          style: TextStyle(
            color: color239,
            fontSize: 16.sp,
            fontFamily: strFontName,
            fontWeight: FontWeight.w600,
          ),
          onChanged: (v) {
            chat.notifyUI();
            _onTextChanged();
          },
          focusNode: chat.textFieldFocus,
          maxLength: 1500,
          decoration: InputDecoration(
            isDense: true,
            counterText: "",
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.w,
                color: color080,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            hintText: appText(context).strSaySomething,
            hintStyle: TextStyle(
              color: color55F,
              fontSize: 14.sp,
              fontFamily: strFontName,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.all(7),
            focusColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.w,
                color: color080,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          onTapOutside: (v) => FocusScope.of(context).unfocus(),
          onEditingComplete: () => FocusScope.of(context).unfocus(),
        );
      },
    );
  }
}

class ChatTextFieldGhost extends StatelessWidget {
  const ChatTextFieldGhost(
      {super.key, required this.ontapSend, required this.chatController});
  final VoidCallback ontapSend;
  final TextEditingController chatController;

  @override
  Widget build(BuildContext context) {
    final ghost = Provider.of<DashboardProvider>(context);
    return Consumer<ChatProvider>(
      builder: (context, chat, b) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: colorFF3,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            minLines: 1,
            maxLines: 3,
            controller: chatController,
            style: TextStyle(
              color: color239,
              fontSize: 16.sp,
              fontFamily: strFontName,
              fontWeight: FontWeight.w600,
            ),
            onChanged: (v) {
              chat.notifyUI();
            },
            focusNode: chat.textFieldFocus,
            maxLength: 1500,
            decoration: InputDecoration(
              isDense: true,
              counterText: "",
              border: InputBorder.none,
              hintText: appText(context).strSaySomething,
              hintStyle: TextStyle(
                color: color55F,
                fontSize: 14.sp,
                fontFamily: strFontName,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: Visibility(
                visible:
                    chat.messageController.text.isEmpty && !chat.isRecording,
                child: GestureDetector(
                  onTap: () {
                    ghost.checkGhostMode
                        ? Get.bottomSheet(
                            CupertinoActionSheet(
                              actions: [
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Get.back();
                                    chat.getPhoto(context);
                                  },
                                  child: SizedBox(
                                    height: 80,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                chat.getMusic();
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.all(10.h),
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.red),
                                                  child: const Icon(
                                                    Icons.music_note,
                                                    color: colorWhite,
                                                  )),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.back();
                                                chat.getVideo(context);
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.all(10.h),
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.blue),
                                                  child: const Icon(
                                                      Icons
                                                          .video_collection_outlined,
                                                      color: colorWhite)),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.back();
                                                chat.getPhoto(context);
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.all(10.h),
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.orange),
                                                  child: const Icon(Icons.photo,
                                                      color: colorWhite)),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.back();
                                                chat.getMedia(context);
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.all(10.h),
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
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
                          )
                        : GlobalSnackBar.show(
                            message:
                                appText(context).strEnableGhModeAttachment);
                  },
                  child: SvgPicture.asset(icChatPaperClip),
                ),
              ),
              suffixIconConstraints: const BoxConstraints(maxHeight: 18),
              contentPadding: EdgeInsets.zero,
              focusColor: Colors.transparent,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0,
                  color: Colors.transparent,
                ),
              ),
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            onTapOutside: (v) => FocusScope.of(context).unfocus(),
            onEditingComplete: () => FocusScope.of(context).unfocus(),
          ),
        );
      },
    );
  }
}
