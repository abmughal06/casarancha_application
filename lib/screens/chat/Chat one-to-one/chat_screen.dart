// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/message.dart';

import 'package:casarancha/models/post_creator_details.dart';
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

    return SafeArea(
      child: Scaffold(
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
          title: StreamBuilder(
              stream: chatController.appUserRef.snapshots(),
              builder: (context, snapshot) {
                return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(creatorDetails.name),
                    subtitle: snapshot.hasData ? Text('Live') : null,
                    leading: CircleAvatar(
                      backgroundImage: creatorDetails.imageUrl.isEmpty
                          ? null
                          : CachedNetworkImageProvider(
                              creatorDetails.imageUrl,
                            ),
                      child: creatorDetails.imageUrl.isEmpty
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
                    : FirestoreListView(
                        query: chatController.currentUserRef
                            .collection('messageList')
                            .doc(appUserId)
                            .collection(
                              'messages',
                            )
                            .orderBy(
                              'createdAt',
                              descending: true,
                            ),
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.all(10.h),
                        itemBuilder: (context,
                            QueryDocumentSnapshot<Map<String, dynamic>> doc) {
                          final Message message = Message.fromMap(doc.data());
                          final isMe = message.sentToId == appUserId;
                          final isSeen = message.isSeen;
                          return ChatTile(
                            // key: UniqueKey(),
                            message: message,
                            appUserId: appUserId,
                            isSeen: isSeen,
                            isMe: isMe,
                          );
                        },
                        // separatorBuilder: (BuildContext context, int index) {
                        //   return message[index].separateTime != null
                        //       ? Center(
                        //           child: Padding(
                        //             padding: EdgeInsets.symmetric(vertical: 18.h),
                        //             child: TextWidget(
                        //               text: message[index].separateTime,
                        //               color: color221,
                        //               fontSize: 11.sp,
                        //             ),
                        //           ),
                        //         )
                        //       : Container();
                        // },
                      ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
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
          ],
        ),
      ),
    );
  }
}

class ChatTile extends StatefulWidget {
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

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  late String dateText;
  @override
  void initState() {
    dateText = timeago.format(
      DateTime.parse(
        widget.message.createdAt,
      ),
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.message.sentById)
        .collection('messageList')
        .doc(widget.message.sentToId)
        .collection('messages')
        .doc(widget.message.id)
        .update({'isSeen': true});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: widget.isMe ? Alignment.topRight : Alignment.topLeft,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(
                      widget.isMe ? 16.r : 0,
                    ),
                    bottomRight: Radius.circular(
                      widget.isMe ? 0 : 16.r,
                    )),
                color: (widget.isMe ? colorF03 : colorFF4),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: TextWidget(
                text: widget.message.content,
                color: widget.isMe ? color13F : color55F,
                fontWeight: FontWeight.w500,
              )),
        ),
        Align(
          alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.isMe
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: widget.message.isSeen
                          ? SvgPicture.asset(icChatMsgSend)
                          : null,
                    )
                  : Container(),
              TextWidget(
                text: dateText,
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
