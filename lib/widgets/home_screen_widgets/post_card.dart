import 'dart:math';

import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_screen.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/custom_dialog.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_detail_media.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_footer.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_header.dart';
import 'package:casarancha/widgets/home_screen_widgets/report_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../screens/dashboard/provider/dashboard_provider.dart';
import '../../screens/dashboard/provider/download_provider.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

class PostCard extends StatelessWidget {
  const PostCard(
      {super.key,
      required this.post,
      this.initializedFuturePlay,
      required this.postCreator,
      this.groupId});

  final PostModel post;
  final Future<void>? initializedFuturePlay;
  final UserModel postCreator;

  final String? groupId;

  @override
  Widget build(BuildContext context) {
    final curruentUser = context.watch<UserModel?>();
    final postPorvider = Provider.of<PostProvider>(context, listen: false);
    final ghostProvider = context.watch<DashboardProvider>();
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        CustomPostHeader(
          postCreator: postCreator,
          postModel: post,
          onVertItemClick: () {
            if (post.creatorId == curruentUser!.id) {
              Get.bottomSheet(
                Container(
                  decoration: const BoxDecoration(color: Colors.red),
                  height: 80,
                  child: InkWell(
                    onTap: () => postPorvider.deletePost(
                        postModel: post, groupId: groupId),
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
                  blockText: curruentUser.blockIds.contains(post.creatorId)
                      ? 'Unblock User'
                      : 'Block User',
                  ontapBlock: () {
                    Get.back();
                    postPorvider.blockUnblockUser(
                        currentUser: curruentUser, appUser: post.creatorId);
                  },
                  onTapDownload: () async {
                    Get.back();
                    showDialog(
                        context: context,
                        builder: (c) => CustomDownloadDialog(
                              path:
                                  '${post.mediaData.first.type}${Random().nextInt(2)}${checkMediaTypeAndSetExtention(post.mediaData.first.type)}',
                              url: post.mediaData.first.link,
                            ));
                  },
                ),
                isScrollControlled: true,
              );
            }
          },
          ontap: () {},
          headerOnTap: () {
            navigateToAppUserScreen(post.creatorId, context);
          },
        ),
        PostMediaWidget(
          post: post,
          isPostDetail: false,
          groupId: groupId,
        ),
        heightBox(10.h),
        CustomPostFooter(
          groupId: groupId,
          isLike: post.likesIds.contains(curruentUser!.id),
          ontapLike: () {
            ghostProvider.checkGhostMode
                ? GlobalSnackBar.show(message: "Ghost Mode is enabled")
                : postPorvider.toggleLikeDislike(
                    postModel: post,
                    groupId: groupId,
                  );
          },
          ontapSave: () {
            ghostProvider.checkGhostMode
                ? GlobalSnackBar.show(message: "Ghost Mode is enabled")
                : postPorvider.onTapSave(
                    userModel: curruentUser, postId: post.id);
          },
          postModel: post,
          savepostIds: curruentUser.savedPostsIds,
        ),
      ],
    );
  }
}
