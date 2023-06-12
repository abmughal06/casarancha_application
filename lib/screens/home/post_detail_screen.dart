import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/screens/home/HomeScreen/home_screen.dart';
import 'package:casarancha/widgets/PostCard/PostCardController.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../models/comment_model.dart';
import '../../models/post_creator_details.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/firebase_cloud_messaging.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';
import '../../widgets/clip_pad_shadow.dart';
import '../../widgets/comment_screen.dart';
import '../../widgets/text_editing_widget.dart';
import '../../widgets/text_widget.dart';
import '../chat/GhostMode/ghost_chat_screen.dart';
import '../chat/share_post_screen.dart';

import 'package:timeago/timeago.dart' as timeago;

import '../profile/AppUser/app_user_controller.dart';
import '../profile/AppUser/app_user_screen.dart';

class PostDetailScreen extends StatefulWidget {
  PostDetailScreen(
      {Key? key, required this.postModel, required this.postCardController})
      : super(key: key);
  final PostModel postModel;
  PostCardController? postCardController;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final coommenController = TextEditingController();

  Future<void>? iniializedFuturePlay;

  VideoPlayerController? videoPlayerController;
  @override
  void dispose() {
    super.dispose();
    if (widget.postModel.mediaData[0].type == "Video") {
      videoPlayerController!.pause();
      videoPlayerController!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .doc(widget.postModel.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var p = snapshot.data!.data();
                        var post = PostModel.fromMap(p!);
                        return Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 2 / 3,
                              child: Stack(
                                children: [
                                  ListView.builder(
                                    itemCount: post.mediaData.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      widget.postCardController =
                                          PostCardController(postdata: post);
                                      var mediaData = post.mediaData[index];
                                      if (mediaData.type == 'Photo') {
                                        return InkWell(
                                            onDoubleTap: () {
                                              print("clicked");
                                              widget.postCardController!.isLiked
                                                      .value =
                                                  !post.likesIds.contains(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid);
                                              widget.postCardController!
                                                  .likeDisLikePost(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      post.id,
                                                      post.creatorId);
                                            },
                                            child: AspectRatio(
                                              aspectRatio: 2 / 3,
                                              child: CachedNetworkImage(
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              progress) =>
                                                          Center(
                                                            child: SizedBox(
                                                              height: 30.h,
                                                              child:
                                                                  const CircularProgressIndicator(),
                                                            ),
                                                          ),
                                                  imageUrl: mediaData.link),
                                            ));
                                      } else if (mediaData.type == 'Video') {
                                        print("============ ${mediaData.link}");
                                        return FutureBuilder(
                                            future: iniializedFuturePlay,
                                            builder: (context, snap) {
                                              videoPlayerController =
                                                  VideoPlayerController.network(
                                                      mediaData.link);
                                              // videoPlayerController
                                              //     .initialize();
                                              print(mediaData.link);
                                              // videoPlayerController!.play();
                                              var chweieController =
                                                  ChewieController(
                                                videoPlayerController:
                                                    videoPlayerController!,
                                                aspectRatio: 9 / 16,
                                                looping: true,
                                                autoPlay: true,
                                                zoomAndPan: true,
                                              );

                                              return InkWell(
                                                onLongPress: () {
                                                  videoPlayerController!
                                                      .pause();
                                                },
                                                onTap: () {
                                                  videoPlayerController!.play();
                                                },
                                                child: AspectRatio(
                                                    aspectRatio: 2 / 3,
                                                    child: Chewie(
                                                      controller:
                                                          chweieController,
                                                    )),
                                              );
                                            });
                                      } else {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 40,
                                            vertical: 50,
                                          ),
                                          child: Center(
                                            child: Text(
                                              mediaData.link,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                                color: color221,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  Positioned(
                                      top: 40,
                                      left: 20,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Colors.white.withOpacity(0.45),
                                        child: InkWell(
                                            child: const Icon(
                                              Icons.navigate_before,
                                              color: Colors.black,
                                            ),
                                            onTap: () => Get.back()),
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(25.r),
                                      bottomLeft: Radius.circular(25.r)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorPrimaryA05.withOpacity(.10),
                                      blurRadius: 2,
                                      offset: const Offset(0, 3),
                                    ),
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                    ),
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                    )
                                  ]),
                              child: Column(
                                children: [
                                  CustomPostFooter(
                                    likes: post.likesIds.length.toString(),
                                    isLike: post.likesIds.contains(
                                        FirebaseAuth.instance.currentUser!.uid),
                                    isPostDetail: true,
                                    ontapLike: () {
                                      print("clicked");

                                      widget.postCardController!.isLiked.value =
                                          !post.likesIds.contains(FirebaseAuth
                                              .instance.currentUser!.uid);
                                      widget.postCardController!
                                          .likeDisLikePost(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              post.id,
                                              post.creatorId);
                                      // Get.back();
                                    },
                                    saveBtn: StreamBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var userData = snapshot.data!.data();
                                          var userModel =
                                              UserModel.fromMap(userData!);
                                          return IconButton(
                                            onPressed: () {
                                              if (userModel.savedPostsIds
                                                  .contains(post.id)) {
                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(userModel.id)
                                                    .update({
                                                  'savedPostsIds':
                                                      FieldValue.arrayRemove(
                                                          [post.id])
                                                });
                                              } else {
                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(userModel.id)
                                                    .update({
                                                  'savedPostsIds':
                                                      FieldValue.arrayUnion(
                                                          [post.id])
                                                });
                                              }
                                            },
                                            icon: Image.asset(
                                              postSave,
                                              color: userModel.savedPostsIds
                                                      .contains(post.id)
                                                  ? Colors.red
                                                  : null,
                                            ),
                                          );
                                        } else {
                                          return Image.asset(postSave);
                                        }
                                      },
                                    ),
                                    ontapShare: () {
                                      Get.to(() => SharePostScreen(
                                            postModel: PostModel(
                                              id: post.id,
                                              creatorId: post.creatorId,
                                              creatorDetails:
                                                  post.creatorDetails,
                                              createdAt: post.createdAt,
                                              description: post.description,
                                              locationName: post.locationName,
                                              shareLink: post.shareLink,
                                              mediaData: post.mediaData,
                                              tagsIds: post.tagsIds,
                                              likesIds: post.likesIds,
                                              showPostTime: post.showPostTime,
                                              postBlockStatus:
                                                  post.postBlockStatus,
                                              commentIds: post.commentIds,
                                            ),
                                          ));
                                    },
                                    ontapCmnt: () {
                                      print("dsald");
                                    },
                                    comments: post.commentIds.length,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.to(
                                              () => AppUserScreen(
                                                appUserController: Get.put(
                                                  AppUserController(
                                                    appUserId: post.creatorId,
                                                    currentUserId: FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 34.h,
                                                width: 34.h,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: 30.h,
                                                      width: 30.h,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image:
                                                              CachedNetworkImageProvider(
                                                            post.creatorDetails
                                                                .imageUrl,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: post
                                                          .creatorDetails
                                                          .isVerified,
                                                      child: Positioned(
                                                        bottom: 0,
                                                        right: 0,
                                                        child: SvgPicture.asset(
                                                            icVerifyBadge),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              widthBox(7.w),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextWidget(
                                                    text: post
                                                        .creatorDetails.name,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                  TextWidget(
                                                    text: timeago.format(
                                                      DateTime.parse(
                                                          post.createdAt),
                                                    ),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 9.sp,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: post.description.isNotEmpty,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              heightBox(11.h),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 2.h),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: TextWidget(
                                                    text: post.description,
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        const Color(0xff5f5f5f),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .doc(widget.postModel.id)
                        .collection("comments")
                        .orderBy("createdAt", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 24),
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index].data();
                            // var cDetail =
                            //     CreatorDetails.fromMap(data['creatorDetails']);
                            var cmnt = Comment.fromMap(data);
                            return ListTile(
                              isThreeLine: true,
                              leading: InkWell(
                                onTap: () {
                                  Get.to(
                                    () => AppUserScreen(
                                      appUserController: Get.put(
                                        AppUserController(
                                          appUserId: cmnt.creatorId,
                                          currentUserId: FirebaseAuth
                                              .instance.currentUser!.uid,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 46.h,
                                  width: 46.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.amber,
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          cmnt.creatorDetails.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              title: InkWell(
                                onTap: () {
                                  Get.to(
                                    () => AppUserScreen(
                                      appUserController: Get.put(
                                        AppUserController(
                                          appUserId: cmnt.creatorId,
                                          currentUserId: FirebaseAuth
                                              .instance.currentUser!.uid,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    TextWidget(
                                        text: cmnt.creatorDetails.name,
                                        fontSize: 14.sp,
                                        color: const Color(0xff212121),
                                        fontWeight: FontWeight.w600),
                                    widthBox(4.w),
                                    if (cmnt.creatorDetails.isVerified)
                                      SvgPicture.asset(icVerifyBadge),
                                    widthBox(8.w),
                                    Text(
                                      timeago.format(
                                        DateTime.parse(
                                          cmnt.createdAt,
                                        ),
                                      ),
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff5c5c5c)),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: TextWidget(
                                text:
                                    cmnt.message.isEmpty ? "---" : cmnt.message,
                                fontSize: 12.sp,
                                color: const Color(0xff5f5f5f),
                                fontWeight: FontWeight.w400,
                                textOverflow: TextOverflow.visible,
                              ),
                              trailing: Visibility(
                                visible: cmnt.creatorId ==
                                    FirebaseAuth.instance.currentUser!.uid,
                                child: InkWell(
                                  onTap: () {
                                    if (cmnt.creatorId ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid) {
                                      Get.bottomSheet(
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.red),
                                          height: 80,
                                          child: InkWell(
                                            onTap: () async {
                                              await FirebaseFirestore.instance
                                                  .collection("posts")
                                                  .doc(cmnt.id)
                                                  .collection("comments")
                                                  .doc(snapshot
                                                      .data!.docs[index].id)
                                                  .delete();

                                              await FirebaseFirestore.instance
                                                  .collection("posts")
                                                  .doc(cmnt.id)
                                                  .update({
                                                "commentIds":
                                                    FieldValue.arrayRemove([
                                                  snapshot.data!.docs[index].id
                                                ])
                                              });

                                              Get.back();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                  text: "Delete Comment",
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        isScrollControlled: true,
                                      );
                                    }
                                  },
                                  child: const Icon(
                                    Icons.more_vert,
                                    color: Color(0xffafafaf),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  heightBox(70.h),
                ],
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
                    controller: coommenController,
                    style: TextStyle(
                      color: color239,
                      fontSize: 16.sp,
                      fontFamily: strFontName,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: strWriteComment,
                      hintStyle: TextStyle(
                        color: color55F,
                        fontSize: 14.sp,
                        fontFamily: strFontName,
                        fontWeight: FontWeight.w400,
                      ),
                      suffixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: GestureDetector(
                              onTap: () {
                                var cmnt = Comment(
                                  id: widget.postModel.id,
                                  creatorId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  creatorDetails: CreatorDetails(
                                      name: user!.name,
                                      imageUrl: user!.imageStr,
                                      isVerified: user!.isVerified),
                                  createdAt: DateTime.now().toIso8601String(),
                                  message: coommenController.text,
                                );

                                FirebaseFirestore.instance
                                    .collection("posts")
                                    .doc(widget.postModel.id)
                                    .collection("comments")
                                    .doc()
                                    .set(cmnt.toMap(), SetOptions(merge: true))
                                    .then((value) async {
                                  coommenController.clear();
                                  var cmntId = await FirebaseFirestore.instance
                                      .collection("posts")
                                      .doc(widget.postModel.id)
                                      .collection("comments")
                                      .get();

                                  List listOfCommentsId = [];
                                  for (var i in cmntId.docs) {
                                    listOfCommentsId.add(i.id);
                                  }

                                  print(
                                      "+++========+++++++++============+++++++++ $listOfCommentsId ");
                                  FirebaseFirestore.instance
                                      .collection("posts")
                                      .doc(widget.postModel.id)
                                      .set({"commentIds": listOfCommentsId},
                                          SetOptions(merge: true));

                                  var recieverRef = await FirebaseFirestore
                                      .instance
                                      .collection("users")
                                      .doc(widget.postModel.creatorId)
                                      .get();

                                  var recieverFCMToken =
                                      recieverRef.data()!['fcmToken'];
                                  print(
                                      "=========> reciever fcm token = $recieverFCMToken");
                                  FirebaseMessagingService()
                                      .sendNotificationToUser(
                                    creatorDetails: CreatorDetails(
                                        name: cmnt.creatorDetails.name,
                                        imageUrl: cmnt.creatorDetails.imageUrl,
                                        isVerified:
                                            cmnt.creatorDetails.isVerified),
                                    devRegToken: recieverFCMToken,
                                    userReqID: widget.postModel.creatorId,
                                    title: user!.name,
                                    msg:
                                        "${user!.name} has commented on your post.",
                                  );
                                });
                              },
                              child: Image.asset(
                                imgSendComment,
                                height: 38.h,
                                width: 38.w,
                              ))),
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
                    minLines: 1,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
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
