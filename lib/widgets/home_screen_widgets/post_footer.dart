import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/screens/chat/share_post_screen.dart';
import 'package:casarancha/screens/home/post_detail_screen.dart';
import 'package:casarancha/widgets/profle_screen_widgets/follow_following_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/comment_model.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../../screens/profile/AppUser/app_user_screen.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

class CustomPostFooter extends StatelessWidget {
  final bool? isLike;
  final VoidCallback? ontapLike;
  final VoidCallback? ontapSave;
  final Widget? saveBtn;
  final bool? isDesc;
  final bool? isPostDetail;
  final bool? isVideoPost;
  final List<String> savepostIds;
  final PostModel postModel;

  const CustomPostFooter({
    Key? key,
    this.ontapLike,
    this.ontapSave,
    this.isDesc = false,
    this.isLike = false,
    this.isPostDetail = false,
    this.saveBtn,
    this.isVideoPost = false,
    required this.postModel,
    required this.savepostIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widthBox(5.w),
                IconButton(
                  onPressed: ontapLike,
                  icon: Icon(
                    isLike! ? Icons.thumb_up : Icons.thumb_up_outlined,
                    // height: 13,
                    color: isLike! ? colorPrimaryA05 : color887,
                  ),
                ),
                TextWidget(
                  text: postModel.likesIds.length.toString(),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: color221,
                ),
                IconButton(
                  onPressed: () =>
                      Get.to(() => PostDetailScreen(postModel: postModel)),
                  icon: SvgPicture.asset(
                    icCommentPost,
                    color: color887,
                  ),
                ),
                TextWidget(
                  text: postModel.commentIds.length.toString(),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: color221,
                ),
                IconButton(
                  onPressed: () =>
                      Get.to(() => SharePostScreen(postModel: postModel)),
                  icon: const Icon(Icons.share),
                  color: color887,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: isVideoPost!,
                  child: TextWidget(
                    onTap: () {
                      Get.bottomSheet(
                        Consumer<List<UserModel>?>(
                          builder: (context, value, child) {
                            if (value == null) {
                              return const CircularProgressIndicator();
                            }
                            var filterList = value
                                .where((element) =>
                                    postModel.videoViews.contains(element.id))
                                .toList();
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemCount: filterList.length,
                              itemBuilder: (context, index) {
                                return FollowFollowingTile(
                                  user: filterList[index],
                                  ontapToggleFollow: () {},
                                  btnName: "",
                                );
                              },
                            );
                          },
                        ),
                        backgroundColor: Colors.white,
                      );
                    },
                    text: postModel.videoViews.length.toString(),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: color221,
                  ),
                ),
                widthBox(isVideoPost! ? 5.w : 0.w),
                Visibility(
                  visible: isVideoPost!,
                  child: const Icon(
                    Icons.visibility,
                    color: colorAA3,
                  ),
                ),
                IconButton(
                  onPressed: ontapSave,
                  icon: SvgPicture.asset(
                    savepostIds.contains(postModel.id)
                        ? icSavedPost
                        : icBookMarkReg,
                  ),
                ),
              ],
            ),
          ],
        ),
        Visibility(
          visible: postModel.description.isNotEmpty,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
              child: TextWidget(
                text: postModel.description,
                fontSize: 13.sp,
                color: color13F,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Visibility(
          visible: postModel.tagsIds.isNotEmpty,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
              child: Wrap(
                children: postModel.tagsIds
                    .map(
                      (e) => TextWidget(
                        text: e,
                        fontSize: 13.sp,
                        color: color13F,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        Visibility(
          visible: isPostDetail! ? false : postModel.commentIds.isNotEmpty,
          child: Align(
            alignment: Alignment.centerLeft,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .doc(postModel.id)
                  .collection("comments")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!.docs.first.data();
                  var cmnt = Comment.fromMap(data);
                  return ListTile(
                    horizontalTitleGap: 10,
                    onTap: () =>
                        Get.to(() => PostDetailScreen(postModel: postModel)),
                    leading: InkWell(
                      onTap: () =>
                          navigateToAppUserScreen(cmnt.creatorId, context),
                      child: Container(
                        height: 40.h,
                        width: 40.h,
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
                    title: Row(
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
                          convertDateIntoTime(cmnt.createdAt),
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff5c5c5c)),
                        ),
                      ],
                    ),
                    subtitle: TextWidget(
                      text: cmnt.message.isEmpty ? "---" : cmnt.message,
                      fontSize: 12.sp,
                      color: const Color(0xff5f5f5f),
                      fontWeight: FontWeight.w400,
                      textOverflow: TextOverflow.visible,
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
