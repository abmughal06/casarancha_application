import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';
import '../../models/ghost_message_details.dart';
import '../../models/message.dart';
import '../../models/message_details.dart';
import '../../models/post_creator_details.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/firebase_cloud_messaging.dart';
import '../../widgets/home_page_widgets.dart';
import '../../widgets/home_screen_widgets/story_textt_field.dart';

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
  var unreadMessageCount = 0;

  @override
  Widget build(BuildContext context) {
    controller = StoryController();
    final ghost = Provider.of<DashboardProvider>(context);
    storyItems = widget.story.mediaDetailsList
        .where((element) => isDateAfter24Hour(DateTime.parse(element.id)))
        .toList();
    final currentUser = context.watch<UserModel>();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            StoryView(
              storyItems: [
                ...storyItems.asMap().entries.map(
                  (e) {
                    return e.value.type == "Photo"
                        ? StoryItem.pageImage(
                            key: ValueKey(e.key),
                            url: e.value.link,
                            duration: const Duration(seconds: 10),
                            controller: controller!,
                          )
                        : StoryItem.pageVideo(e.value.link,
                            key: ValueKey(e.key),
                            controller: controller!,
                            duration: const Duration(seconds: 15));
                  },
                )
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
              },
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Get.back();
                }
              },
            ),
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
            StoryTextField(
              commentFocus: _commentFocus,
              onfocusChange: (hasFocus) {
                hasFocus ? controller!.pause() : controller!.play();
                setState(() {});
              },
              textEditingController: commentController,
              onchange: (c) {
                controller!.pause();
              },
              onFieldSubmitted: (val) {
                FocusScope.of(context).unfocus();
                commentController.text = "";
                controller!.play();
              },
              onEditCompleted: () {
                FocusScope.of(context).unfocus();
                commentController.text = "";
                controller!.play();
              },
              ontapSend: () async {
                if (ghost.checkGhostMode) {
                  final GhostMessageDetails appUserMessageDetails =
                      GhostMessageDetails(
                    id: widget.story.creatorId,
                    lastMessage: "Story",
                    unreadMessageCount: 0,
                    searchCharacters: [
                      ...widget.story.creatorDetails.name
                          .toLowerCase()
                          .split('')
                    ],
                    creatorDetails: widget.story.creatorDetails,
                    createdAt: DateTime.now().toIso8601String(),
                    firstMessage: currentUser.id,
                  );

                  final GhostMessageDetails currentUserMessageDetails =
                      GhostMessageDetails(
                    id: currentUser.id,
                    lastMessage: "Story",
                    unreadMessageCount: unreadMessageCount + 1,
                    searchCharacters: [
                      ...currentUser.name.toLowerCase().split('')
                    ],
                    creatorDetails: CreatorDetails(
                      name: currentUser.name,
                      imageUrl: currentUser.imageStr,
                      isVerified: currentUser.isVerified,
                    ),
                    createdAt: DateTime.now().toIso8601String(),
                    firstMessage: currentUser.id,
                  );

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.id)
                      .collection('ghostMessageList')
                      .doc(widget.story.creatorId)
                      .set(
                        appUserMessageDetails.toMap(),
                      );

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.story.creatorId)
                      .collection('ghostMessageList')
                      .doc(currentUser.id)
                      .set(
                        currentUserMessageDetails.toMap(),
                      );
                } else {
                  final MessageDetails appUserMessageDetails = MessageDetails(
                    id: widget.story.creatorId,
                    lastMessage: "Story",
                    unreadMessageCount: 0,
                    searchCharacters: [
                      ...widget.story.creatorDetails.name
                          .toLowerCase()
                          .split('')
                    ],
                    creatorDetails: widget.story.creatorDetails,
                    createdAt: DateTime.now().toIso8601String(),
                  );

                  final MessageDetails currentUserMessageDetails =
                      MessageDetails(
                    id: currentUser.id,
                    lastMessage: "Story",
                    unreadMessageCount: unreadMessageCount + 1,
                    searchCharacters: [
                      ...currentUser.name.toLowerCase().split('')
                    ],
                    creatorDetails: CreatorDetails(
                      name: currentUser.name,
                      imageUrl: currentUser.imageStr,
                      isVerified: currentUser.isVerified,
                    ),
                    createdAt: DateTime.now().toIso8601String(),
                  );

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.id)
                      .collection('messageList')
                      .doc(widget.story.creatorId)
                      .set(
                        appUserMessageDetails.toMap(),
                      );

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.story.creatorId)
                      .collection('messageList')
                      .doc(currentUser.id)
                      .set(
                        currentUserMessageDetails.toMap(),
                      );
                }
                final messageRefForCurrentUser = FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection(ghost.checkGhostMode
                        ? 'ghostMessageList'
                        : 'messageList')
                    .doc(widget.story.creatorId)
                    .collection('messages')
                    .doc();

                final messageRefForAppUser = FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.story.creatorId)
                    .collection(ghost.checkGhostMode
                        ? 'ghostMessageList'
                        : 'messageList')
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

                final appUserMessage =
                    message.copyWith(id: messageRefForAppUser.id);

                messageRefForCurrentUser.set(message.toMap());
                messageRefForAppUser.set(appUserMessage.toMap());
                var recieverRef = await FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.story.creatorId)
                    .get();

                var recieverFCMToken = recieverRef.data()!['fcmToken'];

                FirebaseMessagingService().sendNotificationToUser(
                  appUserId: recieverRef.id,
                  imageUrl: storyItems[currentIndex.value].type == 'Photo'
                      ? storyItems[currentIndex.value].link
                      : '',
                  notificationType: "msg",

                  isMessage: true,
                  // creatorDetails: creatorDetails,
                  devRegToken: recieverFCMToken,

                  msg: "has commented on your story",
                );
                _commentFocus.unfocus();
                commentController.text = "";
                controller!.play();
              },
            )
          ],
        ),
      ),
    );
  }
}

bool isDateAfter24Hour(DateTime date) {
  DateTime twentyFourHoursAgo =
      DateTime.now().subtract(const Duration(hours: 24));
  if (date.isAfter(twentyFourHoursAgo)) {
    return true;
  }
  return false;
}
