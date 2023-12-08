import 'dart:math';

import 'package:casarancha/models/comment_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/chat/share_post_screen.dart';
import 'package:casarancha/screens/home/post_detail_screen.dart';
import 'package:casarancha/screens/home/providers/post_provider.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/utils/app_utils.dart';
import 'package:casarancha/widgets/home_screen_widgets/report_sheet.dart';
import 'package:casarancha/widgets/profile_pic.dart';
import 'package:casarancha/widgets/shared/alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
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
import '../../utils/snackbar.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

class PostCommentTile extends StatefulWidget {
  const PostCommentTile(
      {super.key,
      required this.cmnt,
      required this.isFeedTile,
      this.postModel,
      this.groupId});
  final Comment cmnt;
  final bool isFeedTile;
  final PostModel? postModel;
  final String? groupId;

  @override
  State<PostCommentTile> createState() => _PostCommentTileState();
}

class _PostCommentTileState extends State<PostCommentTile> {
  late bool isReplyShow;

  @override
  void initState() {
    isReplyShow = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    return StreamProvider.value(
      initialData: null,
      catchError: (context, error) => null,
      value: DataProvider().getSingleUser(widget.cmnt.creatorId),
      child: Consumer<UserModel?>(builder: (context, appUser, b) {
        if (appUser == null) {
          return Container();
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {
                            navigateToAppUserScreen(
                                widget.cmnt.creatorId, context);
                          },
                          child: ProfilePic(
                              pic: appUser.imageStr, heightAndWidth: 40.h)),
                      widthBox(10.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              navigateToAppUserScreen(
                                  widget.cmnt.creatorId, context);
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "${appUser.username} ",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    overflow: TextOverflow.ellipsis,
                                    color: const Color(0xff212121),
                                    fontWeight: FontWeight.w600),
                                children: [
                                  if (appUser.isVerified)
                                    WidgetSpan(
                                        child: SvgPicture.asset(
                                      icVerifyBadge,
                                      height: 16.h,
                                    )),
                                  TextSpan(
                                    text:
                                        " ${convertDateIntoTime(widget.cmnt.createdAt)}",
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
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.69),
                            child: RichText(
                              text: highlightMentions(
                                text: widget.cmnt.message,
                                context: context,
                                onTap: () {
                                  printLog('============>>>>>>>>>comment');
                                  var username =
                                      extractUsername(widget.cmnt.message);
                                  onUsernameTap(username!, context);
                                },
                              ),
                            ),
                          ),
                          heightBox(5.h),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  postProvider.toggleLikeComment(
                                    groupId: widget.groupId,
                                    postId: widget.cmnt.postId,
                                    cmntId: widget.cmnt.id,
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      widget.cmnt.likeIds
                                              .contains(currentUserUID)
                                          ? Icons.thumb_up
                                          : Icons.thumb_up_outlined,
                                      size: 14.r,
                                      color: widget.cmnt.likeIds
                                              .contains(currentUserUID)
                                          ? colorPrimaryA05
                                          : color887,
                                    ),
                                    widthBox(5.w),
                                    TextWidget(
                                      text:
                                          widget.cmnt.likeIds.length.toString(),
                                      fontSize: 11.sp,
                                    ),
                                  ],
                                ),
                              ),
                              widthBox(15.w),
                              InkWell(
                                onTap: () {
                                  postProvider.toggleDislikeComment(
                                    groupId: widget.groupId,
                                    postId: widget.cmnt.postId,
                                    cmntId: widget.cmnt.id,
                                  );
                                },
                                child: Row(
                                  children: [
                                    Transform.rotate(
                                      angle: pi / 1,
                                      child: Icon(
                                        widget.cmnt.dislikeIds.contains(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            ? Icons.thumb_up
                                            : Icons.thumb_up_outlined,
                                        size: 14.r,
                                        color: widget.cmnt.dislikeIds.contains(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            ? colorPrimaryA05
                                            : color887,
                                      ),
                                    ),
                                    widthBox(5.w),
                                    TextWidget(
                                      text: widget.cmnt.dislikeIds.length
                                          .toString(),
                                      fontSize: 11.sp,
                                    ),
                                  ],
                                ),
                              ),
                              widthBox(15.w),
                              InkWell(
                                onTap: () {
                                  postProvider.postCommentController.text =
                                      '@${appUser.username} ';
                                  postProvider.postCommentFocus.requestFocus();
                                  postProvider.repCommentId = widget.cmnt.id;
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      icCommentPost,
                                      height: 13.r,
                                    ),
                                    widthBox(5.w),
                                    TextWidget(
                                      text: widget.cmnt.replyIds.length
                                          .toString(),
                                      fontSize: 11.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          heightBox(5.h),
                          Visibility(
                            visible:
                                widget.cmnt.replyIds.isNotEmpty && !isReplyShow,
                            child: TextWidget(
                              text: 'show ${widget.cmnt.replyIds.length} reply',
                              color: Colors.blue,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    isReplyShow = true;
                                  });
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          decoration: const BoxDecoration(color: colorWhite),
                          height: 200.h,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(icBottomSheetScroller),
                              ),
                              heightBox(15.h),
                              TextWidget(
                                onTap: () => Get.to(() => SharePostScreen(
                                    postModel: widget.postModel!)),
                                text: "Share",
                                fontWeight: FontWeight.w600,
                              ),
                              heightBox(10.h),
                              widget.cmnt.creatorId != currentUserUID
                                  ? ReportPostorComment(
                                      btnName: 'Report Comment')
                                  : heightBox(0),
                              heightBox(10.h),
                              widget.cmnt.creatorId == currentUserUID
                                  ? TextWidget(
                                      text: "Delete",
                                      color: colorPrimaryA05,
                                      fontWeight: FontWeight.w600,
                                      onTap: () async {
                                        Get.back();
                                        showDialog(
                                            context: context,
                                            builder: (_) =>
                                                CustomAdaptiveAlertDialog(
                                                    alertMsg:
                                                        "Are you sure you want to delete your comment?",
                                                    actiionBtnName: 'Delete',
                                                    onAction: () {
                                                      postProvider
                                                          .deleteComment(
                                                        groupId: widget.groupId,
                                                        postId:
                                                            widget.cmnt.postId,
                                                        cmntId: widget.cmnt.id,
                                                      );
                                                    }));
                                      },
                                    )
                                  : heightBox(0),
                            ],
                          ),
                        ),
                        isScrollControlled: true,
                      );
                    },
                    child: const Icon(
                      Icons.more_vert,
                      color: Color(0xffafafaf),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: isReplyShow,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostCommentReplyTile(
                      comment: widget.cmnt,
                      postModel: widget.postModel!,
                      groupId: widget.groupId,
                    ),
                    Visibility(
                      visible: widget.cmnt.replyIds.isNotEmpty,
                      child: Padding(
                        padding: EdgeInsets.only(left: 50.w),
                        child: TextWidget(
                          text: 'hide reply',
                          color: Colors.blue,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                isReplyShow = false;
                              });
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

Future<String> fetchUserId(String username) async {
  try {
    // Query Firestore for the user with the given username
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If a user with the given username is found, return their user ID
      return querySnapshot.docs.first.id;
    } else {
      throw Exception('User not found for username: $username');
    }
  } catch (error) {
    printLog('Error fetching user id: $error');
    // Handle error, show a message to the user, etc.
    throw Exception('Error fetching user id');
  }
}

void onUsernameTap(String username, context) async {
  try {
    // Simulate fetching user id from Firestore or another data source
    String userId = await fetchUserId(username);

    // Now you have the userId, and you can navigate to the user's profile page
    navigateToAppUserScreen(userId, context);
  } catch (error) {
    printLog('Error fetching user id: $error');
    // Handle error, show a message to the user, etc.
  }
}

String? extractUsername(String tappedText) {
  final mentionPattern = RegExp(r'@(\w+(\.\w+)?)');
  final match = mentionPattern.firstMatch(tappedText);

  if (match != null) {
    return match.group(1);
  } else {
    return null;
  }
}

TextSpan highlightMentions({
  String? text,
  BuildContext? context,
  VoidCallback? onTap,
}) {
  final mentionPattern = RegExp(r'@(\w+\.)?\w+');

  final segments = mentionPattern.allMatches(text!);

  final spans = <TextSpan>[];
  int currentIndex = 0;

  for (final segment in segments) {
    spans.add(TextSpan(
      text: text.substring(currentIndex, segment.start),
      style: TextStyle(
        fontSize: 12.sp,
        color: color55F,
        fontWeight: FontWeight.w400,
        overflow: TextOverflow.ellipsis,
      ),
    ));

    spans.add(TextSpan(
      text: segment.group(0),
      style: TextStyle(
        color: Colors.blue,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          // Extract the username from the tapped mention
          var username = extractUsername(segment.group(0).toString());
          onTap?.call();
          onUsernameTap(username!, context);
        },
    ));

    currentIndex = segment.end;
  }

  spans.add(TextSpan(
    text: text.substring(currentIndex),
    style: const TextStyle(color: Colors.black),
  ));

  return TextSpan(children: spans);
}

class FeedPostCommentTile extends StatelessWidget {
  const FeedPostCommentTile(
      {super.key,
      required this.cmnt,
      required this.isFeedTile,
      this.postModel,
      this.groupId});
  final Comment cmnt;
  final bool isFeedTile;
  final PostModel? postModel;
  final String? groupId;

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      initialData: null,
      value: DataProvider().getSingleUser(cmnt.creatorId),
      catchError: (context, error) => null,
      child: Consumer<UserModel?>(
        builder: (context, appUser, b) {
          if (appUser == null) {
            return Container();
          }
          return ListTile(
            minVerticalPadding: 0,
            onTap: () => Get.to(() => PostDetailScreen(
                  postModel: postModel!,
                  groupId: groupId,
                )),
            leading: ProfilePic(pic: appUser.imageStr, heightAndWidth: 46.h),
            title: RichText(
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
            subtitle: InkWell(
                onTap: () {
                  Get.to(
                    () => PostDetailScreen(
                      postModel: postModel!,
                      groupId: groupId,
                    ),
                  );
                },
                child: RichText(
                  text: highlightMentions(
                    text: cmnt.message.isEmpty ? "---" : cmnt.message,
                    context: context,
                    onTap: () {
                      printLog('============>>>>>>>>>comment');
                      var username = extractUsername(cmnt.message);
                      onUsernameTap(username!, context);
                    },
                  ),
                )),
            // TextWidget(
            //   onTap: () => Get.to(() => PostDetailScreen(
            //         postModel: postModel!,
            //         groupId: groupId,
            //       )),
            //   text: cmnt.message.isEmpty ? "---" : cmnt.message,
            //   fontSize: 12.sp,
            //   color: color55F,
            //   fontWeight: FontWeight.w400,
            //   textOverflow: TextOverflow.ellipsis,
            // )
          );
        },
      ),
    );
  }
}

