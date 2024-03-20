import 'dart:math';

import 'package:casarancha/screens/groups/provider/new_group_prov.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_screen.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/custom_dialog.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_detail_media.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_footer.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_header.dart';
import 'package:casarancha/widgets/home_screen_widgets/report_sheet.dart';
import 'package:casarancha/widgets/shared/alert_dialog.dart';
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
      required this.postCreatorId,
      this.groupId,
      this.isGhostPost = false,
      this.isGroupAdmin = false});

  final PostModel post;
  final Future<void>? initializedFuturePlay;
  final String postCreatorId;

  final String? groupId;
  final bool isGhostPost;
  final bool isGroupAdmin;

  @override
  Widget build(BuildContext context) {
    final curruentUser = context.watch<UserModel?>();
    final postPorvider = Provider.of<PostProvider>(context, listen: false);
    final ghostProvider = context.watch<DashboardProvider>();
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        CustomPostHeader(
          postCreatorId: postCreatorId,
          postModel: post,
          isGroupAdmin: isGroupAdmin,
          isGhostPost: isGhostPost,
          onVertItemClick: () {
            if (curruentUser != null) {
              if (post.creatorId == curruentUser.id) {
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
                            text: appText(context).strDeletePost,
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
                    isGroupAdmin: isGroupAdmin,
                    groupId: groupId,
                    ontapDeletePost: () {
                      Get.back();
                      showDialog(
                        context: context,
                        builder: (c) => CustomAdaptiveAlertDialog(
                          alertMsg: isGroupAdmin
                              ? appText(context).strConfirmBanUserPost
                              : appText(context).strConfirmDeleteUserPost,
                          actiionBtnName: appText(context).strBan,
                          onAction: () {
                            if (isGroupAdmin) {
                              context
                                  .read<NewGroupProvider>()
                                  .banUsersFromPostsGroup(
                                      groupId: groupId, id: post.creatorId);
                              Get.back();
                            } else {
                              postPorvider.deletePost(
                                  postModel: post, groupId: groupId);
                            }
                          },
                        ),
                      );
                    },
                    blockText: curruentUser.blockIds.contains(post.creatorId)
                        ? appText(context).strUnblock
                        : appText(context).strBlock,
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
                                isImage: post.mediaData.first.type == 'Photo'
                                    ? true
                                    : false,
                                isVideo: post.mediaData.first.type == 'Video'
                                    ? true
                                    : false,
                                path:
                                    '${post.mediaData.first.type}${Random().nextInt(2)}${checkMediaTypeAndSetExtention(post.mediaData.first.type)}',
                                url: post.mediaData.first.link,
                              ));
                    },
                  ),
                  isScrollControlled: true,
                );
              }
            }
          },
          ontap: () {},
          headerOnTap: () {
            navigateToAppUserScreen(post.creatorId, context);
          },
        ),
        post.mediaData.first.type == 'Qoute' ||
                post.mediaData.first.type == 'poll'
            ? PostMediaWidgetForQuoteAndPoll(
                post: post,
                isPostDetail: false,
                groupId: groupId,
              )
            : PostMediaWidgetForOtherTypes(
                post: post,
                isPostDetail: false,
                groupId: groupId,
              ),
        heightBox(10.h),
        CustomPostFooter(
          isGroupAdmin: isGroupAdmin,
          groupId: groupId,
          isLike: post.likesIds.contains(curruentUser!.id),
          ontapLike: () {
            ghostProvider.checkGhostMode
                ? GlobalSnackBar.show(
                    message: appText(context).strGhostModeEnabled)
                : postPorvider.toggleLikeDislike(
                    postModel: post,
                    groupId: groupId,
                  );
          },
          ontapSave: () {
            ghostProvider.checkGhostMode
                ? GlobalSnackBar.show(
                    message: appText(context).strGhostModeEnabled)
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
