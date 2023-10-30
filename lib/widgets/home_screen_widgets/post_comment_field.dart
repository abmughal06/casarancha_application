import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';
import '../clip_pad_shadow.dart';

class PostCommentField extends StatelessWidget {
  const PostCommentField({
    Key? key,
    required this.commentController,
    required this.postModel,
    this.groupId,
  }) : super(key: key);

  final TextEditingController commentController;
  final PostModel postModel;
  final String? groupId;

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final user = context.watch<UserModel>();

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
                        postProvider.postComment(
                          postModel: postModel,
                          comment: commentController.text,
                          groupId: groupId,
                          user: user,
                        );

                        commentController.clear();
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
