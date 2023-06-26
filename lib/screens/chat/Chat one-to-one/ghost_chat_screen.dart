// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:casarancha/screens/home/post_detail_screen.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/PostCard/PostCardController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:video_player/video_player.dart';
import '../../../resources/image_resources.dart';
import '../../../resources/localization_text_strings.dart';
import '../../../resources/strings.dart';
import '../../../widgets/clip_pad_shadow.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/text_widget.dart';
import '../../profile/ProfileScreen/profile_screen_controller.dart';
import '../ChatList/chat_list_controller.dart';

class GhostChatScreen2 extends StatefulWidget {
  final String appUserId;
  final CreatorDetails creatorDetails;
  final ProfileScreenController? profileScreenController;
  final String? val;

  const GhostChatScreen2({
    Key? key,
    required this.appUserId,
    required this.creatorDetails,
    this.profileScreenController,
    this.val,
    //required this.indexId
  }) : super(key: key);

  @override
  State<GhostChatScreen2> createState() => _GhostChatScreen2State();
}

class _GhostChatScreen2State extends State<GhostChatScreen2> {
  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(
      ChatController(
          appUserId: widget.appUserId, creatorDetails: widget.creatorDetails),
    );
    final ChatListController chatListController = Get.find();

    chatController.resetMessageCountGhost();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
          ),
          onPressed: () {
            chatController.resetMessageCountGhost();
            Get.back();
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(widget.appUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // UserModel userModel = UserModel.fromMap(snapshot.data!.data()!);
                return ListTile(
                  onTap: () {
                    // Get.to(
                    //   () => AppUserScreen(
                    //     appUserController: Get.put(
                    //       AppUserController(
                    //         appUserId: widget.appUserId,
                    //         currentUserId:
                    //             FirebaseAuth.instance.currentUser!.uid,
                    //       ),
                    //     ),
                    //   ),
                    // );
                    GlobalSnackBar.show(
                      message: "you can't see sender profile in ghost messages",
                    );
                  },
                  horizontalTitleGap: 10,
                  contentPadding: EdgeInsets.zero,
                  title: widget.val!.isEmpty
                      ? TextWidget(text: generateRandomString(7))
                      : TextWidget(text: widget.val.toString()),
                  subtitle: snapshot.hasData ? const Text('Live') : null,
                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.question_mark,
                    ),
                  ),
                );
              } else {
                return const Text("...");
              }
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: svgImgButton(
                svgIcon: icChatVideo,
                onTap: () {
                  // Get.to(
                  //   () => const VideoCallScreen(),
                  // );
                  GlobalSnackBar.show(message: "Comming Soon");
                }),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 20.w),
            child: svgImgButton(
                svgIcon: icChatCall,
                onTap: () {
                  // Get.to(
                  //   () => const AudioCallScreen(),
                  // );
                  GlobalSnackBar.show(message: "Comming Soon");
                }),
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: chatController.currentUserRef
                .collection("ghostMessageList")
                .doc(widget.appUserId)
                .collection(
                  'messages',
                )
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),
            builder: (context, doc) {
              if (doc.hasData) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: doc.data!.docs.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.appUserId)
                            .collection("ghostMessageList")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("messages")
                            .doc(doc.data!.docs[index].id)
                            .update({
                          'isSeen': true,
                        });
                        final Message message =
                            Message.fromMap(doc.data!.docs[index].data());
                        final isMe = message.sentToId == widget.appUserId;
                        final isSeen = message.isSeen;

                        print(
                            "=========== ----------- ============ >>>>> $isSeen");

                        if (message.type == "Photo" ||
                            message.type == "Qoute") {
                          final prePost = doc.data!.docs[index].data();
                          print(prePost);
                          final postModel =
                              PostModel.fromMap(prePost['content']);
                          print(postModel);
                          return InkWell(
                            onTap: () => Get.to(() => PostDetailScreen(
                                  postModel: postModel,
                                  postCardController:
                                      PostCardController(postdata: postModel),
                                )),
                            child: ChatPostTile(
                              message: message,
                              appUserId: widget.appUserId,
                              isSeen: isSeen,
                              isMe: isMe,
                            ),
                          );

                          // return Text("sda  $index");
                          // return Container();
                        } else if (message.type == "Text") {
                          return ChatTile(
                            message: message.content,
                            appUserId: widget.appUserId,
                            isSeen: message.isSeen,
                            isMe: isMe,
                            date: message.createdAt,
                          );
                        } else if (message.type == "Video") {
                          final prePost = doc.data!.docs[index].data();
                          print(prePost);
                          final postModel =
                              PostModel.fromMap(prePost['content']);
                          print(postModel);
                          VideoPlayerController videoPlayerController;
                          videoPlayerController = VideoPlayerController.network(
                              postModel.mediaData[0].link);
                          // videoPlayerController.initialize();
                          return InkWell(
                            onTap: () => Get.to(() => PostDetailScreen(
                                postModel: postModel,
                                postCardController:
                                    PostCardController(postdata: postModel))),
                            child: ChatVideoTile(
                              aspectRatio:
                                  videoPlayerController.value.aspectRatio,
                              appUserId: widget.appUserId,
                              isSeen: message.isSeen,
                              isMe: isMe,
                              date: message.createdAt,
                              videoPlayerController: videoPlayerController,
                            ),
                          );
                        } else if (message.type == "story-Video") {
                          final postModel =
                              MediaDetails.fromMap(message.content);
                          print(postModel);
                          VideoPlayerController videoPlayerController;
                          videoPlayerController =
                              VideoPlayerController.network(postModel.link);
                          // videoPlayerController.initialize();
                          return ChatVideoTile(
                            aspectRatio:
                                videoPlayerController.value.aspectRatio,
                            appUserId: widget.appUserId,
                            isSeen: message.isSeen,
                            isMe: isMe,
                            date: message.createdAt,
                            videoPlayerController: videoPlayerController,
                          );
                        } else if (message.type == "story-Photo") {
                          var story = MediaDetails.fromMap(message.content);

                          return ChatStoryTile(
                            message: message,
                            appUserId: widget.appUserId,
                            isSeen: isSeen,
                            isMe: isMe,
                          );
                        } else {
                          return Container();
                        }
                      }),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
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
                              widthBox(12.w),
                              GestureDetector(
                                onTap: () {
                                  if (chatListController.profileScreenController
                                      .isGhostModeOn.value) {
                                    chatController.sentMessageGhost();
                                  } else {
                                    GlobalSnackBar.show(
                                        message:
                                            "You need to enable ghost mode to send message, you can only receive messages when the ghost mode is disabled");
                                  }
                                },
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
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
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
    required this.date,
  }) : super(key: key);

  final String message;
  final bool isMe;
  final bool isSeen;
  final String appUserId;
  final String date;

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
                    color: (isMe ? colorF03.withOpacity(0.6) : colorFF4),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                  child: TextWidget(
                    text: message,
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
                        child: isSeen
                            ? SvgPicture.asset(
                                icChatMsgSend,
                              )
                            : SvgPicture.asset(
                                icChatMsgSend,
                                color: Colors.black.withOpacity(0.5),
                              ),
                      )
                    : Container(),
                TextWidget(
                  text: convertDateIntoTime(date),
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

class ChatVideoTile extends StatefulWidget {
  const ChatVideoTile({
    Key? key,
    required this.appUserId,
    required this.isMe,
    required this.isSeen,
    required this.date,
    required this.videoPlayerController,
    required this.aspectRatio,
  }) : super(key: key);

  final bool isMe;
  final bool isSeen;
  final String appUserId;
  final String date;
  final VideoPlayerController videoPlayerController;
  final double aspectRatio;

  @override
  State<ChatVideoTile> createState() => _ChatVideoTileState();
}

class _ChatVideoTileState extends State<ChatVideoTile> {
  @override
  void initState() {
    // TODO: implement //s
    super.initState();
    widget.videoPlayerController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: widget.isMe ? 70 : 0, right: widget.isMe ? 0 : 70),
            child: Align(
              alignment: widget.isMe ? Alignment.topRight : Alignment.topLeft,
              child: AspectRatio(
                aspectRatio: widget.aspectRatio,
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
                      color:
                          (widget.isMe ? colorF03.withOpacity(0.6) : colorFF4),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                    child: VideoPlayer(widget.videoPlayerController)),
              ),
            ),
          ),
          Align(
            alignment:
                widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.isMe
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: widget.isSeen
                            ? SvgPicture.asset(icChatMsgSend)
                            : null,
                      )
                    : Container(),
                TextWidget(
                  text: convertDateIntoTime(widget.date),
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

class ChatPostTile extends StatelessWidget {
  const ChatPostTile({
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
                    color: (isMe ? colorF03.withOpacity(0.6) : colorFF4),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                  child: message.type == "Photo"
                      ? CachedNetworkImage(
                          imageUrl: message.content['mediaData'][0]['link'],
                          // color: isMe ? color13F : color55F,
                          // fontWeight: FontWeight.w500,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 50,
                          ),
                          child: Center(
                            child: Text(
                              message.content['mediaData'][0]['link'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: color221,
                              ),
                            ),
                          ),
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
                  text: convertDateIntoTime(message.createdAt),
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

class ChatStoryTile extends StatelessWidget {
  const ChatStoryTile({
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
  Widget build(BuildContext context) {
    final story = MediaDetails.fromMap(message.content);
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
                    color: (isMe ? colorF03.withOpacity(0.6) : colorFF4),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: story.link,
                        // color: isMe ? color13F : color55F,
                        // fontWeight: FontWeight.w500,
                      ),
                      message.caption != ""
                          ? const SizedBox(height: 5)
                          : const SizedBox(
                              height: 0,
                            ),
                      message.caption != ""
                          ? Text(
                              message.caption,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                            )
                    ],
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
                  text: convertDateIntoTime(message.createdAt),
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
