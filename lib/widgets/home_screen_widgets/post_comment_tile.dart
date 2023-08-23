import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/comment_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/home/post_detail_screen.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../../screens/profile/AppUser/app_user_screen.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

class PostCommentTile extends StatelessWidget {
  const PostCommentTile(
      {Key? key, required this.cmnt, required this.isFeedTile, this.postModel})
      : super(key: key);
  final Comment cmnt;
  final bool isFeedTile;
  final PostModel? postModel;

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      initialData: null,
      value: DataProvider().getSingleUser(cmnt.creatorId),
      child: Consumer<UserModel?>(builder: (context, appUser, b) {
        if (appUser == null) {
          return Container();
        }
        return ListTile(
          onTap: isFeedTile
              ? () => Get.to(() => PostDetailScreen(postModel: postModel!))
              : null,
          isThreeLine: true,
          leading: InkWell(
            onTap: isFeedTile
                ? null
                : () {
                    navigateToAppUserScreen(cmnt.creatorId, context);
                  },
            child: Container(
              height: 46.h,
              width: 46.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(appUser.imageStr),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: InkWell(
            onTap: isFeedTile
                ? null
                : () {
                    navigateToAppUserScreen(cmnt.creatorId, context);
                  },
            child: RichText(
              text: TextSpan(
                text: appUser.username,
                style: TextStyle(
                    fontSize: 14.sp,
                    overflow: TextOverflow.ellipsis,
                    color: const Color(0xff212121),
                    fontWeight: FontWeight.w600),
                children: [
                  WidgetSpan(child: widthBox(4.w)),
                  if (appUser.isVerified)
                    WidgetSpan(child: SvgPicture.asset(icVerifyBadge)),
                  WidgetSpan(child: widthBox(8.w)),
                  TextSpan(
                    text: convertDateIntoTime(cmnt.createdAt),
                    style: TextStyle(
                      fontSize: 12.sp,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff5c5c5c),
                    ),
                  )
                ],
              ),
            ),
          ),
          subtitle: TextWidget(
            onTap: !isFeedTile
                ? null
                : () => Get.to(() => PostDetailScreen(postModel: postModel!)),
            text: cmnt.message.isEmpty ? "---" : cmnt.message,
            fontSize: 12.sp,
            color: color55F,
            fontWeight: FontWeight.w400,
            textOverflow: TextOverflow.ellipsis,
          ),
          trailing: Visibility(
            visible: FirebaseAuth.instance.currentUser?.uid != null
                ? cmnt.creatorId == FirebaseAuth.instance.currentUser!.uid
                : false,
            child: InkWell(
              onTap: () {
                if (cmnt.creatorId == FirebaseAuth.instance.currentUser!.uid) {
                  Get.bottomSheet(
                    Container(
                      decoration: const BoxDecoration(color: Colors.red),
                      height: 80,
                      child: InkWell(
                        onTap: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection("posts")
                                .doc(cmnt.postId)
                                .collection("comments")
                                .doc(cmnt.id)
                                .delete();

                            await FirebaseFirestore.instance
                                .collection("posts")
                                .doc(cmnt.postId)
                                .update({
                              "commentIds": FieldValue.arrayRemove([cmnt.id])
                            });
                          } catch (e) {
                            GlobalSnackBar.show(message: e.toString());
                          } finally {
                            Get.back();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: "Delete Comment",
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
                }
              },
              child: const Icon(
                Icons.more_vert,
                color: Color(0xffafafaf),
              ),
            ),
          ),
        );
      }),
    );
  }
}
