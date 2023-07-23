import 'dart:developer';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:casarancha/widgets/home_screen_widgets/story_views_widget.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:story_view/story_view.dart';
import '../../models/message.dart';
import '../../resources/color_resources.dart';
import '../../resources/firebase_cloud_messaging.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/home_page_widgets.dart';

class StoryViewScreen extends StatefulWidget {
  const StoryViewScreen({Key? key, required this.story}) : super(key: key);

  final Story story;

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  StoryController? controller;
  late TextEditingController commentController;
  final FocusNode _commentFocus = FocusNode();

  List<MediaDetails> storyItems = [];
  DateTime twentyFourHoursAgo =
      DateTime.now().subtract(const Duration(hours: 24));

  countStoryViews({required List<MediaDetails> mediaList}) async {
    var storyViewsList = mediaList[currentIndex.value].storyViews;

    if (!storyViewsList!.contains(FirebaseAuth.instance.currentUser!.uid)) {
      storyViewsList.add(FirebaseAuth.instance.currentUser!.uid);
      mediaList[currentIndex.value].storyViews = storyViewsList;

      var ref =
          FirebaseFirestore.instance.collection("stories").doc(widget.story.id);

      var media = mediaList.map((e) => e.toMap()).toList();
      ref.update({'mediaDetailsList': media});
    }
  }

  @override
  void initState() {
    super.initState();
    controller = StoryController();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    controller!.dispose();
    commentController.dispose();
    super.dispose();
    currentIndex.value = 0;
  }