class PostCommentReplyTile extends StatelessWidget {
  const PostCommentReplyTile({
    super.key,
    required this.comment,
    this.groupId,
    required this.postModel,
  });

  final Comment comment;
  final String? groupId;
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return StreamProvider.value(
      initialData: null,
      catchError: (context, error) => null,
      value: DataProvider().commentReply(
          postId: comment.postId, cmntId: comment.id, groupId: groupId),
      child: Consumer<List<Comment>?>(
        builder: (context, reps, b) {
          if (reps == null) {
            return Container();
          }
          return ListView.builder(
            itemCount: reps.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(left: 45.w),
            itemBuilder: (context, index) {
              var rep = reps[index];

              return StreamProvider.value(
                value: DataProvider().getSingleUser(rep.creatorId),
                catchError: (context, error) =>
                    GlobalSnackBar.show(message: error.toString()),
                initialData: null,
                child: Consumer<UserModel?>(
                  builder: (context, repUser, b) {
                    if (repUser == null) {
                      return Container();
                    }
                    return Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        navigateToAppUserScreen(
                                            rep.creatorId, context);
                                      },
                                      child: ProfilePic(
                                          pic: repUser.imageStr,
                                          heightAndWidth: 40.h)),
                                  widthBox(10.w),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          navigateToAppUserScreen(
                                              rep.creatorId, context);
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            text: "${repUser.username} ",
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                overflow: TextOverflow.ellipsis,
                                                color: const Color(0xff212121),
                                                fontWeight: FontWeight.w600),
                                            children: [
                                              if (repUser.isVerified)
                                                WidgetSpan(
                                                    child: SvgPicture.asset(
                                                  icVerifyBadge,
                                                  height: 16.h,
                                                )),
                                              TextSpan(
                                                text:
                                                    " ${convertDateIntoTime(rep.createdAt)}",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      const Color(0xff5c5c5c),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        text: highlightMentions(
                                          text: rep.message.isEmpty
                                              ? '---'
                                              : rep.message,
                                          context: context,
                                          onTap: () {
                                            printLog(
                                                '============>>>>>>>>>comment');
                                            var username =
                                                extractUsername(rep.message);
                                            onUsernameTap(username!, context);
                                          },
                                        ),
                                      ),
                                      // SelectableTextWidget(
                                      //   text: rep.message.isEmpty
                                      //       ? "---"
                                      //       : rep.message,
                                      //   fontSize: 12.sp,
                                      //   color: color55F,
                                      //   fontWeight: FontWeight.w400,
                                      //   textOverflow: TextOverflow.ellipsis,
                                      // ),
                                      heightBox(5.h),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              postProvider
                                                  .toggleLikeCommentReply(
                                                groupId: groupId,
                                                postId: comment.postId,
                                                cmntId: comment.id,
                                                repId: rep.id,
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  rep.likeIds.contains(
                                                          currentUserUID)
                                                      ? Icons.thumb_up
                                                      : Icons.thumb_up_outlined,
                                                  size: 14.r,
                                                  color: rep.likeIds.contains(
                                                          currentUserUID)
                                                      ? colorPrimaryA05
                                                      : color887,
                                                ),
                                                widthBox(5.w),
                                                TextWidget(
                                                  text: rep.likeIds.length
                                                      .toString(),
                                                  fontSize: 11.sp,
                                                ),
                                              ],
                                            ),
                                          ),
                                          widthBox(15.w),
                                          InkWell(
                                            onTap: () {
                                              postProvider
                                                  .toggleDislikeCommentReply(
                                                groupId: groupId,
                                                postId: comment.postId,
                                                cmntId: comment.id,
                                                repId: rep.id,
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Transform.rotate(
                                                  angle: pi / 1,
                                                  child: Icon(
                                                    rep.dislikeIds.contains(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                        ? Icons.thumb_up
                                                        : Icons
                                                            .thumb_up_outlined,
                                                    size: 14.r,
                                                    color: rep.dislikeIds
                                                            .contains(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                        ? colorPrimaryA05
                                                        : color887,
                                                  ),
                                                ),
                                                widthBox(5.w),
                                                TextWidget(
                                                  text: rep.dislikeIds.length
                                                      .toString(),
                                                  fontSize: 11.sp,
                                                ),
                                              ],
                                            ),
                                          ),
                                          widthBox(10.w),
                                          InkWell(
                                            onTap: () {
                                              postProvider.postCommentController
                                                      .text =
                                                  '@${repUser.username} ';
                                              postProvider.postCommentFocus
                                                  .requestFocus();
                                              postProvider.repCommentId =
                                                  comment.id;
                                            },
                                            child: Row(
                                              children: [
                                                TextWidget(
                                                  text: 'reply',
                                                  fontSize: 11.sp,
                                                  color: color221,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Get.bottomSheet(
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: colorWhite),
                                      height: 200.h,
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: SvgPicture.asset(
                                                icBottomSheetScroller),
                                          ),
                                          heightBox(15.h),
                                          TextWidget(
                                            onTap: () => Get.to(() =>
                                                SharePostScreen(
                                                    postModel: postModel)),
                                            text: "Share",
                                            fontWeight: FontWeight.w600,
                                          ),
                                          heightBox(10.h),
                                          comment.creatorId != currentUserUID
                                              ? ReportPostorComment(
                                                  btnName: 'Report Comment')
                                              : heightBox(0),
                                          heightBox(10.h),
                                          comment.creatorId == currentUserUID
                                              ? TextWidget(
                                                  text: "Delete",
                                                  color: colorPrimaryA05,
                                                  fontWeight: FontWeight.w600,
                                                  onTap: () async {
                                                    Get.back();
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            CustomAdaptiveAlertDialog(
                                                                alertMsg:
                                                                    "Are you sure you want to delete your comment?",
                                                                actiionBtnName:
                                                                    'Delete',
                                                                onAction: () {
                                                                  postProvider
                                                                      .deleteComment(
                                                                    groupId:
                                                                        groupId,
                                                                    postId: comment
                                                                        .postId,
                                                                    cmntId:
                                                                        rep.id,
                                                                  );
                                                                }));
                                                  },
                                                )
                                              : heightBox(0),
                                        ],
                                      ),
                                    ),
                                    isScrollControlled: true,
                                  );
                                },
                                child: const Icon(
                                  Icons.more_vert,
                                  color: Color(0xffafafaf),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
