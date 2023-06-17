import 'dart:developer';

import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';

import 'package:casarancha/widgets/listView_with_whereIn_querry.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:timeago/timeago.dart';
import 'package:video_player/video_player.dart';

import '../../models/post_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../widgets/PostCard/PostCardController.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/video_player_Url.dart';
import '../chat/GhostMode/ghost_chat_screen.dart';
import '../chat/share_post_screen.dart';
import '../home/HomeScreen/home_screen.dart';
import '../home/post_detail_screen.dart';

class SavedPostScreen extends StatelessWidget {
  SavedPostScreen({Key? key}) : super(key: key);
  final profileScreenController = Get.find<ProfileScreenController>();

  Future<void>? initializedFuturePlay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: primaryAppbar(title: 'Saved Posts'),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snaps) {
            if (snaps.hasData) {
              var userModel = UserModel.fromMap(snaps.data!.data()!);
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .where("id", whereIn: userModel.savedPostsIds)
                      .snapshots(),
                  builder: (context, snap) {
                    var data = snap.data!.docs;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final prePost = data[index].data();
                        final post = PostModel.fromMap(prePost);
                        PostCardController postCardController =
                            PostCardController(postdata: post);
                        return Padding(
                          padding: EdgeInsets.only(bottom: 15.w),
                          child: Column(
                            children: [
                              Visibility(
                                visible: post.mediaData[0].type != "Video",
                                child: CustomPostHeader(
                                    isVerified: post.creatorDetails.isVerified,
                                    time:
                                        format(DateTime.parse(post.createdAt)),
                                    onVertItemClick: () {
                                      Get.back();

                                      Get.bottomSheet(
                                        BottomSheetWidget(
                                          ontapBlock: () {},
                                        ),
                                        isScrollControlled: true,
                                      );
                                    },
                                    name: post.creatorDetails.name,
                                    image: post.creatorDetails.imageUrl,
                                    ontap: () {},
                                    headerOnTap: () {
                                      postCardController
                                          .gotoAppUserScreen(post.creatorId);
                                    }),
                              ),
                              Visibility(
                                visible: post.mediaData[0].type == "Photo",
                                child: Column(
                                  children: [
                                    heightBox(10.h),
                                    AspectRatio(
                                      aspectRatio: 2 / 3,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: post.mediaData.length,
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                                onTap: () => Get.to(() =>
                                                    PostDetailScreen(
                                                        postModel: post,
                                                        postCardController:
                                                            postCardController)),
                                                onDoubleTap: () async {
                                                  log("clicked");
                                                  postCardController
                                                          .isLiked.value =
                                                      !post.likesIds
                                                          .contains(user!.id);
                                                  postCardController
                                                      .likeDisLikePost(
                                                          user!.id,
                                                          post.id,
                                                          post.creatorId);
                                                },
                                                child: Image.network(post
                                                    .mediaData[index].link)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: post.mediaData[0].type == "Video",
                                child: FutureBuilder(
                                    future: initializedFuturePlay,
                                    builder: (context, snapshot) {
                                      // if (snapshot.connectionState ==
                                      //     ConnectionState.done) {
                                      return Visibility(
                                        child: AspectRatio(
                                          aspectRatio: 9 / 16,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: post.mediaData.length,
                                            itemBuilder: (context, i) {
                                              VideoPlayerController?
                                                  videoPlayerController;
                                              videoPlayerController =
                                                  VideoPlayerController.network(
                                                post.mediaData.first.type ==
                                                        "Video"
                                                    ? post.mediaData[i].link
                                                        .toString()
                                                    : "",
                                              );

                                              return InkWell(
                                                onTap: () => Get.to(() =>
                                                    PostDetailScreen(
                                                        postModel: post,
                                                        postCardController:
                                                            postCardController)),
                                                onDoubleTap: () {
                                                  log("clicked");
                                                  postCardController
                                                          .isLiked.value =
                                                      !post.likesIds
                                                          .contains(user!.id);
                                                  postCardController
                                                      .likeDisLikePost(
                                                          user!.id,
                                                          post.id,
                                                          post.creatorId);
                                                },
                                                child: AspectRatio(
                                                  aspectRatio: 9 / 16,
                                                  child: Stack(
                                                    children: [
                                                      VideoPlayerWidget(
                                                        postId: post.id,
                                                        videoPlayerController:
                                                            videoPlayerController,
                                                        videoUrl: post
                                                            .mediaData[i].link,
                                                      ),
                                                      Positioned(
                                                        top: 12,
                                                        left: 0,
                                                        right: 0,
                                                        child: CustomPostHeader(
                                                          isVerified: post
                                                              .creatorDetails
                                                              .isVerified,
                                                          time: format(DateTime
                                                              .parse(post
                                                                  .createdAt)),
                                                          name: post
                                                              .creatorDetails
                                                              .name,
                                                          image: post
                                                              .creatorDetails
                                                              .imageUrl,
                                                          headerOnTap: () {
                                                            postCardController
                                                                .gotoAppUserScreen(
                                                                    post.creatorId);
                                                          },
                                                          isVideoPost: true,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                      // }
                                      // else {
                                      //   return const CircularProgressIndicator();
                                      // }
                                    }),
                              ),
                              Visibility(
                                visible: post.mediaData[0].type == "Qoute",
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 229,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: post.mediaData.length,
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                          onTap: () => Get.to(() =>
                                              PostDetailScreen(
                                                  postModel: post,
                                                  postCardController:
                                                      postCardController)),
                                          onDoubleTap: () {
                                            log("clicked");
                                            postCardController.isLiked.value =
                                                !post.likesIds
                                                    .contains(user!.id);
                                            postCardController.likeDisLikePost(
                                                user!.id,
                                                post.id,
                                                post.creatorId);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 40,
                                              vertical: 50,
                                            ),
                                            child: Center(
                                              child: Text(
                                                post.mediaData[index].link,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: color221,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              heightBox(10.h),
                              CustomPostFooter(
                                likes: post.likesIds.length.toString(),
                                isLike: post.likesIds.contains(user!.id),

                                ontapLike: () {
                                  log("clicked");
                                  postCardController.isLiked.value =
                                      !post.likesIds.contains(user!.id);
                                  postCardController.likeDisLikePost(
                                      user!.id, post.id, post.creatorId);
                                },
                                // ontapSave: () {
                                //   log(user!.savedPostsIds);

                                // },
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
                                          } else if (!snapshot.hasData) {
                                            const Center(
                                                child:
                                                    CircularProgressIndicator());
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
                                              ? colorPrimaryA05
                                              : null,
                                        ),
                                      );
                                    } else {
                                      return Image.asset(postSave);
                                    }
                                  },
                                ),
                                postId: post.id,
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
                                  //       id: post.id,
                                  //       creatorId: post.creatorId,
                                  //       comment: post.commentIds,
                                  //       creatorDetails: CreatorDetails(
                                  //           name: post.creatorDetails.name,
                                  //           imageUrl:
                                  //               post.creatorDetails.imageUrl,
                                  //           isVerified: post
                                  //               .creatorDetails.isVerified),
                                  //     ));
                                  Get.to(() => PostDetailScreen(
                                      postModel: post,
                                      postCardController: postCardController));
                                },
                                comments: post.commentIds.length,
                                isDesc: post.description.isNotEmpty,
                                desc: post.description.toString(),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

// return Padding(
//                               padding: EdgeInsets.only(bottom: 15.w),
//                               child: Column(
//                                 children: [
//                                   Visibility(
//                                     visible: post.mediaData[0].type == "Photo",
//                                     child: Column(
//                                       children: [
//                                         CustomPostHeader(
//                                             name: post.creatorDetails.name,
//                                             isVerified:
//                                                 post.creatorDetails.isVerified,
//                                             image: post.creatorDetails.imageUrl,
//                                             headerOnTap: () {
//                                               postCardController
//                                                   .gotoAppUserScreen(
//                                                       post.creatorId);
//                                             }),
//                                         heightBox(10.h),
//                                         AspectRatio(
//                                           aspectRatio: 2 / 3,
//                                           child: ListView.builder(
//                                             scrollDirection: Axis.horizontal,
//                                             shrinkWrap: true,
//                                             itemCount: post.mediaData.length,
//                                             itemBuilder: (context, index) =>
//                                                 InkWell(
//                                                     onTap: () => Get.to(() =>
//                                                         PostDetailScreen(
//                                                             postModel: post,
//                                                             postCardController:
//                                                                 postCardController)),
//                                                     onDoubleTap: () async {
//                                                       log("ghost mode clicked");

//                                                       ScaffoldMessenger.of(
//                                                               context)
//                                                           .showSnackBar(const SnackBar(
//                                                               backgroundColor:
//                                                                   colorPrimaryA05,
//                                                               content: Text(
//                                                                   'Ghost Mode Enabled!')));
//                                                     },
//                                                     child: Image.network(post
//                                                         .mediaData[index]
//                                                         .link)),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Visibility(
//                                     visible: post.mediaData[0].type == "Video",
//                                     child: FutureBuilder(
//                                         future: initializedFuturePlay,
//                                         builder: (context, snapshot) {
//                                           return Visibility(
//                                             child: AspectRatio(
//                                               aspectRatio: 9 / 16,
//                                               child: ListView.builder(
//                                                 scrollDirection:
//                                                     Axis.horizontal,
//                                                 shrinkWrap: true,
//                                                 itemCount:
//                                                     post.mediaData.length,
//                                                 itemBuilder: (context, i) {
//                                                   VideoPlayerController?
//                                                       videoPlayerController;

//                                                   videoPlayerController =
//                                                       VideoPlayerController
//                                                           .network(
//                                                     post.mediaData.first.type ==
//                                                             "Video"
//                                                         ? post.mediaData[i].link
//                                                             .toString()
//                                                         : "",
//                                                   );

//                                                   return InkWell(
//                                                     onTap: () => Get.to(() =>
//                                                         PostDetailScreen(
//                                                             postModel: post,
//                                                             postCardController:
//                                                                 postCardController)),
//                                                     onDoubleTap: () {
//                                                       log("ghost mode clicked");

//                                                       ScaffoldMessenger.of(
//                                                               context)
//                                                           .showSnackBar(const SnackBar(
//                                                               backgroundColor:
//                                                                   colorPrimaryA05,
//                                                               content: Text(
//                                                                   'Ghost Mode Enabled!')));
//                                                     },
//                                                     child: AspectRatio(
//                                                       aspectRatio: 9 / 16,
//                                                       child: Stack(
//                                                         children: [
//                                                           VideoPlayerWidget(
//                                                             videoPlayerController:
//                                                                 videoPlayerController,
//                                                             videoUrl: post
//                                                                 .mediaData[i]
//                                                                 .link,
//                                                           ),
//                                                           Positioned(
//                                                             top: 12,
//                                                             left: 0,
//                                                             right: 0,
//                                                             child:
//                                                                 CustomPostHeader(
//                                                               isVerified: post
//                                                                   .creatorDetails
//                                                                   .isVerified,
//                                                               name: post
//                                                                   .creatorDetails
//                                                                   .name,
//                                                               image: post
//                                                                   .creatorDetails
//                                                                   .imageUrl,
//                                                               headerOnTap: () {
//                                                                 postCardController
//                                                                     .gotoAppUserScreen(
//                                                                         post.creatorId);
//                                                               },
//                                                               isVideoPost: true,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                               ),
//                                             ),
//                                           );
//                                         }),
//                                   ),
//                                   Visibility(
//                                     visible: post.mediaData[0].type == "Qoute",
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         CustomPostHeader(
//                                             isVerified:
//                                                 post.creatorDetails.isVerified,
//                                             name: post.creatorDetails.name,
//                                             image: post.creatorDetails.imageUrl,
//                                             ontap: () {},
//                                             time: timeago.format(
//                                                 DateTime.parse(post.createdAt)),
//                                             headerOnTap: () {
//                                               postCardController
//                                                   .gotoAppUserScreen(
//                                                       post.creatorId);
//                                             }),
//                                         SizedBox(
//                                           height: 229,
//                                           child: ListView.builder(
//                                             // shrinkWrap: true,
//                                             scrollDirection: Axis.horizontal,
//                                             itemCount: post.mediaData.length,
//                                             itemBuilder: (context, index) =>
//                                                 InkWell(
//                                               onTap: () => Get.to(() =>
//                                                   PostDetailScreen(
//                                                       postModel: post,
//                                                       postCardController:
//                                                           postCardController)),
//                                               onDoubleTap: () {
//                                                 log("ghost mode clicked");

//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(const SnackBar(
//                                                         backgroundColor:
//                                                             colorPrimaryA05,
//                                                         content: Text(
//                                                             'Ghost Mode Enabled!')));
//                                               },
//                                               child: Container(
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                   horizontal: 40,
//                                                   vertical: 50,
//                                                 ),
//                                                 child: Center(
//                                                   child: Text(
//                                                     post.mediaData[index].link,
//                                                     textAlign: TextAlign.center,
//                                                     style: TextStyle(
//                                                       fontSize: 16.sp,
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       color: color221,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   heightBox(10.h),
//                                   CustomPostFooter(
//                                     likes: post.likesIds.length.toString(),
//                                     isLike: post.likesIds.contains(user!.id),

//                                     ontapLike: () {
//                                       log("ghost mode clicked");

//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(const SnackBar(
//                                               backgroundColor: colorPrimaryA05,
//                                               content:
//                                                   Text('Ghost Mode Enabled!')));
//                                     },
//                                     // ontapSave: () {
//                                     //   log(user!.savedPostsIds);

//                                     // },
//                                     saveBtn: StreamBuilder<
//                                         DocumentSnapshot<Map<String, dynamic>>>(
//                                       stream: FirebaseFirestore.instance
//                                           .collection("users")
//                                           .doc(FirebaseAuth
//                                               .instance.currentUser!.uid)
//                                           .snapshots(),
//                                       builder: (context, snapshot) {
//                                         if (snapshot.hasData) {
//                                           var userData = snapshot.data!.data();
//                                           var userModel =
//                                               UserModel.fromMap(userData!);
//                                           return GestureDetector(
//                                             onTap: () {
//                                               log("ghost mode clicked");

//                                               ScaffoldMessenger.of(context)
//                                                   .showSnackBar(const SnackBar(
//                                                 backgroundColor:
//                                                     colorPrimaryA05,
//                                                 content:
//                                                     Text('Ghost Mode Enabled!'),
//                                               ));
//                                             },
//                                             child: Image.asset(
//                                               postSave,
//                                               color: userModel.savedPostsIds
//                                                       .contains(post.id)
//                                                   ? colorPrimaryA05
//                                                   : null,
//                                             ),
//                                           );
//                                         } else if (!snapshot.hasData) {
//                                           return const Center(
//                                               child:
//                                                   CircularProgressIndicator());
//                                         } else {
//                                           return Image.asset(postSave);
//                                         }
//                                       },
//                                     ),
//                                     ontapShare: () {
//                                       log("ghost mode clicked");

//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(const SnackBar(
//                                               backgroundColor: colorPrimaryA05,
//                                               content:
//                                                   Text('Ghost Mode Enabled!')));
//                                     },
//                                     ontapCmnt: () {
//                                       log("ghost mode clicked");

//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(const SnackBar(
//                                               backgroundColor: colorPrimaryA05,
//                                               content:
//                                                   Text('Ghost Mode Enabled!')));
//                                     },
//                                     comments: post.commentIds.length,
//                                     isDesc: post.description.isNotEmpty,
//                                     postId: post.id,
//                                     isPostDetail: false,
//                                     desc: post.description.toString(),
//                                   ),
//                                 ],
//                               ),
//                             );