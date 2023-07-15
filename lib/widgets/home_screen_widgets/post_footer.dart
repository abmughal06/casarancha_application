import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/comment_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

class CustomPostFooter extends StatelessWidget {
  final bool? isLike;
  final String? likes;
  final int? comments;
  final String? desc;
  final VoidCallback? ontapLike;
  final VoidCallback? ontapCmnt;
  final VoidCallback? ontapShare;
  final Widget? saveBtn;
  final String? postId;
  final bool? isDesc;
  final bool? isPostDetail;
  final bool? isVideoPost;
  final String? videoViews;

  const CustomPostFooter({
    Key? key,
    this.likes,
    this.comments,
    this.ontapLike,
    this.ontapCmnt,
    this.ontapShare,
    this.isDesc = false,
    this.desc,
    this.isLike = false,
    this.isPostDetail = false,
    this.saveBtn,
    this.postId,
    this.isVideoPost = false,
    this.videoViews,
  }) : super(key: key);

  // final postController = PostCardController(postdata: postdata);

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
                  text: "$likes",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: color221,
                ),
                IconButton(
                  onPressed: ontapCmnt,
                  icon: SvgPicture.asset(
                    icCommentPost,
                    color: color887,
                  ),
                ),
                TextWidget(
                  text: "$comments",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: color221,
                ),
                IconButton(
                  onPressed: ontapShare,
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
                    text: "$videoViews",
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
                    )),
                saveBtn!,
              ],
            ),
          ],
        ),
        Visibility(
          visible: isDesc!,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
              child: Text(
                "$desc",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: color13F,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: isPostDetail!
              ? false
              : comments != null
                  ? comments! > 0
                  : false,
          child: Align(
            alignment: Alignment.centerLeft,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .doc(postId)
                  .collection("comments")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!.docs.first.data();
                  // var cDetail =
                  //     CreatorDetails.fromMap(data['creatorDetails']);
                  var cmnt = Comment.fromMap(data);
                  return ListTile(
                    horizontalTitleGap: 10,
                    onTap: ontapCmnt,
                    leading: InkWell(
                      onTap: () {
                        // Get.to(
                        //   () => AppUserScreen(
                        //     appUserController: Get.put(
                        //       AppUserController(
                        //         appUserId: cmnt.creatorId,
                        //         currentUserId:
                        //             FirebaseAuth.instance.currentUser!.uid,
                        //       ),
                        //     ),
                        //   ),
                        // );
                      },
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
