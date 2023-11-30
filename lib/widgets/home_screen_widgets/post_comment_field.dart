import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/utils/app_utils.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';
import '../profile_pic.dart';

class PostCommentField extends StatelessWidget {
  PostCommentField({
    Key? key,
    required this.commentController,
    required this.postModel,
    this.groupId,
  }) : super(key: key);

  final TextEditingController commentController;
  final PostModel postModel;
  final String? groupId;

  final GlobalKey<FlutterMentionsState> mentionKey =
      GlobalKey<FlutterMentionsState>();

  @override
  Widget build(BuildContext context) {
    List<String> extractIds(String inputText) {
      // Regular expression pattern to match the IDs
      final RegExp regExp = RegExp(r"@\[__(\w+)__\]");

      // Find all matches in the input text
      Iterable<RegExpMatch> matches = regExp.allMatches(inputText);

      // Extract and return the IDs from the matches
      return matches.map((match) => match.group(1)!).toList();
    }

    final postProvider = Provider.of<PostProvider>(context, listen: false);

    final user = context.watch<UserModel>();
    final users = context.watch<List<UserModel>>();

    return Align(
      alignment: Alignment.bottomCenter,
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
        child: TapRegion(
          onTapOutside: (v) {
            FocusScope.of(context).unfocus();
            postProvider.repCommentId = null;
          },
          child: FlutterMentions(
            key: mentionKey,
            focusNode: postProvider.postCommentFocus,
            suggestionPosition: SuggestionPosition.Top,
            suggestionListHeight: 350.h,
            suggestionListDecoration: const BoxDecoration(color: colorWhite),
            mentions: [
              Mention(
                trigger: '@',
                style: const TextStyle(color: Colors.blue),
                data: users
                    .map((e) => {
                          "id": e.id,
                          "display": e.username,
                          'full_name': e.name,
                          'photo': e.imageStr
                        })
                    .toList(),
                suggestionBuilder: (data) {
                  return Container(
                    padding: EdgeInsets.all(10.w),
                    child: Row(
                      children: [
                        ProfilePic(
                          pic: data['photo'],
                          heightAndWidth: 35.w,
                        ),
                        widthBox(
                          20.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['full_name']),
                            heightBox(5.h),
                            Text(
                              '@${data['display']}',
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              )
            ],
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
                    List<String>? ids = extractIds(
                        mentionKey.currentState!.controller!.markupText);
                    printLog(ids.toString());
                    if (postProvider.repCommentId == null) {
                      postProvider.postCommentController.text =
                          mentionKey.currentState!.controller!.text;
                      mentionKey.currentState!.controller!.clear();
                      postProvider.postComment(
                        postModel: postModel,
                        comment: postProvider.postCommentController.text,
                        groupId: groupId,
                        tagsId: ids,
                        user: user,
                      );
                    } else {
                      postProvider.postCommentReply(
                        postModel: postModel,
                        groupId: groupId,
                        reply: postProvider.postCommentController.text,
                        user: user,
                        tagsId: [],
                        recieverId: user.id,
                      );
                      postProvider.repCommentId = null;
                    }
                  },
                  child: Image.asset(
                    imgSendComment,
                    height: 38.h,
                    width: 38.w,
                  ),
                ),
              ),
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

// TextField(
//   focusNode: postProvider.postCommentFocus,
//   controller: commentController,
//   style: TextStyle(
//     color: color239,
//     fontSize: 16.sp,
//     fontFamily: strFontName,
//     fontWeight: FontWeight.w600,
//   ),
//   decoration: InputDecoration(
//     isDense: true,
//     hintText: strWriteComment,
//     hintStyle: TextStyle(
//       color: color55F,
//       fontSize: 14.sp,
//       fontFamily: strFontName,
//       fontWeight: FontWeight.w400,
//     ),
//     suffixIcon: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: GestureDetector(
//             onTap: () {
//               if (postProvider.repCommentId == null) {
//                 postProvider.postComment(
//                   postModel: postModel,
//                   comment: commentController.text,
//                   groupId: groupId,
//                   user: user,
//                 );
//               } else {
//                 postProvider.postCommentReply(
//                   postModel: postModel,
//                   groupId: groupId,
//                   user: user,
//                   recieverId: user.id,
//                 );
//                 postProvider.repCommentId = null;
//               }
//             },
//             child: Image.asset(
//               imgSendComment,
//               height: 38.h,
//               width: 38.w,
//             ))),
//     contentPadding:
//         EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
//     focusColor: Colors.transparent,
//     focusedBorder: const OutlineInputBorder(
//       borderSide: BorderSide(
//         width: 0,
//         color: Colors.transparent,
//       ),
//     ),
//   ),
//   minLines: 1,
//   maxLines: 3,
//   keyboardType: TextInputType.multiline,
//   textInputAction: TextInputAction.newline,
//   onTapOutside: (v) {
//     FocusScope.of(context).unfocus();
//     postProvider.repCommentId = null;
//   },
//   onEditingComplete: () => FocusScope.of(context).unfocus(),
// ),
