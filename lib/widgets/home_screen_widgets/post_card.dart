import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_screen.dart';
import 'package:casarancha/utils/snackbar.dart';
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
import '../../resources/color_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../../screens/dashboard/provider/dashboard_provider.dart';
import '../common_widgets.dart';
import '../music_player_url.dart';
import '../text_widget.dart';
import '../video_player_url.dart';

class PostCard extends StatelessWidget {
  const PostCard(
      {Key? key,
      required this.post,
      this.initializedFuturePlay,
      required this.postCreator})
      : super(key: key);

  final PostModel post;
  final Future<void>? initializedFuturePlay;
  final UserModel postCreator;

  @override
  Widget build(BuildContext context) {
    final curruentUser = context.watch<UserModel?>();
    final postPorvider = Provider.of<PostProvider>(context, listen: false);
    final ghostProvider = context.watch<DashboardProvider>();
    return Column(
      children: [
        CustomPostHeader(
          showPostTime: post.showPostTime,
          postCreator: postCreator,
          time: convertDateIntoTime(post.createdAt),
          onVertItemClick: () {
            Get.back();

            if (post.creatorId == curruentUser!.id) {
              Get.bottomSheet(
                Container(
                  decoration: const BoxDecoration(color: Colors.red),
                  height: 80,
                  child: InkWell(
                    onTap: () => postPorvider.deletePost(postModel: post),
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
          ontap: () {},
          headerOnTap: () {
            navigateToAppUserScreen(post.creatorId, context);
          },
        ),
        PostMediaWidget(post: post, isPostDetail: false),
        heightBox(10.h),
        CustomPostFooter(
          isLike: post.likesIds.contains(curruentUser!.id),
          ontapLike: () {
            ghostProvider.checkGhostMode
                ? GlobalSnackBar.show(message: "Ghost Mode is enabled")
                : postPorvider.toggleLikeDislike(
                    postModel: post,
                  );
          },
          ontapSave: () {
            ghostProvider.checkGhostMode
                ? GlobalSnackBar.show(message: "Ghost Mode is enabled")
                : postPorvider.onTapSave(
                    userModel: curruentUser, postId: post.id);
          },
          isVideoPost: post.mediaData[0].type == 'Video',
          postModel: post,
          savepostIds: curruentUser.savedPostsIds,
        ),
      ],
    );
  }
}

Widget? showPostAccordingToItsType(
    {PostModel? post,
    MediaDetails? media,
    VoidCallback? onDoubletap,
    VoidCallback? ontap,
    required BuildContext context}) {
  switch (media!.type) {
    case "Photo":
      return InkWell(
        onTap: ontap,
        onDoubleTap: onDoubletap,
        child: CachedNetworkImage(
          imageUrl: media.link,
          fit: BoxFit.fitWidth,
        ),
      );

    case 'Qoute':
      return InkWell(
        onTap: ontap,
        onDoubleTap: onDoubletap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(
            20,
          ),
          decoration: const BoxDecoration(color: Colors.white),
          child: SingleChildScrollView(
            child: TextWidget(
              text: media.link,
              textAlign: TextAlign.left,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: color221,
            ),
          ),
        ),
      );
    case "Video":
      return InkWell(
        onTap: ontap,
        onDoubleTap: onDoubletap,
        child: VideoPlayerWidget(
          postModel: post,
          videoUrl: media.link,
        ),
      );

    case "Music":
      return AspectRatio(
        aspectRatio: 13 / 9,
        child: InkWell(
          onDoubleTap: onDoubletap,
          child: MusicPlayerUrl(
            border: 0,
            musicDetails: media,
            ontap: () {},
          ),
        ),
      );

    default:
      return Container();
  }
}
