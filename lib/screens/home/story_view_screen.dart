import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
import '../chat/GhostMode/ghost_chat_screen.dart';

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

  countStoryViews() async {
    log("story play");
    var ref =
        FirebaseFirestore.instance.collection("stories").doc(widget.story.id);
    var data = await ref.get();
    List<dynamic> array = data.data()!['mediaDetailsList'];
    log("=========================> ${array.length}");

    for (var e = 0; e < array.length; e++) {
      var media = MediaDetails.fromMap(array[e]);
      if (media.id == storyItems[currentIndex.value].id) {
        if (!media.storyViews!
            .contains(FirebaseAuth.instance.currentUser!.uid)) {
          log("----------------- barabar");

          List prevId = media.storyViews!.toList();
          List viewid = [FirebaseAuth.instance.currentUser!.uid];
          media = media.type == 'Photo'
              ? MediaDetails(
                  id: media.id,
                  name: media.name,
                  type: media.type,
                  link: media.link,
                  imageHeight: media.imageHeight,
                  imageWidth: media.imageWidth,
                  storyViews: prevId + viewid,
                )
              : media.type == 'Video'
                  ? MediaDetails(
                      id: media.id,
                      name: media.name,
                      type: media.type,
                      link: media.link,
                      storyViews: prevId + viewid,
                      videoAspectRatio: media.videoAspectRatio,
                      videoViews: media.videoViews,
                    )
                  : MediaDetails(
                      id: media.id,
                      name: media.name,
                      type: media.type,
                      link: media.link,
                      storyViews: prevId + viewid,
                    );
          print(media);
          array[e] = media.toMap();
        }
      }
    }

    ref.update({'mediaDetailsList': array});
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
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("stories")
              .doc(widget.story.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var storyModel = Story.fromMap(snapshot.data!.data()!);

              storyItems = storyModel.mediaDetailsList
                  .where((element) =>
                      DateTime.parse(element.id).isAfter(twentyFourHoursAgo))
                  .toList();
              return Stack(
                children: [
                  StoryView(
                      storyItems: [
                        ...storyItems.asMap().entries.map((e) {
                          print("==============  ${e.value.type}");
                          return e.value.type == "Photo"
                              ? StoryItem.pageImage(
                                  key: ValueKey(e.key),
                                  url: e.value.link,
                                  duration: const Duration(seconds: 6),
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

                        if (mounted) {
                          await countStoryViews();
                        }

                        log("=============================== > ${s.view.key}");
                      },
                      onVerticalSwipeComplete: (direction) {
                        if (direction == Direction.down) {
                          Get.back();
                          // currentIndex.value++;
                        }
                      }),
                  Visibility(
                    visible: widget.story.creatorId !=
                        FirebaseAuth.instance.currentUser!.uid,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                      child: Obx(
                        () => profileImgName(
                          imgUserNet: widget.story.creatorDetails.imageUrl,
                          isVerifyWithIc:
                              widget.story.creatorDetails.isVerified,
                          isVerifyWithName: false,
                          idIsVerified: widget.story.creatorDetails.isVerified,
                          dpRadius: 17.r,
                          userName: widget.story.creatorDetails.name,
                          userNameClr: colorWhite,
                          userNameFontSize: 12.sp,
                          userNameFontWeight: FontWeight.w600,
                          subText: convertDateIntoTime(
                              storyItems[currentIndex.value].id),
                          subTxtFontSize: 9.sp,
                          subTxtClr: colorWhite.withOpacity(.5),
                        ),
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
                  Visibility(
                    visible: widget.story.creatorId ==
                        FirebaseAuth.instance.currentUser!.uid,
                    child: Padding(
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
                              Get.bottomSheet(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: StreamBuilder<
                                      QuerySnapshot<Map<String, dynamic>>>(
                                    stream: storyItems[currentIndex.value]
                                            .storyViews!
                                            .isEmpty
                                        ? FirebaseFirestore.instance
                                            .collection("users")
                                            .where("id",
                                                arrayContains:
                                                    widget.story.storyViews)
                                            .snapshots()
                                        : FirebaseFirestore.instance
                                            .collection("users")
                                            .where("id",
                                                whereIn: storyItems[
                                                        currentIndex.value]
                                                    .storyViews)
                                            .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.docs.isNotEmpty) {
                                          return ListView.builder(
                                              itemCount:
                                                  snapshot.data!.docs.length,
                                              itemBuilder: (context, index) {
                                                var userModel =
                                                    UserModel.fromMap(snapshot
                                                        .data!.docs[index]
                                                        .data());
                                                return ListTile(
                                                  leading: Container(
                                                    height: 46.h,
                                                    width: 46.h,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.amber,
                                                      image: DecorationImage(
                                                        image:
                                                            CachedNetworkImageProvider(
                                                                userModel
                                                                    .imageStr),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  title: RichText(
                                                    text: TextSpan(
                                                      text: "",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12.sp,
                                                          color: const Color(
                                                              0xff5F5F5F)),
                                                      children: [
                                                        TextSpan(
                                                          text: userModel
                                                                  .isVerified
                                                              ? userModel.name
                                                              : "${userModel.name} ",
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xff121F3F),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14.sp,
                                                          ),
                                                        ),
                                                        WidgetSpan(
                                                          child: Visibility(
                                                            visible: userModel
                                                                .isVerified,
                                                            child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        4.0),
                                                                child: SvgPicture
                                                                    .asset(
                                                                        icVerifyBadge)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Text(
                                                      userModel.username,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12.sp,
                                                          color: const Color(
                                                              0xff5F5F5F)),
                                                    ),
                                                  ),
                                                );
                                              });
                                        } else {
                                          return const Center(
                                            child: Text("No Views"),
                                          );
                                        }
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                ),
                              );
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

                                  print("last");
                                  var ref1 = FirebaseFirestore.instance
                                      .collection("stories")
                                      .doc(widget.story.creatorId);
                                  var ref = await ref1.get();

                                  List<dynamic> storyRef =
                                      ref.data()!['mediaDetailsList'];

                                  storyRef.removeWhere((element) =>
                                      element['id'] ==
                                      storyItems[currentIndex.value].id);

                                  await ref1
                                      .update({"mediaDetailsList": storyRef});
                                } else {
                                  var ref1 = FirebaseFirestore.instance
                                      .collection("stories")
                                      .doc(widget.story.creatorId);
                                  var ref = await ref1.get();

                                  List<dynamic> storyRef =
                                      ref.data()!['mediaDetailsList'];

                                  storyRef.removeWhere((element) =>
                                      element['id'] ==
                                      storyItems[currentIndex.value].id);
                                  await ref1
                                      .update({"mediaDetailsList": storyRef});
                                  controller!.next();
                                }
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.story.creatorId !=
                        FirebaseAuth.instance.currentUser!.uid,
                    child: Align(
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
                                    print(
                                        "comment == ${commentController.text}");

                                    final messageRefForCurrentUser =
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection('messageList')
                                            .doc(widget.story.creatorId)
                                            .collection('messages')
                                            .doc();

                                    final messageRefForAppUser =
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(widget.story.creatorId)
                                            .collection('messageList')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection('messages')
                                            .doc(
                                              messageRefForCurrentUser.id,
                                            );

                                    var story = storyItems.toList();
                                    var mediaDetail =
                                        story[currentIndex.value].toMap();

                                    final Message message = Message(
                                      id: messageRefForCurrentUser.id,
                                      sentToId: widget.story.creatorId,
                                      sentById: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      content: mediaDetail,
                                      caption: commentController.text,
                                      type:
                                          "story-${story[currentIndex.value].type}",
                                      createdAt:
                                          DateTime.now().toIso8601String(),
                                      isSeen: false,
                                    );
                                    print(
                                        "============= ------------------- ------- --= ====== ==== $message");
                                    final appUserMessage = message.copyWith(
                                        id: messageRefForAppUser.id);

                                    messageRefForCurrentUser
                                        .set(message.toMap())
                                        .then((value) => print(
                                            "=========== XXXXXXXXXXXXXXXX ++++++++++ message sent success"));
                                    messageRefForAppUser
                                        .set(appUserMessage.toMap());
                                    var recieverRef = await FirebaseFirestore
                                        .instance
                                        .collection("users")
                                        .doc(widget.story.creatorId)
                                        .get();

                                    var recieverFCMToken =
                                        recieverRef.data()!['fcmToken'];
                                    print(
                                        "=========> reciever fcm token = $recieverFCMToken");
                                    FirebaseMessagingService()
                                        .sendNotificationToUser(
                                      appUserId: recieverRef.id,
                                      imageUrl: storyItems[currentIndex.value]
                                                  .type ==
                                              'Photo'
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
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Center(
                child: TextWidget(
                  text: "No Stories to show",
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
