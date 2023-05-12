// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/message.dart';

import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';

import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/chat/video_call_screen.dart';

import '../../../resources/image_resources.dart';
import '../../../resources/localization_text_strings.dart';
import '../../../resources/strings.dart';
import '../../../widgets/clip_pad_shadow.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/text_widget.dart';
import '../audio_call_screen.dart';

class ChatScreen extends StatelessWidget {
  final String appUserId;
  final CreatorDetails creatorDetails;

  const ChatScreen(
      {Key? key, required this.appUserId, required this.creatorDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(
      ChatController(appUserId: appUserId, creatorDetails: creatorDetails),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
          ),
          onPressed: () {
            chatController.resetMessageCount();
            Get.back();
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(appUserId)
                .snapshots(),
            builder: (context, snapshot) {
              UserModel userModel = UserModel.fromMap(snapshot.data!.data()!);
              return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(userModel.name),
                  subtitle: snapshot.hasData ? const Text('Live') : null,
                  leading: CircleAvatar(
                    backgroundImage: userModel.imageStr.isEmpty
                        ? null
                        : CachedNetworkImageProvider(
                            userModel.imageStr,
                          ),
                    child: userModel.imageStr.isEmpty
                        ? const Icon(
                            Icons.question_mark,
                          )
                        : null,
                  ));
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: svgImgButton(
                svgIcon: icChatVideo,
                onTap: () {
                  Get.to(
                    () => const VideoCallScreen(),
                  );
                }),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 20.w),
            child: svgImgButton(
                svgIcon: icChatCall,
                onTap: () {
                  Get.to(
                    () => const AudioCallScreen(),
                  );
                }),
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: chatController.isChecking.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: chatController.currentUserRef
                          .collection('messageList')
                          .doc(appUserId)
                          .collection(
                            'messages',
                          )
                          .orderBy(
                            'createdAt',
                            descending: true,
                          )
                          .snapshots(),
                      // reverse: true,
                      // physics: const BouncingScrollPhysics(),
                      // padding: EdgeInsets.all(10.h),
                      builder: (context, doc) {
                        if (doc.hasData) {
                          return ListView.builder(
                              itemCount: doc.data!.docs.length,
                              itemBuilder: (context, index) {
                                final Message message = Message.fromMap(
                                    doc.data!.docs[index].data());
                                final isMe = message.sentToId == appUserId;
                                final isSeen = message.isSeen;
                                return ChatTile(
                                  // key: UniqueKey(),
                                  message: message,
                                  appUserId: appUserId,
                                  isSeen: isSeen,
                                  isMe: isMe,
                                );
                              });
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: Platform.isIOS ? 40 : 10),
              child: ClipRect(
                clipper: const ClipPad(padding: EdgeInsets.only(top: 30)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(color: colorWhite, boxShadow: [
                    BoxShadow(
                      color: colorPrimaryA05.withOpacity(.36),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(4, 0),
                    ),
                  ]),
                  child: TextField(
                    minLines: 1,
                    maxLines: 3,
                    controller: chatController.messageController,
                    style: TextStyle(
                      color: color239,
                      fontSize: 16.sp,
                      fontFamily: strFontName,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLength: 1500,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: strSaySomething,
                      hintStyle: TextStyle(
                        color: color55F,
                        fontSize: 14.sp,
                        fontFamily: strFontName,
                        fontWeight: FontWeight.w400,
                      ),
                      suffixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // GestureDetector(
                              //   onTap: () {
                              //     print(chatController.isChatExits.value);
                              //   },
                              //   child: svgImgButton(
                              //     svgIcon: icChatPaperClip,
                              //   ),
                              // ),
                              widthBox(12.w),
                              GestureDetector(
                                onTap: () => chatController.sentMessage(),
                                child: Image.asset(
                                  imgSendComment,
                                  height: 38.h,
                                  width: 38.w,
                                ),
                              ),
                            ],
                          )),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 20.h),
                      focusColor: Colors.transparent,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key? key,
    required this.message,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
  }) : super(key: key);

  final Message message;
  final bool isMe;
  final bool isSeen;
  final String appUserId;

  // String? dateText;
  // @override
  // void initState() {
  //   dateText = timeago.format(
  //     DateTime.parse(
  //       message.createdAt,
  //     ),
  //   );

  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(message.sentById)
  //       .collection('messageList')
  //       .doc(message.sentToId)
  //       .collection('messages')
  //       .doc(message.id)
  //       .update({'isSeen': true});

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: isMe ? 70 : 0, right: isMe ? 0 : 70),
            child: Align(
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                        bottomLeft: Radius.circular(
                          isMe ? 16.r : 0,
                        ),
                        bottomRight: Radius.circular(
                          isMe ? 0 : 16.r,
                        )),
                    color: (isMe ? colorF03 : colorFF4),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                  child: TextWidget(
                    text: message.content,
                    color: isMe ? color13F : color55F,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ),
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isMe
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: message.isSeen
                            ? SvgPicture.asset(icChatMsgSend)
                            : null,
                      )
                    : Container(),
                TextWidget(
                  text: timeago.format(
                    DateTime.parse(
                      message.createdAt,
                    ),
                  ),
                  color: colorAA3,
                  fontSize: 11.sp,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}

class ChatMessage {
  String msgText;
  String time;
  bool isSendByMe;
  String? separateTime;
  ChatMessage({
    required this.msgText,
    required this.time,
    required this.isSendByMe,
    this.separateTime,
  });
}
