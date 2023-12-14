import 'package:casarancha/screens/home/providers/post_provider.dart';
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
  const PostCommentField({
    super.key,
    required this.postModel,
    this.groupId,
  });

  final PostModel postModel;
  final String? groupId;

  @override
  Widget build(BuildContext context) {
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
            key: postProvider.mentionKey,
            focusNode: postProvider.postCommentFocus,
            suggestionPosition: SuggestionPosition.Top,
            maxLines: 3,
            minLines: 1,
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
                    List ids = extractIds(postProvider
                        .mentionKey.currentState!.controller!.markupText);
                    postProvider.commentTagsId = ids;

                    if (postProvider.repCommentId == null) {
                      postProvider.postComment(
                        postModel: postModel,
                        groupId: groupId,
                        user: user,
                        allUsers: users,
                      );
                    } else {
                      postProvider.postCommentReply(
                        postModel: postModel,
                        groupId: groupId,
                        user: user,
                        recieverId: user.id,
                        allUsers: users,
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
            style: TextStyle(
              color: color239,
              fontSize: 14.sp,
              fontFamily: strFontName,
              fontWeight: FontWeight.w400,
            ),
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
              ),
            ],
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        ),
      ),
    );
  }
}

List<String> extractIds(String inputText) {
  // Regular expression pattern to match the IDs
  final RegExp regExp = RegExp(r"@\[__(\w+)__\]");

  // Find all matches in the input text
  Iterable<RegExpMatch> matches = regExp.allMatches(inputText);

  // Extract and return the IDs from the matches
  return matches.map((match) => match.group(1)!).toList();
}


// Align(
//           alignment: Alignment.topCenter,
//           child: Visibility(
//             visible: postProvider.isMentionActive,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.all(15),
//               child: users == null
//                   ? heightBox(1)
//                   : ListView.builder(
//                       itemCount: users.length,
//                       itemBuilder: (context, index) {
//                         return GestureDetector(
//                           onTap: () {
//                             postProvider.tagUserAndSaveId(users[index]);
//                             print(postProvider.commentTagsId.toString());
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(10.w),
//                             child: Row(
//                               children: [
//                                 ProfilePic(
//                                   pic: users[index].imageStr,
//                                   heightAndWidth: 35.w,
//                                 ),
//                                 widthBox(
//                                   20.w,
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(users[index].name),
//                                     heightBox(5.h),
//                                     Text(
//                                       '@${users[index].username}',
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//             ),
//           ),
//         ),


// TextField(
//               focusNode: postProvider.postCommentFocus,
//               controller: postProvider.postCommentController,
//               style: TextStyle(
//                 color: color239,
//                 fontSize: 16.sp,
//                 fontFamily: strFontName,
//                 fontWeight: FontWeight.w600,
//               ),
//               decoration: InputDecoration(
//                 isDense: true,
//                 hintText: strWriteComment,
//                 hintStyle: TextStyle(
//                   color: color55F,
//                   fontSize: 14.sp,
//                   fontFamily: strFontName,
//                   fontWeight: FontWeight.w400,
//                 ),
//                 suffixIcon: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: GestureDetector(
//                         onTap: () {
//                           if (postProvider.repCommentId == null) {
//                             postProvider.postComment(
//                               postModel: postModel,
//                               comment: commentController.text,
//                               groupId: groupId,
//                               user: user,
//                             );
//                           } else {
//                             postProvider.postCommentReply(
//                               postModel: postModel,
//                               groupId: groupId,
//                               user: user,
//                               recieverId: user.id,
//                             );
//                             postProvider.repCommentId = null;
//                           }
//                         },
//                         child: Image.asset(
//                           imgSendComment,
//                           height: 38.h,
//                           width: 38.w,
//                         ))),
//                 contentPadding:
//                     EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
//                 focusColor: Colors.transparent,
//                 focusedBorder: const OutlineInputBorder(
//                   borderSide: BorderSide(
//                     width: 0,
//                     color: Colors.transparent,
//                   ),
//                 ),
//               ),
//               minLines: 1,
//               maxLines: 3,
//               keyboardType: TextInputType.multiline,
//               textInputAction: TextInputAction.newline,
//               onTapOutside: (v) {
//                 if (!postProvider.isMentionActive) {
//                   FocusScope.of(context).unfocus();
//                 }
//                 postProvider.repCommentId = null;
//               },
//               onEditingComplete: () => FocusScope.of(context).unfocus(),
//             ),