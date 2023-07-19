import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/comment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../resources/image_resources.dart';
import '../../screens/chat/ChatList/chat_list_screen.dart';
import '../../screens/profile/AppUser/app_user_screen.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

class PostCommentTile extends StatelessWidget {
  const PostCommentTile({Key? key, required this.cmnt}) : super(key: key);
  final Comment cmnt;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: InkWell(
        onTap: () {
          Get.to(
            () => AppUserScreen(
              appUserId: cmnt.creatorId,
              appUserName: cmnt.creatorDetails.name,
            ),
          );
        },
        child: Container(
          height: 46.h,
          width: 46.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber,
            image: DecorationImage(
              image: CachedNetworkImageProvider(cmnt.creatorDetails.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: InkWell(
        onTap: () {
          Get.to(
            () => AppUserScreen(
              appUserId: cmnt.creatorId,
              appUserName: cmnt.creatorDetails.name,
            ),
          );
        },
        child: RichText(
          text: TextSpan(
            text: cmnt.creatorDetails.name,
            style: TextStyle(
                fontSize: 14.sp,
                overflow: TextOverflow.ellipsis,
                color: const Color(0xff212121),
                fontWeight: FontWeight.w600),
            children: [
              WidgetSpan(child: widthBox(4.w)),
              if (cmnt.creatorDetails.isVerified)
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
        text: cmnt.message.isEmpty ? "---" : cmnt.message,
        fontSize: 12.sp,
        color: const Color(0xff5f5f5f),
        fontWeight: FontWeight.w400,
        textOverflow: TextOverflow.visible,
      ),
      trailing: Visibility(
        visible: cmnt.creatorId == FirebaseAuth.instance.currentUser!.uid,
        child: InkWell(
          onTap: () {
            if (cmnt.creatorId == FirebaseAuth.instance.currentUser!.uid) {
              Get.bottomSheet(
                Container(
                  decoration: const BoxDecoration(color: Colors.red),
                  height: 80,
                  child: InkWell(
                    onTap: () async {
                      // await FirebaseFirestore.instance
                      //     .collection("posts")
                      //     .doc(cmnt.id)
                      //     .collection("comments")
                      //     .doc(snapshot
                      //         .data!.docs[index].id)
                      //     .delete();

                      // await FirebaseFirestore.instance
                      //     .collection("posts")
                      //     .doc(cmnt.id)
                      //     .update({
                      //   "commentIds":
                      //       FieldValue.arrayRemove([
                      //     snapshot
                      //         .data!.docs[index].id
                      //   ])
                      // });

                      Get.back();
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
  }
}