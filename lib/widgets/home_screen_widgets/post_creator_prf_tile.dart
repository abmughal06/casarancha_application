import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_footer.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../../screens/chat/share_post_screen.dart';
import '../../screens/profile/AppUser/app_user_screen.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

class PostCreatorProfileTile extends StatelessWidget {
  const PostCreatorProfileTile({Key? key, required this.post})
      : super(key: key);
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            isLike:
                post.likesIds.contains(FirebaseAuth.instance.currentUser!.uid),
            isVideoPost: post.mediaData[0].type == 'Video',
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
                      user.savedPostsIds.contains(post.id)
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
              // print("dsald");
            },
            comments: post.commentIds.length,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    // Get.to(
                    //   () => AppUserScreen(
                    //     appUserId: post.creatorId,
                    //     appUserName: post.creatorDetails.name,
                    //   ),
                    // );
                    navigateToAppUserScreen(post.creatorId, context);
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
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    post.creatorDetails.imageUrl,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: post.creatorDetails.isVerified,
                              child: Positioned(
                                bottom: 0,
                                right: 0,
                                child: SvgPicture.asset(icVerifyBadge),
                              ),
                            ),
                          ],
                        ),
                      ),
                      widthBox(7.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: post.creatorDetails.name,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          TextWidget(
                            text: convertDateIntoTime(post.createdAt),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightBox(11.h),
                      Padding(
                        padding: EdgeInsets.only(left: 2.h),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextWidget(
                            text: post.description,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff5f5f5f),
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
    );
  }
}
