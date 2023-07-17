import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';
import '../clip_pad_shadow.dart';

class PostCommentField extends StatelessWidget {
  const PostCommentField({Key? key, required this.commentController})
      : super(key: key);

  final TextEditingController commentController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        clipper: const ClipPad(padding: EdgeInsets.only(top: 30)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(color: colorWhite, boxShadow: [
            BoxShadow(
              color: colorPrimaryA05.withOpacity(.36),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(4, 0),
            ),
          ]),
          child: TextField(
            controller: commentController,
            style: TextStyle(
              color: color239,
              fontSize: 16.sp,
              fontFamily: strFontName,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: strWriteComment,
              hintStyle: TextStyle(
                color: color55F,
                fontSize: 14.sp,
                fontFamily: strFontName,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                      onTap: () {
                        // var cmnt = Comment(
                        //   id: widget.postModel.id,
                        //   creatorId:
                        //       FirebaseAuth.instance.currentUser!.uid,
                        //   creatorDetails: CreatorDetails(
                        //       name: user!.name,
                        //       imageUrl: user!.imageStr,
                        //       isVerified: user!.isVerified),
                        //   createdAt: DateTime.now().toIso8601String(),
                        //   message: coommenController.text,
                        // );

                        // FirebaseFirestore.instance
                        //     .collection("posts")
                        //     .doc(widget.postModel.id)
                        //     .collection("comments")
                        //     .doc()
                        //     .set(cmnt.toMap(), SetOptions(merge: true))
                        //     .then((value) async {
                        //   coommenController.clear();
                        //   var cmntId = await FirebaseFirestore.instance
                        //       .collection("posts")
                        //       .doc(widget.postModel.id)
                        //       .collection("comments")
                        //       .get();

                        //   List listOfCommentsId = [];
                        //   for (var i in cmntId.docs) {
                        //     listOfCommentsId.add(i.id);
                        //   }

                        //   print(
                        //       "+++========+++++++++============+++++++++ $listOfCommentsId ");
                        //   FirebaseFirestore.instance
                        //       .collection("posts")
                        //       .doc(widget.postModel.id)
                        //       .set({"commentIds": listOfCommentsId},
                        //           SetOptions(merge: true));

                        //   var recieverRef = await FirebaseFirestore
                        //       .instance
                        //       .collection("users")
                        //       .doc(widget.postModel.creatorId)
                        //       .get();

                        //   var recieverFCMToken =
                        //       recieverRef.data()!['fcmToken'];
                        //   print(
                        //       "=========> reciever fcm token = $recieverFCMToken");
                        //   FirebaseMessagingService()
                        //       .sendNotificationToUser(
                        //     appUserId: recieverRef.id,
                        //     imageUrl:
                        //         widget.postModel.mediaData[0].type ==
                        //                 'Photo'
                        //             ? widget.postModel.mediaData[0].link
                        //             : '',
                        //     devRegToken: recieverFCMToken,
                        //     msg: "has commented on your post.",
                        //   );
                        // });
                      },
                      child: Image.asset(
                        imgSendComment,
                        height: 38.h,
                        width: 38.w,
                      ))),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
              focusColor: Colors.transparent,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0,
                  color: Colors.transparent,
                ),
              ),
            ),
            minLines: 1,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            onEditingComplete: () => FocusScope.of(context).unfocus(),
          ),
        ),
      ),
    );
  }
}
