import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/music_player_url.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../models/comment_model.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';
import '../../widgets/clip_pad_shadow.dart';
import '../../widgets/home_screen_widgets/post_footer.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/video_player_url.dart';
import '../chat/share_post_screen.dart';
import '../profile/AppUser/app_user_screen.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({Key? key, required this.postModel}) : super(key: key);
  final PostModel postModel;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final coommenController = TextEditingController();

  Future<void>? iniializedFuturePlay;

  late Future<List<Comment>?>? _comment;

  DataProvider dataProvider = DataProvider();

  void getComments() {
    _comment = dataProvider.comment(widget.postModel.id);
  }

  @override
  void initState() {
    super.initState();
    getComments();
  }

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
                  Consumer<List<PostModel>?>(
                    builder: (context, posts, b) {
                      if (posts == null) {
                        log(widget.postModel.id);
                        return const CircularProgressIndicator();
                      }
                      if (posts
                              .where((element) =>
                                  element.id == widget.postModel.id)
                              .first ==
                          widget.postModel) {
                        log(widget.postModel.id);

                        var post = posts
                            .where(
                                (element) => element.id == widget.postModel.id)
                            .first;
                        return Column(
                          children: [
                            AspectRatio(
                              aspectRatio: post.mediaData[0].type == 'Photo'
                                  ? 2 / 3
                                  : post.mediaData[0].type == 'Video'
                                      ? 9 / 16
                                      : post.mediaData[0].type == 'Music'
                                          ? 13 / 9
                                          : 1 / 1,
                              child: Stack(
                                children: [
                                  ListView.builder(
                                    itemCount: post.mediaData.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      // widget.postCardController =
                                      //     PostCardController(postdata: post);
                                      var mediaData = post.mediaData[index];
                                      if (mediaData.type == 'Photo') {
                                        return InkWell(
                                            onDoubleTap: () {
                                              // print("clicked");
                                              // widget.postCardController!.isLiked
                                              //         .value =
                                              //     !post.likesIds.contains(
                                              //         FirebaseAuth.instance
                                              //             .currentUser!.uid);
                                              // widget.postCardController!
                                              //     .likeDisLikePost(
                                              //         FirebaseAuth.instance
                                              //             .currentUser!.uid,
                                              //         post.id,
                                              //         post.creatorId);
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
                                        // print("============ ${mediaData.link}");
                                        return FutureBuilder(
                                          future: iniializedFuturePlay,
                                          builder: (context, snap) {
                                            return InkWell(
                                              onLongPress: () {
                                                videoPlayerController!.pause();
                                              },
                                              onTap: () {
                                                videoPlayerController!.play();
                                              },
                                              child: AspectRatio(
                                                aspectRatio: 9 / 16,
                                                child: VideoPlayerWidget(
                                                  videoUrl: mediaData.link,
                                                  postId: widget.postModel.id,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else if (mediaData.type == 'Music') {
                                        // print("============ ${mediaData.link}");
                                        return AspectRatio(
                                          aspectRatio: 13 / 9,
                                          child: MusicPlayerUrl(
                                            musicDetails: mediaData,
                                            ontap: () {},
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.only(
                                            left: 40,
                                            right: 40,
                                            top: 110,
                                            bottom: 20,
                                          ),
                                          child: SingleChildScrollView(
                                            child: TextWidget(
                                              text: mediaData.link,
                                              textAlign: TextAlign.left,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              color: color221,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  Positioned(
                                    top: 60,
                                    left: 20,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.20),
                                      child: InkWell(
                                          child: const Icon(
                                            Icons.navigate_before,
                                            color: Colors.black,
                                          ),
                                          onTap: () => Get.back()),
                                    ),
                                  ),
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
                                    isVideoPost:
                                        post.mediaData[0].type == 'Video',
                                    videoViews: '0',
                                    isPostDetail: true,
                                    ontapLike: () {
                                      // print("clicked");

                                      // widget.postCardController!.isLiked.value =
                                      //     !post.likesIds.contains(FirebaseAuth
                                      //         .instance.currentUser!.uid);
                                      // widget.postCardController!
                                      //     .likeDisLikePost(
                                      //         FirebaseAuth
                                      //             .instance.currentUser!.uid,
                                      //         post.id,
                                      //         post.creatorId);
                                      // Get.back();
                                    },
                                    saveBtn: Consumer<UserModel?>(
                                      builder: (context, user, b) {
                                        if (user == null) {
                                          return SvgPicture.asset(
                                            icBookMarkReg,
                                          );
                                        } else {
                                          return IconButton(
                                            onPressed: () {
                                              // if (userModel.savedPostsIds
                                              //     .contains(post.id)) {
                                              //   FirebaseFirestore.instance
                                              //       .collection("users")
                                              //       .doc(userModel.id)
                                              //       .update({
                                              //     'savedPostsIds':
                                              //         FieldValue.arrayRemove(
                                              //             [post.id])
                                              //   });
                                              // } else {
                                              //   FirebaseFirestore.instance
                                              //       .collection("users")
                                              //       .doc(userModel.id)
                                              //       .update({
                                              //     'savedPostsIds':
                                              //         FieldValue.arrayUnion(
                                              //             [post.id])
                                              //   });
                                              // }
                                            },
                                            icon: SvgPicture.asset(
                                              user.savedPostsIds
                                                      .contains(post.id)
                                                  ? icSavedPost
                                                  : icBookMarkReg,
                                            ),
                                          );
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
                                      // print("dsald");
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
                                                appUserId: post.creatorId,
                                                appUserName:
                                                    post.creatorDetails.name,
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
                                                    text: convertDateIntoTime(
                                                        post.createdAt),
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
                  Consumer<DataProvider>(
                    builder: (context, provider, b) {
                      if (provider.comment(widget.postModel.id) == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        // var comment = provider.comment(widget.postModel.id);
                        return FutureBuilder<List<Comment>?>(
                            future: _comment,
                            builder: (context, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snap.hasData) {
                                return ListView.builder(
                                  itemCount: snap.data!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 24),
                                  itemBuilder: (context, index) {
                                    var data = snap.data![index];
                                    // var cDetail =
                                    //     CreatorDetails.fromMap(data['creatorDetails']);
                                    var cmnt = data;
                                    if (cmnt.creatorDetails.name.isNotEmpty) {
                                      return ListTile(
                                        isThreeLine: true,
                                        leading: InkWell(
                                          onTap: () {
                                            Get.to(
                                              () => AppUserScreen(
                                                appUserId: cmnt.creatorId,
                                                appUserName:
                                                    cmnt.creatorDetails.name,
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
                                                image:
                                                    CachedNetworkImageProvider(
                                                        cmnt.creatorDetails
                                                            .imageUrl),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        title: InkWell(
                                          onTap: () {
                                            Get.to(
                                              () => AppUserScreen(
                                                appUserId: cmnt.creatorId,
                                                appUserName:
                                                    cmnt.creatorDetails.name,
                                              ),
                                            );
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              text: cmnt.creatorDetails.name,
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color:
                                                      const Color(0xff212121),
                                                  fontWeight: FontWeight.w600),
                                              children: [
                                                WidgetSpan(
                                                    child: widthBox(4.w)),
                                                if (cmnt
                                                    .creatorDetails.isVerified)
                                                  WidgetSpan(
                                                      child: SvgPicture.asset(
                                                          icVerifyBadge)),
                                                WidgetSpan(
                                                    child: widthBox(8.w)),
                                                TextSpan(
                                                  text: convertDateIntoTime(
                                                      cmnt.createdAt),
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        const Color(0xff5c5c5c),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        subtitle: TextWidget(
                                          text: cmnt.message.isEmpty
                                              ? "---"
                                              : cmnt.message,
                                          fontSize: 12.sp,
                                          color: const Color(0xff5f5f5f),
                                          fontWeight: FontWeight.w400,
                                          textOverflow: TextOverflow.visible,
                                        ),
                                        trailing: Visibility(
                                          visible: cmnt.creatorId ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                          child: InkWell(
                                            onTap: () {
                                              if (cmnt.creatorId ==
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid) {
                                                Get.bottomSheet(
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Colors.red),
                                                    height: 80,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        // await FirebaseFirestore.instance
                                                        //     .collection("posts")
                                                        //     .doc(cmnt.id)
                                                        //     .collection("comments")
                                                        //     .doc(snapshot
                                                        //         .data!.docs[index].id)
                                                        //     .delete();

                                                        // await FirebaseFirestore.instance
                                                        //     .collection("posts")
                                                        //     .doc(cmnt.id)
                                                        //     .update({
                                                        //   "commentIds":
                                                        //       FieldValue.arrayRemove([
                                                        //     snapshot
                                                        //         .data!.docs[index].id
                                                        //   ])
                                                        // });

                                                        Get.back();
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextWidget(
                                                            text:
                                                                "Delete Comment",
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                    } else {
                                      return Container();
                                    }
                                  },
                                );
                              } else {
                                return Container();
                              }
                            });
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
                                // var cmnt = Comment(
                                //   id: widget.postModel.id,
                                //   creatorId:
                                //       FirebaseAuth.instance.currentUser!.uid,
                                //   creatorDetails: CreatorDetails(
                                //       name: user!.name,
                                //       imageUrl: user!.imageStr,
                                //       isVerified: user!.isVerified),
                                //   createdAt: DateTime.now().toIso8601String(),
                                //   message: coommenController.text,
                                // );

                                // FirebaseFirestore.instance
                                //     .collection("posts")
                                //     .doc(widget.postModel.id)
                                //     .collection("comments")
                                //     .doc()
                                //     .set(cmnt.toMap(), SetOptions(merge: true))
                                //     .then((value) async {
                                //   coommenController.clear();
                                //   var cmntId = await FirebaseFirestore.instance
                                //       .collection("posts")
                                //       .doc(widget.postModel.id)
                                //       .collection("comments")
                                //       .get();

                                //   List listOfCommentsId = [];
                                //   for (var i in cmntId.docs) {
                                //     listOfCommentsId.add(i.id);
                                //   }

                                //   print(
                                //       "+++========+++++++++============+++++++++ $listOfCommentsId ");
                                //   FirebaseFirestore.instance
                                //       .collection("posts")
                                //       .doc(widget.postModel.id)
                                //       .set({"commentIds": listOfCommentsId},
                                //           SetOptions(merge: true));

                                //   var recieverRef = await FirebaseFirestore
                                //       .instance
                                //       .collection("users")
                                //       .doc(widget.postModel.creatorId)
                                //       .get();

                                //   var recieverFCMToken =
                                //       recieverRef.data()!['fcmToken'];
                                //   print(
                                //       "=========> reciever fcm token = $recieverFCMToken");
                                //   FirebaseMessagingService()
                                //       .sendNotificationToUser(
                                //     appUserId: recieverRef.id,
                                //     imageUrl:
                                //         widget.postModel.mediaData[0].type ==
                                //                 'Photo'
                                //             ? widget.postModel.mediaData[0].link
                                //             : '',
                                //     devRegToken: recieverFCMToken,
                                //     msg: "has commented on your post.",
                                //   );
                                // });
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
