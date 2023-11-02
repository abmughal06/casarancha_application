import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_footer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../../screens/profile/AppUser/app_user_screen.dart';
import '../../utils/snackbar.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

class PostCreatorProfileTile extends StatelessWidget {
  const PostCreatorProfileTile({
    Key? key,
    required this.post,
    this.groupId,
  }) : super(key: key);
  final PostModel post;
  final String? groupId;

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final curruentUser = context.watch<UserModel?>();
    final ghostProvider = Provider.of<DashboardProvider>(context);
    final appUser = context
        .watch<List<UserModel>?>()!
        .where((element) => element.id == post.creatorId)
        .first;

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
            isLike:
                post.likesIds.contains(FirebaseAuth.instance.currentUser!.uid),
            isPostDetail: true,
            ontapLike: () => postProvider.toggleLikeDislike(
              postModel: post,
              groupId: groupId,
            ),
            ontapSave: () {
              ghostProvider.checkGhostMode
                  ? GlobalSnackBar.show(message: "Ghost Mode is enabled")
                  : postProvider.onTapSave(
                      userModel: curruentUser, postId: post.id);
            },
            postModel: post,
            savepostIds: curruentUser!.savedPostsIds,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 34.h,
                      width: 34.h,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () => navigateToAppUserScreen(
                                post.creatorId, context),
                            child: appUser.imageStr != ''
                                ? Container(
                                    height: 30.h,
                                    width: 30.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          appUser.imageStr,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 30.h,
                                    width: 30.h,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          imgUserPlaceHolder,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          Visibility(
                            visible: appUser.isVerified,
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
                          onTap: () =>
                              navigateToAppUserScreen(post.creatorId, context),
                          text: appUser.username,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        TextWidget(
                          text:
                              "${post.showPostTime ? "${convertDateIntoTime(post.createdAt)} " : ""}${post.locationName.isEmpty ? "" : "at ${post.locationName}"}",
                          fontWeight: FontWeight.w400,
                          fontSize: 9.sp,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ],
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
                Visibility(
                  visible: post.tagsIds.isNotEmpty,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      children: post.tagsIds
                          .map(
                            (e) => Padding(
                              padding: EdgeInsets.only(right: 6.w),
                              child: TextWidget(
                                text: e,
                                fontSize: 13.sp,
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                          .toList(),
                    ),
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
