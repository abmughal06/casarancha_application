import 'package:casarancha/screens/chat/share_post_screen.dart';
import 'package:casarancha/screens/home/post_detail_screen.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_comment_tile.dart';
import 'package:casarancha/widgets/profle_screen_widgets/follow_following_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/comment_model.dart';
import '../../models/post_model.dart';
import '../../models/providers/user_data_provider.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/profile/AppUser/app_user_screen.dart';
import '../../utils/app_utils.dart';
import '../common_widgets.dart';
import '../shared/skeleton.dart';
import '../text_widget.dart';

class CustomPostFooter extends StatelessWidget {
  final bool? isLike;
  final VoidCallback? ontapLike;
  final VoidCallback? ontapSave;
  final Widget? saveBtn;
  final bool? isDesc;
  final bool? isPostDetail;
  final List<String> savepostIds;
  final PostModel postModel;
  final String? groupId;

  const CustomPostFooter({
    Key? key,
    this.ontapLike,
    this.ontapSave,
    this.isDesc = false,
    this.isLike = false,
    this.isPostDetail = false,
    this.saveBtn,
    required this.postModel,
    required this.savepostIds,
    this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = context.watch<List<UserModel>?>();
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
                  onPressed: () {
                    Get.to(() => PostDetailScreen(
                          postModel: postModel,
                          groupId: groupId,
                        ));
                    // music.audioPlayer.pause();
                  },
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
                widthBox(12.w),
                GestureDetector(
                  onTap: groupId != null
                      ? () {
                          GlobalSnackBar.show(message: 'coming soon');
                        }
                      : () => Get.to(() => SharePostScreen(
                            postModel: postModel,
                            groupId: groupId,
                          )),
                  child: const Icon(
                    Icons.share,
                    color: color887,
                  ),
                ),
                widthBox(10.w),
                TextWidget(
                  text: postModel.shareCount.length.toString(),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: color221,
                  onTap: () {
                    Get.bottomSheet(
                      Consumer<List<UserModel>?>(
                        builder: (context, value, child) {
                          if (value == null) {
                            return const CircularProgressIndicator.adaptive();
                          }
                          var filterList = value
                              .where((element) =>
                                  postModel.shareCount.contains(element.id))
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
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      Consumer<List<UserModel>?>(
                        builder: (context, value, child) {
                          if (value == null) {
                            return const CircularProgressIndicator.adaptive();
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
                  child: Row(
                    children: [
                      TextWidget(
                        text: postModel.videoViews.length.toString(),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: color221,
                      ),
                      widthBox(5.w),
                      Icon(
                        postModel.mediaData.first.type == 'Music'
                            ? Icons.headset
                            : postModel.mediaData.first.type == 'Photo'
                                ? Icons.camera_alt
                                : postModel.mediaData.first.type == 'Qoute'
                                    ? Icons.notes
                                    : Icons.visibility,
                        color: colorAA3,
                      ),
                    ],
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
          visible: !isPostDetail! && postModel.description.isNotEmpty,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
              child: SelectableTextWidget(
                text: postModel.description,
                fontSize: 13.sp,
                color: color13F,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Visibility(
          visible: !isPostDetail! && postModel.tagsIds.isNotEmpty,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Wrap(
                children: postModel.tagsIds.map((userId) {
                  return Consumer<List<UserModel>?>(
                    builder: (context, tagusers, child) {
                      if (tagusers == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        var userList = tagusers
                            .where((element) => element.id == userId)
                            .toList();

                        if (userList.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        var username =
                            userList.map((e) => e.username).join(", ");
                        return Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.69,
                          ),
                          child: RichText(
                            text: highlightMentions(
                              text: "@$username ",
                              context: context,
                              onTap: () {
                                printLog('============>>>>>>>>>tagged');
                                onUsernameTap(username, context);
                              },
                            ),
                          ),
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        Visibility(
          visible: isPostDetail! ? false : postModel.commentIds.isNotEmpty,
          child: StreamProvider.value(
            value:
                DataProvider().comment(cmntId: postModel.id, groupId: groupId),
            initialData: null,
            catchError: (context, error) => null,
            child: Consumer<List<Comment>?>(
              builder: (context, comment, b) {
                if (comment == null || users == null) {
                  return Row(
                    children: [
                      Skeleton(
                        height: 44.w,
                        width: 44.w,
                        radius: 1000.r,
                      ),
                      widthBox(15.w),
                      Column(
                        children: [
                          Skeleton(height: 10.h, width: 250.w, radius: 10),
                          heightBox(10.h),
                          Skeleton(height: 10.h, width: 180.w, radius: 10),
                        ],
                      )
                    ],
                  );
                }

                if (comment.isEmpty) {
                  return Container();
                }
                var data = comment.first;
                var cmnt = data;
                return cmnt.message.isEmpty
                    ? Container()
                    : FeedPostCommentTile(
                        cmnt: cmnt,
                        isFeedTile: true,
                        postModel: postModel,
                        groupId: groupId,
                      );
              },
            ),
          ),
        ),
        // heightBox(12.h),
      ],
    );
  }
}

Stream<String?> streamUsername(UserModel user) {
  try {
    // Assuming you have a 'users' collection in Firestore with documents having 'userId' field
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        // Assuming the 'username' field in the document contains the username
        return snapshot.data()?['username'];
      } else {
        return null; // User not found
      }
    });
  } catch (e) {
    print('Error streaming username: $e');
    return Stream.value(null);
  }
}