  var currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    controller = StoryController();
    storyItems = widget.story.mediaDetailsList
        .where(
            (element) => DateTime.parse(element.id).isAfter(twentyFourHoursAgo))
        .toList();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            StoryView(
                storyItems: [
                  ...storyItems.asMap().entries.map((e) {
                    // print("==============  ${e.value.type}");
                    return e.value.type == "Photo"
                        ? StoryItem.pageImage(
                            key: ValueKey(e.key),
                            url: e.value.link,
                            duration: const Duration(seconds: 5),
                            controller: controller!,
                          )
                        : StoryItem.pageVideo(e.value.link,
                            key: ValueKey(e.key),
                            controller: controller!,
                            duration: const Duration(seconds: 15));
                  })
                ],
                controller: controller!,
                onComplete: () {
                  Get.back();
                },
                onStoryShow: (s) async {
                  currentIndex.value = int.parse(s.view.key
                      .toString()
                      .replaceAll("[", "")
                      .replaceAll("]", "")
                      .replaceAll("<", "")
                      .replaceAll(">", ""));
                  await countStoryViews(mediaList: storyItems);

                  log("=============================== > ${s.view.key}");
                },
                onVerticalSwipeComplete: (direction) {
                  if (direction == Direction.down) {
                    Get.back();
                    // currentIndex.value++;
                  }
                }),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
              child: Obx(
                () => profileImgName(
                  imgUserNet: widget.story.creatorDetails.imageUrl,
                  isVerifyWithName: false,
                  idIsVerified: widget.story.creatorDetails.isVerified,
                  dpRadius: 17.r,
                  userName: widget.story.creatorDetails.name,
                  userNameClr: colorWhite,
                  userNameFontSize: 12.sp,
                  userNameFontWeight: FontWeight.w600,
                  subText:
                      convertDateIntoTime(storyItems[currentIndex.value].id),
                  subTxtFontSize: 9.sp,
                  subTxtClr: colorWhite.withOpacity(.5),
                ),
              ),
            ),
            Visibility(
              visible: _commentFocus.hasFocus,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black87,
                ),
              ),
            ),
            Visibility(
              visible: !_commentFocus.hasFocus,
              child: Container(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Focus(
                  focusNode: _commentFocus,
                  onFocusChange: (hasFocus) {
                    hasFocus ? controller!.pause() : controller!.play();
                    setState(() {});
                  },
                  child: TextFormField(
                    controller: commentController,
                    onChanged: (val) {
                      controller!.pause();
                    },
                    style: TextStyle(
                      color: color887,
                      fontSize: 16.sp,
                      fontFamily: strFontName,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: strWriteCommentHere,
                      hintStyle: TextStyle(
                        color: color887,
                        fontSize: 14.sp,
                        fontFamily: strFontName,
                        fontWeight: FontWeight.w400,
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: svgImgButton(
                          svgIcon: icStoryCmtSend,
                          onTap: () async {
                            // print("comment == ${commentController.text}");

                            final messageRefForCurrentUser = FirebaseFirestore
                                .instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('messageList')
                                .doc(widget.story.creatorId)
                                .collection('messages')
                                .doc();

                            final messageRefForAppUser = FirebaseFirestore
                                .instance
                                .collection("users")
                                .doc(widget.story.creatorId)
                                .collection('messageList')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('messages')
                                .doc(
                                  messageRefForCurrentUser.id,
                                );

                            var story = storyItems.toList();
                            var mediaDetail = story[currentIndex.value].toMap();

                            final Message message = Message(
                              id: messageRefForCurrentUser.id,
                              sentToId: widget.story.creatorId,
                              sentById: FirebaseAuth.instance.currentUser!.uid,
                              content: mediaDetail,
                              caption: commentController.text,
                              type: "story-${story[currentIndex.value].type}",
                              createdAt: DateTime.now().toIso8601String(),
                              isSeen: false,
                            );
                            // print(
                            //     "============= ------------------- ------- --= ====== ==== $message");
                            final appUserMessage =
                                message.copyWith(id: messageRefForAppUser.id);

                            messageRefForCurrentUser.set(message.toMap());
                            messageRefForAppUser.set(appUserMessage.toMap());
                            var recieverRef = await FirebaseFirestore.instance
                                .collection("users")
                                .doc(widget.story.creatorId)
                                .get();

                            var recieverFCMToken =
                                recieverRef.data()!['fcmToken'];
                            // print(
                            //     "=========> reciever fcm token = $recieverFCMToken");
                            FirebaseMessagingService().sendNotificationToUser(
                              appUserId: recieverRef.id,
                              imageUrl:
                                  storyItems[currentIndex.value].type == 'Photo'
                                      ? storyItems[currentIndex.value].link
                                      : '',
                              // creatorDetails: creatorDetails,
                              devRegToken: recieverFCMToken,

                              msg: "has commented on your story",
                            );
                            _commentFocus.unfocus();
                            commentController.text = "";
                            controller!.play();
                          },
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: const BorderSide(
                          color: color887,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: const BorderSide(
                          color: color887,
                          width: 1.0,
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (val) {
                      FocusScope.of(context).unfocus();
                      commentController.text = "";
                      controller!.play();
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                      commentController.text = "";
                      controller!.play();
                    },
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

class MyStoryViewScreen extends StatefulWidget {
  const MyStoryViewScreen({Key? key, required this.story}) : super(key: key);

  final Story story;

  @override
  State<MyStoryViewScreen> createState() => _MyStoryViewScreenState();
}

class _MyStoryViewScreenState extends State<MyStoryViewScreen> {
  StoryController? controller;
  late TextEditingController commentController;
  final FocusNode _commentFocus = FocusNode();

  List<MediaDetails> storyItems = [];
  DateTime twentyFourHoursAgo =
      DateTime.now().subtract(const Duration(hours: 24));

  @override
  void initState() {
    super.initState();
    controller = StoryController();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    controller!.dispose();
    commentController.dispose();
    super.dispose();
    currentIndex.value = 0;
  }

  var currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    controller = StoryController();
    storyItems = widget.story.mediaDetailsList
        .where(
            (element) => DateTime.parse(element.id).isAfter(twentyFourHoursAgo))
        .toList();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            StoryView(
              storyItems: [
                ...storyItems.asMap().entries.map((e) {
                  // print("==============  ${e.value.type}");
                  return e.value.type == "Photo"
                      ? StoryItem.pageImage(
                          key: ValueKey(e.key),
                          url: e.value.link,
                          duration: const Duration(seconds: 5),
                          controller: controller!,
                        )
                      : StoryItem.pageVideo(e.value.link,
                          key: ValueKey(e.key),
                          controller: controller!,
                          duration: const Duration(seconds: 15));
                })
              ],
              controller: controller!,
              onComplete: () {
                Get.back();
              },
              onStoryShow: (s) async {
                currentIndex.value = int.parse(s.view.key
                    .toString()
                    .replaceAll("[", "")
                    .replaceAll("]", "")
                    .replaceAll("<", "")
                    .replaceAll(">", ""));
                log("=============================== > ${s.view.key}");
              },
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Get.back();
                }
              },
            ),
            Visibility(
              visible: _commentFocus.hasFocus,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black87,
                ),
              ),
            ),
            Visibility(
              visible: !_commentFocus.hasFocus,
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 1.5,
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      controller!.pause();
                      Get.bottomSheet(storyViews(story: widget.story));
                    },
                    child: SizedBox(
                      width: 100.w,
                      child: Row(
                        children: [
                          widthBox(10.w),
                          const Icon(
                            Icons.visibility,
                            color: color887,
                          ),
                          widthBox(5.w),
                          TextWidget(
                            text: storyItems[currentIndex.value]
                                .storyViews!
                                .length
                                .toString(),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: color887,
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (storyItems[currentIndex.value].id ==
                          storyItems.last.id) {
                        Get.back();

                        // print("last");
                        var ref1 = FirebaseFirestore.instance
                            .collection("stories")
                            .doc(widget.story.creatorId);
                        var ref = await ref1.get();

                        List<dynamic> storyRef =
                            ref.data()!['mediaDetailsList'];

                        storyRef.removeWhere((element) =>
                            element['id'] == storyItems[currentIndex.value].id);

                        await ref1.update({"mediaDetailsList": storyRef});
                      } else {
                        var ref1 = FirebaseFirestore.instance
                            .collection("stories")
                            .doc(widget.story.creatorId);
                        var ref = await ref1.get();

                        List<dynamic> storyRef =
                            ref.data()!['mediaDetailsList'];

                        storyRef.removeWhere((element) =>
                            element['id'] == storyItems[currentIndex.value].id);
                        await ref1.update({"mediaDetailsList": storyRef});
                        controller!.next();
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
