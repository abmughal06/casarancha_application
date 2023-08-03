import 'package:casarancha/screens/chat/share_post_screen.dart';
import 'package:casarancha/screens/home/post_detail_screen.dart';
import 'package:casarancha/widgets/home_screen_widgets/post_comment_tile.dart';
import 'package:casarancha/widgets/profle_screen_widgets/follow_following_tile.dart';
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
                  child: InkWell(
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
                        const Icon(
                          Icons.visibility,
                          color: colorAA3,
                        ),
                      ],
                    ),
                  ),
                ),
                // widthBox(isVideoPost! ? 5.w : 0.w),
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
          child: StreamProvider.value(
            value: DataProvider().comment(postModel.id),
            initialData: null,
            child: Consumer<List<Comment>?>(
              builder: (context, comment, b) {
                if (comment == null || users == null) {
                  return const CircularProgressIndicator.adaptive();
                }

                if (comment.isEmpty) {
                  return Container();
                }
                var data = comment.first;
                var cmnt = data;
                return cmnt.message.isEmpty
                    ? Container()
                    : PostCommentTile(
                        cmnt: cmnt,
                        isFeedTile: true,
                        postModel: postModel,
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}
