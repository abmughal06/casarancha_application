import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/screens/home/HomeScreen/home_screen.dart';
import 'package:casarancha/widgets/PostCard/PostCardController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import '../chat/GhostMode/ghost_chat_screen.dart';
import '../chat/share_post_screen.dart';

import 'package:timeago/timeago.dart' as timeago;

class PostDetailScreen extends StatelessWidget {
  PostDetailScreen(
      {Key? key, required this.postModel, required this.postCardController})
      : super(key: key);
  final PostModel postModel;
  PostCardController? postCardController;
  VideoPlayerController? videoPlayerController;
  final coommenController = TextEditingController();

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
                          .doc(postModel.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var p = snapshot.data!.data();
                          var post = PostModel.fromMap(p!);
                          return Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 2 / 3,
                                child: ListView.builder(
                                  itemCount: post.mediaData.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    postCardController =
                                        PostCardController(postdata: post);
                                    var mediaData = post.mediaData[index];
                                    if (mediaData.type == 'Photo') {
                                      return InkWell(
                                          onDoubleTap: () {
                                            print("clicked");
                                            postCardController!.isLiked.value =
                                                !post.likesIds.contains(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid);
                                            postCardController!.likeDisLikePost(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                post.id,
                                                post.creatorId);
                                          },
                                          child: CachedNetworkImage(
                                              imageUrl: mediaData.link));
                                    } else if (mediaData.type == 'Video') {
                                      print("============ ${mediaData.link}");
                                      videoPlayerController =
                                          VideoPlayerController.network(
                                              mediaData.link);
                                      // videoPlayerController!.initialize();
                                      // print(mediaData.link);
                                      // videoPlayerController!.play();
                                      // var chweieController = ChewieController(
                                      //   videoPlayerController:
                                      //       videoPlayerController!,
                                      //   aspectRatio: 2 / 3,
                                      //   looping: true,
                                      //   autoPlay: true,
                                      //   zoomAndPan: true,
                                      // );

                                      // return InkWell(
                                      //   onLongPress: () {
                                      //     videoPlayerController!.pause();
                                      //   },
                                      //   onTap: () {
                                      //     videoPlayerController!.play();
                                      //   },
                                      //   child: AspectRatio(
                                      //       aspectRatio: 2 / 3,
                                      //       child: Chewie(
                                      //         controller: chweieController,
                                      //       )),
                                      // );
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
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              CustomPostFooter(
                                likes: post.likesIds.length.toString(),
                                isLike: post.likesIds.contains(
                                    FirebaseAuth.instance.currentUser!.uid),
                                ontapLike: () {
                                  print("clicked");
                                  // FirebaseFirestore.instance
                                  //     .collection("posts")
                                  //     .doc(post.id)
                                  //     .update(
                                  //   {
                                  //     "likesIds": [
                                  //       FirebaseAuth.instance.currentUser!.uid
                                  //     ]
                                  //   },
                                  // );

                                  postCardController!.isLiked.value =
                                      !post.likesIds.contains(FirebaseAuth
                                          .instance.currentUser!.uid);
                                  postCardController!.likeDisLikePost(
                                      FirebaseAuth.instance.currentUser!.uid,
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
                                      return GestureDetector(
                                        onTap: () {
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
                                        child: Image.asset(
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
                                          creatorDetails: post.creatorDetails,
                                          createdAt: post.createdAt,
                                          description: post.description,
                                          locationName: post.locationName,
                                          shareLink: post.shareLink,
                                          mediaData: post.mediaData,
                                          tagsIds: post.tagsIds,
                                          likesIds: post.likesIds,
                                          showPostTime: post.showPostTime,
                                          postBlockStatus: post.postBlockStatus,
                                          commentIds: post.commentIds,
                                        ),
                                      ));
                                },
                                ontapCmnt: () {
                                  // Get.to(() => CommentScreen(
                                  //       id: postModel.id,
                                  //       comment: postModel.commentIds,
                                  //       creatorDetails: CreatorDetails(
                                  //           name: postModel.creatorDetails.name,
                                  //           imageUrl: postModel.creatorDetails.imageUrl,
                                  //           isVerified: postModel.creatorDetails.isVerified),
                                  //     ));
                                  print("dsald");
                                },
                                comments: post.commentIds.length,
                                isDesc: post.description.isNotEmpty,
                                desc: post.description.toString(),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(post.creatorDetails.name),
                                  subtitle: Text(
                                    timeago.format(
                                      DateTime.parse(post.createdAt),
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        post.creatorDetails.imageUrl.isEmpty
                                            ? null
                                            : CachedNetworkImageProvider(
                                                post.creatorDetails.imageUrl,
                                              ),
                                    child: post.creatorDetails.imageUrl.isEmpty
                                        ? const Icon(
                                            Icons.question_mark,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                  const Divider(),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .doc(postModel.id)
                        .collection("comments")
                        .orderBy("createdAt", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index].data();
                            // var cDetail =
                            //     CreatorDetails.fromMap(data['creatorDetails']);
                            var cmnt = Comment.fromMap(data);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: ListTile(
                                horizontalTitleGap: 0,
                                leading: Container(
                                  height: 30.h,
                                  width: 30.h,
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
                                title: Text(cmnt.creatorDetails.name,
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700)),
                                subtitle: Text(cmnt.message,
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    timeago.format(
                                      DateTime.parse(
                                        cmnt.createdAt,
                                      ),
                                    ),
                                    style: TextStyle(
                                        fontSize: 11.sp, color: Colors.black45),
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
                                  id: postModel.id,
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
                                    .doc(postModel.id)
                                    .collection("comments")
                                    .doc()
                                    .set(cmnt.toMap(), SetOptions(merge: true))
                                    .then((value) async {
                                  coommenController.clear();
                                  var cmntId = await FirebaseFirestore.instance
                                      .collection("posts")
                                      .doc(postModel.id)
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
                                      .doc(postModel.id)
                                      .set({"commentIds": listOfCommentsId},
                                          SetOptions(merge: true));

                                  var recieverRef = await FirebaseFirestore
                                      .instance
                                      .collection("users")
                                      .doc(postModel.creatorId)
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
                                    userReqID: postModel.creatorId,
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
