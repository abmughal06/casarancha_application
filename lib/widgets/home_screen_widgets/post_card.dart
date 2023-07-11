import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_footer.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_header.dart';
import 'package:casarancha/widgets/home_screen_widgets/report_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../common_widgets.dart';
import '../music_player_url.dart';
import '../text_widget.dart';
import '../video_player_url.dart';

class PostCard extends StatelessWidget {
  const PostCard({Key? key, required this.post, this.initializedFuturePlay})
      : super(key: key);

  final PostModel post;
  final Future<void>? initializedFuturePlay;

  @override
  Widget build(BuildContext context) {
    final curruentUser = context.watch<UserModel?>();
    return Padding(
      padding: EdgeInsets.only(bottom: 15.w),
      child: Column(
        children: [
          CustomPostHeader(
            showPostTime: post.showPostTime,
            isVerified: post.creatorDetails.isVerified,
            time: convertDateIntoTime(post.createdAt),
            onVertItemClick: () {
              Get.back();

              if (post.creatorId == curruentUser!.id) {
                Get.bottomSheet(
                  Container(
                    decoration: const BoxDecoration(color: Colors.red),
                    height: 80,
                    child: InkWell(
                      onTap: () async {
                        // await FirebaseFirestore.instance
                        //     .collection("posts")
                        //     .doc(post.id)
                        //     .delete();
                        // Get.back();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: "Delete Post",
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
              } else {
                Get.bottomSheet(
                  BottomSheetWidget(
                    ontapBlock: () {},
                  ),
                  isScrollControlled: true,
                );
              }
            },
            name: post.creatorDetails.name,
            image: post.creatorDetails.imageUrl,
            ontap: () {},
            headerOnTap: () {
              // postCardController.gotoAppUserScreen(post.creatorId);
            },
          ),
          showPostAccordingToItsType(post: post)!,
          heightBox(10.h),
          CustomPostFooter(
            likes: post.likesIds.length.toString(),
            isLike: post.likesIds.contains(curruentUser!.id),

            ontapLike: () {
              log("clicked");
              // postCardController.isLiked.value =
              //     !post.likesIds.contains(user!.id);
              // postCardController.likeDisLikePost(
              // user!.id, post.id, post.creatorId);
            },
            // ontapSave: () {
            //   log(user!.savedPostsIds);

            // },
            saveBtn: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                curruentUser.savedPostsIds.contains(post.id)
                    ? icSavedPost
                    : icBookMarkReg,
              ),
            ),

            isVideoPost: post.mediaData[0].type == 'Video',
            videoViews: '0',
            postId: post.id,
            ontapShare: () {
              // Get.to(() => SharePostScreen(
              //       postModel: PostModel(
              //         id: post.id,
              //         creatorId: post.creatorId,
              //         creatorDetails: post.creatorDetails,
              //         createdAt: post.createdAt,
              //         description: post.description,
              //         locationName: post.locationName,
              //         shareLink: post.shareLink,
              //         mediaData: post.mediaData,
              //         tagsIds: post.tagsIds,
              //         likesIds: post.likesIds,
              //         showPostTime: post.showPostTime,
              //         postBlockStatus: post.postBlockStatus,
              //         commentIds: post.commentIds,
              //       ),
              //     ));
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
              // Get.to(() => PostDetailScreen(
              //     postModel: post, postCardController: postCardController));
            },
            comments: post.commentIds.length,
            isDesc: post.description.isNotEmpty,
            desc: post.description.toString(),
          ),
        ],
      ),
    );
  }
}

Widget? showPostAccordingToItsType({PostModel? post}) {
  Future<void>? initializedFuturePlay;
  for (var element in post!.mediaData) {
    switch (element.type) {
      case "Photo":
        return AspectRatio(
          aspectRatio: 2 / 3,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: post.mediaData.length,
            itemBuilder: (context, index) => InkWell(
                // onTap: () => Get.to(() => PostDetailScreen(
                //     postModel: post,
                //     postCardController: postCardController)),
                onDoubleTap: () async {
                  log("clicked");
                  // postCardController.isLiked.value =
                  //     !post.likesIds.contains(user!.id);
                  // postCardController.likeDisLikePost(
                  //     user!.id, post.id, post.creatorId);
                },
                child: CachedNetworkImage(
                  imageUrl: post.mediaData[index].link,
                )),
          ),
        );

      case 'Qoute':
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: post.mediaData.length,
            itemBuilder: (context, index) => InkWell(
              // onTap: () => Get.to(() => PostDetailScreen(
              //     postModel: post,
              //     postCardController: postCardController)),
              onDoubleTap: () {
                log("clicked");
                // postCardController.isLiked.value =
                //     !post.likesIds.contains(user!.id);
                // postCardController.likeDisLikePost(
                //     user!.id, post.id, post.creatorId);
              },
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  // height: 16 / 9,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(
                    20,
                  ),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: SingleChildScrollView(
                    child: TextWidget(
                      text: post.mediaData[index].link,
                      textAlign: TextAlign.left,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: color221,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      case "Video":
        return FutureBuilder(
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
                    // VideoPlayerController?
                    //     videoPlayerController;
                    // videoPlayerController =
                    //     VideoPlayerController
                    //         .network(
                    //   post.mediaData.first.type ==
                    //           "Video"
                    //       ? post.mediaData[i].link
                    //           .toString()
                    //       : "",
                    // );

                    return InkWell(
                      // onTap: () => Get.to(() => PostDetailScreen(
                      //     postModel: post,
                      //     postCardController: postCardController)),
                      onDoubleTap: () {
                        log("clicked");
                        // postCardController.isLiked.value =
                        //     !post.likesIds.contains(user!.id);
                        // postCardController.likeDisLikePost(
                        //     user!.id, post.id, post.creatorId);
                      },
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: VideoPlayerWidget(
                          postId: post.id,
                          // videoPlayerController:
                          //     videoPlayerController,
                          videoUrl: post.mediaData[i].link,
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
          },
        );

      case "Music":
        return Column(
          children: [
            AspectRatio(
              aspectRatio: 13 / 9,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: post.mediaData.length,
                itemBuilder: (context, index) => InkWell(
                    // onTap: () => Get.to(() => PostDetailScreen(
                    //     postModel: post,
                    //     postCardController: postCardController)),
                    onDoubleTap: () async {
                      log("ghost mode clicked");

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: colorPrimaryA05,
                          content: Text('Ghost Mode Enabled!')));
                    },
                    child: MusicPlayerUrl(
                        musicDetails: post.mediaData[index], ontap: () {})),
              ),
            ),
          ],
        );

      default:
        return Container();
    }
  }
  return null;
}
