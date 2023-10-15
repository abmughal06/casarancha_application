import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField(
      {Key? key, required this.ontapSend, required this.chatController})
      : super(key: key);
  final VoidCallback ontapSend;
  final TextEditingController chatController;

  @override
  Widget build(BuildContext context) {
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
              hintText: strSaySomething,
              hintStyle: TextStyle(
                color: color55F,
                fontSize: 14.sp,
                fontFamily: strFontName,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: Visibility(
                visible: chat.messageController.text.isEmpty &&
                    !chat.isRecording &&
                    !chat.isRecordingSend,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                          chat.getVideo();
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(10.h),
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue),
                                            child: const Icon(
                                                Icons.video_collection_outlined,
                                                color: colorWhite)),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                          chat.getPhoto();
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
                                          chat.getMedia();
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
            onEditingComplete: () => FocusScope.of(context).unfocus(),
          ),
        );
      },
    );
  }
}

class ChatTextFieldGhost extends StatelessWidget {
  const ChatTextFieldGhost(
      {Key? key, required this.ontapSend, required this.chatController})
      : super(key: key);
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
              hintText: strSaySomething,
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
                                    chat.getPhoto();
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
                                                chat.getVideo();
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
                                                chat.getPhoto();
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
                                                chat.getMedia();
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
                                'Please enable ghost mode in order to send attachment');
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
            onEditingComplete: () => FocusScope.of(context).unfocus(),
          ),
        );
      },
    );
  }
}
