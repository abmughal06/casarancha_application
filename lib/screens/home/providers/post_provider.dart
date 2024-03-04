import 'dart:developer';

import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/Chat%20one-to-one/chat_controller.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/utils/app_utils.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../models/comment_model.dart';
import '../../../models/message.dart';
import '../../../models/message_details.dart';
import '../../../models/post_creator_details.dart';
import '../../../models/post_model.dart';
import '../../../resources/firebase_cloud_messaging.dart';
import '../../../resources/image_resources.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/text_widget.dart';

class PostProvider extends ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  final fauth = FirebaseAuth.instance;
  final currentUserRef = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  final GlobalKey<FlutterMentionsState> mentionKey =
      GlobalKey<FlutterMentionsState>();

  bool isMentionActive = false;
  List commentTagsId = [];

  final FocusNode postCommentFocus = FocusNode();
  String? repCommentId;

  void toggleLikeDislike({PostModel? postModel, String? groupId}) async {
    final postRef = groupId != null
        ? FirebaseFirestore.instance
            .collection("groups")
            .doc(groupId)
            .collection('posts')
        : FirebaseFirestore.instance.collection("posts");

    log(postModel!.id.toString());
    try {
      var uid = fauth.currentUser!.uid;

      if (postModel.likesIds.contains(uid)) {
        await postRef.doc(postModel.id).update({
          'likesIds': FieldValue.arrayRemove([uid])
        });
      } else {
        await postRef.doc(postModel.id).update({
          'likesIds': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      log("$e");
    } finally {
      notifyListeners();
    }
  }

  void onTapSave({
    UserModel? userModel,
    String? postId,
  }) async {
    try {
      if (userModel!.savedPostsIds.contains(postId)) {
        await currentUserRef.update({
          "savedPostsIds": FieldValue.arrayRemove([postId])
        });
      } else {
        await currentUserRef.update({
          "savedPostsIds": FieldValue.arrayUnion([postId])
        });
      }
    } catch (e) {
      log('$e');
    }
  }

  void deletePost({PostModel? postModel, String? groupId}) async {
    final postRef = groupId != null
        ? FirebaseFirestore.instance
            .collection("groups")
            .doc(groupId)
            .collection('posts')
        : FirebaseFirestore.instance.collection("posts");

    var userRef =
        FirebaseFirestore.instance.collection('users').doc(currentUserUID);
    try {
      await postRef.doc(postModel!.id).delete().then((value) => Get.back());
      await userRef.update({
        'postsIds': FieldValue.arrayRemove([postModel.id])
      });
    } catch (e) {
      log("$e");
    }
  }

  void countVideoViews({PostModel? postModel, String? groupId}) async {
    final postRef = groupId != null
        ? FirebaseFirestore.instance
            .collection("groups")
            .doc(groupId)
            .collection('posts')
        : FirebaseFirestore.instance.collection("posts");
    try {
      if (fauth.currentUser?.uid != null) {
        if (!postModel!.videoViews.contains(fauth.currentUser!.uid)) {
          await postRef.doc(postModel.id).set({
            'videoViews': FieldValue.arrayUnion([fauth.currentUser!.uid])
          }, SetOptions(merge: true));
        }
      }
    } catch (e) {
      log('$e');
    }
  }

  void blockUnblockUser({
    UserModel? currentUser,
    String? appUser,
    context,
  }) async {
    try {
      var ref =
          FirebaseFirestore.instance.collection('users').doc(currentUser!.id);
      if (currentUser.blockIds.contains(appUser)) {
        await ref.update({
          'blockIds': FieldValue.arrayRemove([appUser])
        });
        Get.bottomSheet(
          Container(
            height: 200.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(icBottomSheetScroller),
                heightBox(15.h),
                SvgPicture.asset(icReportPostDone),
                heightBox(15.h),
                TextWidget(
                  text: appText(context).alertUserBlock,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: const Color(0xff212121),
                ),
                heightBox(12.h),
              ],
            ),
          ),
        );
      } else {
        await ref.update({
          'blockIds': FieldValue.arrayUnion([appUser])
        });
        Get.bottomSheet(
          Container(
            height: 200.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(icBottomSheetScroller),
                heightBox(15.h),
                SvgPicture.asset(icReportPostDone),
                heightBox(15.h),
                TextWidget(
                  text: appText(context).alertUserUnBlock,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: const Color(0xff212121),
                ),
                heightBox(12.h),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      log('$e');
    }
  }

  void postComment(
    context, {
    PostModel? postModel,
    UserModel? user,
    // String? comment,
    String? groupId,
    // List<String>? tagsId,
    List<UserModel>? allUsers,
  }) {
    if (repCommentId == null) {
      try {
        var postRef = groupId == null
            ? FirebaseFirestore.instance.collection("posts").doc(postModel!.id)
            : FirebaseFirestore.instance
                .collection('groups')
                .doc(groupId)
                .collection("posts")
                .doc(postModel!.id);
        var cmntRef = postRef.collection("comments").doc();
        cmntRef.set({});
        var cmntId = cmntRef.id;

        var cmnt = Comment(
          id: cmntId,
          creatorId: FirebaseAuth.instance.currentUser!.uid,
          creatorDetails: CreatorDetails(
              name: user!.name,
              imageUrl: user.imageStr,
              isVerified: user.isVerified),
          createdAt: DateTime.now().toUtc().toString(),
          message: mentionKey.currentState!.controller!.text,
          postId: postModel.id,
          dislikeIds: [],
          likeIds: [],
          replyIds: [],
          tagIds: commentTagsId,
        );

        postRef
            .collection("comments")
            .doc(cmntId)
            .set(cmnt.toMap(), SetOptions(merge: true))
            .then((value) async {
          postRef.set({
            "commentIds": FieldValue.arrayUnion([cmntId])
          }, SetOptions(merge: true));

          // if (commentTagsId.isEmpty) {
          var recieverRef = await FirebaseFirestore.instance
              .collection("users")
              .doc(postModel.creatorId)
              .get();

          var recieverFCMToken = recieverRef.data()!['fcmToken'];
          FirebaseMessagingService().sendNotificationToUser(
              appUserId: recieverRef.id,
              notificationType: 'feed_post_cmnt',
              content: postModel.toMap(),
              groupId: groupId,
              isMessage: false,
              devRegToken: recieverFCMToken,
              msg: appText(context).strNotificationComment(groupId == null
                  ? appText(context).pushnotPost
                  : appText(context).pushnotGroupPost)
              // "has commented on your ${groupId == null ? "post" : "group post"}.",
              );
          // } else {
          if (commentTagsId.isNotEmpty) {
            FirebaseMessagingService().sendNotificationToMutipleUsers(
              isMessage: false,
              notificationType: 'feed_post_cmnt',
              users: allUsers!
                  .where((element) => commentTagsId.contains(element.id))
                  .toList(),
              msg: appText(context).strNotificationMentioned(groupId == null
                  ? appText(context).pushnotPost
                  : appText(context).pushnotGroupPost),

              // "has mentioned you in ${groupId == null ? "post" : "group post"}.",
              groupId: groupId,
              content: postModel.toMap(),
            );
          }
          // }
          commentTagsId.clear();
        });
      } catch (e) {
        printLog(e.toString());
      } finally {
        postCommentFocus.unfocus();
        mentionKey.currentState!.controller!.clear();
      }
    }
  }

  void postCommentReply(
    context, {
    PostModel? postModel,
    String? recieverId,
    UserModel? user,
    List<UserModel>? allUsers,
    String? groupId,
    // String? reply,
    // List<String>? tagsId,
  }) {
    if (repCommentId != null) {
      try {
        var cmntRef = groupId == null
            ? FirebaseFirestore.instance
                .collection("posts")
                .doc(postModel!.id)
                .collection("comments")
                .doc(repCommentId)
            : FirebaseFirestore.instance
                .collection('groups')
                .doc(groupId)
                .collection("posts")
                .doc(postModel!.id)
                .collection("comments")
                .doc(repCommentId);
        var repRef = cmntRef.collection("reply").doc();
        repRef.set({});
        var repId = repRef.id;

        var rep = Comment(
          id: repId,
          creatorId: FirebaseAuth.instance.currentUser!.uid,
          creatorDetails: CreatorDetails(
              name: user!.name,
              imageUrl: user.imageStr,
              isVerified: user.isVerified),
          createdAt: DateTime.now().toUtc().toString(),
          message: mentionKey.currentState!.controller!.text,
          postId: postModel.id,
          dislikeIds: [],
          likeIds: [],
          replyIds: [],
          tagIds: commentTagsId,
        );

        cmntRef
            .collection("reply")
            .doc(repId)
            .set(rep.toMap(), SetOptions(merge: true))
            .then((value) async {
          cmntRef.set({
            "replyIds": FieldValue.arrayUnion([repId])
          }, SetOptions(merge: true));

          // if (commentTagsId.isEmpty) {
          var recieverRef = await FirebaseFirestore.instance
              .collection("users")
              .doc(user.id)
              .get();

          var recieverFCMToken = recieverRef.data()!['fcmToken'];
          FirebaseMessagingService().sendNotificationToUser(
              appUserId: recieverRef.id,
              notificationType: 'feed_post_cmnt',
              content: postModel.toMap(),
              groupId: groupId,
              isMessage: false,
              devRegToken: recieverFCMToken,
              msg: appText(context).strNotificationReplyComment(groupId == null
                  ? appText(context).pushnotPost
                  : appText(context).pushnotGroupPost)

              // "has reply on your comment on ${groupId == null ? "post" : "group post"}.",
              );
          // } else {
          if (commentTagsId.isNotEmpty) {
            FirebaseMessagingService().sendNotificationToMutipleUsers(
              isMessage: false,
              notificationType: 'feed_post_cmnt',
              users: allUsers!
                  .where((element) => commentTagsId.contains(element.id))
                  .toList(),
              msg: appText(context).strNotificationMentioned(groupId == null
                  ? appText(context).pushnotPost
                  : appText(context).pushnotGroupPost),
              groupId: groupId,
              content: postModel.toMap(),
            );
          }
          // }
          commentTagsId.clear();
        });
      } catch (e) {
        printLog(e.toString());
      } finally {
        postCommentFocus.unfocus();
        mentionKey.currentState!.controller!.clear();
        repCommentId = null;
      }
    }
  }

  void toggleLikeComment({
    String? groupId,
    String? postId,
    String? cmntId,
  }) async {
    try {
      var cmnt = groupId == null
          ? FirebaseFirestore.instance
              .collection("posts")
              .doc(postId)
              .collection("comments")
              .doc(cmntId)
          : FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection("posts")
              .doc(postId)
              .collection("comments")
              .doc(cmntId);

      var cmntRef = await cmnt.get();

      if (cmntRef.data()!.containsKey('likeIds')) {
        if (cmntRef.data()!['likeIds'].contains(currentUserUID)) {
          await cmnt.set({
            'likeIds': FieldValue.arrayRemove([currentUserUID])
          }, SetOptions(merge: true));
        } else {
          await cmnt.set({
            'likeIds': FieldValue.arrayUnion([currentUserUID])
          }, SetOptions(merge: true));
          await cmnt.set({
            'dislikeIds': FieldValue.arrayRemove([currentUserUID])
          }, SetOptions(merge: true));
        }
      } else {
        await cmnt.set({
          'likeIds': FieldValue.arrayUnion([currentUserUID])
        }, SetOptions(merge: true));
        await cmnt.set({
          'dislikeIds': FieldValue.arrayRemove([currentUserUID])
        }, SetOptions(merge: true));
      }

      //   var recieverRef = await FirebaseFirestore.instance
      //       .collection("users")
      //       .doc(user.id)
      //       .get();

      //   var recieverFCMToken = recieverRef.data()!['fcmToken'];
      //   FirebaseMessagingService().sendNotificationToUser(
      //     appUserId: recieverRef.id,
      //     notificationType: 'feed_post_cmnt',
      //     content: postModel.toMap(),
      //     groupId: groupId,
      //     isMessage: false,
      //     devRegToken: recieverFCMToken,
      //     msg:
      //         "has reply on your comment on ${groupId == null ? "post" : "group post"}.",
      //   );
      // });
    } catch (e) {
      printLog(e.toString());
    } finally {
      postCommentFocus.unfocus();
      repCommentId = null;
    }
  }

  void toggleDislikeComment({
    String? groupId,
    String? postId,
    String? cmntId,
  }) async {
    try {
      var cmnt = groupId == null
          ? FirebaseFirestore.instance
              .collection("posts")
              .doc(postId)
              .collection("comments")
              .doc(cmntId)
          : FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection("posts")
              .doc(postId)
              .collection("comments")
              .doc(cmntId);

      var cmntRef = await cmnt.get();

      if (cmntRef.data()!.containsKey('dislikeIds')) {
        if (cmntRef.data()!['dislikeIds'].contains(currentUserUID)) {
          await cmnt.set({
            'dislikeIds': FieldValue.arrayRemove([currentUserUID])
          }, SetOptions(merge: true));
        } else {
          await cmnt.set({
            'dislikeIds': FieldValue.arrayUnion([currentUserUID])
          }, SetOptions(merge: true));
          await cmnt.set({
            'likeIds': FieldValue.arrayRemove([currentUserUID])
          }, SetOptions(merge: true));
        }
      } else {
        await cmnt.set({
          'dislikeIds': FieldValue.arrayUnion([currentUserUID])
        }, SetOptions(merge: true));
        await cmnt.set({
          'likeIds': FieldValue.arrayRemove([currentUserUID])
        }, SetOptions(merge: true));
      }

      //   var recieverRef = await FirebaseFirestore.instance
      //       .collection("users")
      //       .doc(user.id)
      //       .get();

      //   var recieverFCMToken = recieverRef.data()!['fcmToken'];
      //   FirebaseMessagingService().sendNotificationToUser(
      //     appUserId: recieverRef.id,
      //     notificationType: 'feed_post_cmnt',
      //     content: postModel.toMap(),
      //     groupId: groupId,
      //     isMessage: false,
      //     devRegToken: recieverFCMToken,
      //     msg:
      //         "has reply on your comment on ${groupId == null ? "post" : "group post"}.",
      //   );
      // });
    } catch (e) {
      printLog(e.toString());
    } finally {
      postCommentFocus.unfocus();
      repCommentId = null;
    }
  }

  void toggleLikeCommentReply({
    String? groupId,
    String? postId,
    String? cmntId,
    String? repId,
  }) async {
    try {
      var cmnt = groupId == null
          ? FirebaseFirestore.instance
              .collection("posts")
              .doc(postId)
              .collection("comments")
              .doc(cmntId)
              .collection('reply')
              .doc(repId)
          : FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection("posts")
              .doc(postId)
              .collection("comments")
              .doc(cmntId)
              .collection('reply')
              .doc(repId);

      var cmntRef = await cmnt.get();

      if (cmntRef.data()!.containsKey('likeIds')) {
        if (cmntRef.data()!['likeIds'].contains(currentUserUID)) {
          await cmnt.set({
            'likeIds': FieldValue.arrayRemove([currentUserUID])
          }, SetOptions(merge: true));
        } else {
          await cmnt.set({
            'likeIds': FieldValue.arrayUnion([currentUserUID])
          }, SetOptions(merge: true));
          await cmnt.set({
            'dislikeIds': FieldValue.arrayRemove([currentUserUID])
          }, SetOptions(merge: true));
        }
      } else {
        await cmnt.set({
          'likeIds': FieldValue.arrayUnion([currentUserUID])
        }, SetOptions(merge: true));
        await cmnt.set({
          'dislikeIds': FieldValue.arrayRemove([currentUserUID])
        }, SetOptions(merge: true));
      }

      //   var recieverRef = await FirebaseFirestore.instance
      //       .collection("users")
      //       .doc(user.id)
      //       .get();

      //   var recieverFCMToken = recieverRef.data()!['fcmToken'];
      //   FirebaseMessagingService().sendNotificationToUser(
      //     appUserId: recieverRef.id,
      //     notificationType: 'feed_post_cmnt',
      //     content: postModel.toMap(),
      //     groupId: groupId,
      //     isMessage: false,
      //     devRegToken: recieverFCMToken,
      //     msg:
      //         "has reply on your comment on ${groupId == null ? "post" : "group post"}.",
      //   );
      // });
    } catch (e) {
      printLog(e.toString());
    } finally {
      postCommentFocus.unfocus();
      repCommentId = null;
    }
  }

  void toggleDislikeCommentReply({
    String? groupId,
    String? postId,
    String? cmntId,
    String? repId,
  }) async {
    try {
      var cmnt = groupId == null
          ? FirebaseFirestore.instance
              .collection("posts")
              .doc(postId)
              .collection("comments")
              .doc(cmntId)
              .collection('reply')
              .doc(repId)
          : FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection("posts")
              .doc(postId)
              .collection("comments")
              .doc(cmntId)
              .collection('reply')
              .doc(repId);

      var cmntRef = await cmnt.get();

      if (cmntRef.data()!.containsKey('dislikeIds')) {
        if (cmntRef.data()!['dislikeIds'].contains(currentUserUID)) {
          await cmnt.set({
            'dislikeIds': FieldValue.arrayRemove([currentUserUID])
          }, SetOptions(merge: true));
        } else {
          await cmnt.set({
            'dislikeIds': FieldValue.arrayUnion([currentUserUID])
          }, SetOptions(merge: true));
          await cmnt.set({
            'likeIds': FieldValue.arrayRemove([currentUserUID])
          }, SetOptions(merge: true));
        }
      } else {
        await cmnt.set({
          'dislikeIds': FieldValue.arrayUnion([currentUserUID])
        }, SetOptions(merge: true));
        await cmnt.set({
          'likeIds': FieldValue.arrayRemove([currentUserUID])
        }, SetOptions(merge: true));
      }

      //   var recieverRef = await FirebaseFirestore.instance
      //       .collection("users")
      //       .doc(user.id)
      //       .get();

      //   var recieverFCMToken = recieverRef.data()!['fcmToken'];
      //   FirebaseMessagingService().sendNotificationToUser(
      //     appUserId: recieverRef.id,
      //     notificationType: 'feed_post_cmnt',
      //     content: postModel.toMap(),
      //     groupId: groupId,
      //     isMessage: false,
      //     devRegToken: recieverFCMToken,
      //     msg:
      //         "has reply on your comment on ${groupId == null ? "post" : "group post"}.",
      //   );
      // });
    } catch (e) {
      printLog(e.toString());
    } finally {
      postCommentFocus.unfocus();
      repCommentId = null;
    }
  }

  void deleteComment({String? postId, String? cmntId, String? groupId}) async {
    try {
      groupId == null
          ? await FirebaseFirestore.instance
              .collection("posts")
              .doc(postId)
              .collection("comments")
              .doc(cmntId)
              .delete()
          : await FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection("posts")
              .doc(postId)
              .collection("comments")
              .doc(cmntId)
              .delete();

      var postRef = groupId == null
          ? FirebaseFirestore.instance.collection("posts").doc(postId)
          : FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection("posts")
              .doc(postId);

      await postRef.update({
        "commentIds": FieldValue.arrayRemove([cmntId])
      });
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    } finally {
      Get.back();
    }
  }

  void deleteCommentReply(
      {String? postId, String? cmntId, String? groupId, String? repId}) async {
    try {
      groupId == null
          ? await FirebaseFirestore.instance
              .collection("posts")
              .doc(postId)
              .collection("comments")
              .doc(cmntId)
              .collection('reply')
              .doc(repId)
              .delete()
          : await FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection("posts")
              .doc(postId)
              .collection("comments")
              .doc(cmntId)
              .collection('reply')
              .doc(repId)
              .delete();

      var cmntRef = groupId == null
          ? FirebaseFirestore.instance
              .collection("posts")
              .doc(postId)
              .collection('comments')
              .doc(cmntId)
          : FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection("posts")
              .doc(postId)
              .collection('comments')
              .doc(cmntId);

      await cmntRef.update({
        "replyIds": FieldValue.arrayRemove([repId])
      });
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    } finally {
      Get.back();
    }
  }

  void updatePollData(
    context, {
    required String postId,
    required String option,
  }) async {
    try {
      final ref = firestore.collection('posts').doc(postId);
      final data = await ref.get();
      final media = MediaDetails.fromMap(data.data()!['mediaData'][0]);
      final pollOptions = media.pollOptions!;

      for (var i = 0; i < pollOptions.length; i++) {
        var pollOption = PollOptions.fromMap(pollOptions[i]);
        if (pollOption.option == option) {
          var newData = pollOption.copyWith(option, pollOption.votes + 1);
          pollOptions[i] = newData.toMap();
        }
      }
      final pollVotedUsers = media.pollVotedUsers!;
      var newPollVotedUser = pollVotedUsers;
      var pollVoter = PollVotedUsers(id: currentUserUID!, votedOption: option);
      newPollVotedUser.add(pollVoter.toMap());

      var newMedia = media
          .copyWith(
            pollOptions: pollOptions,
            pollVotedUsers: newPollVotedUser,
          )
          .toMap();
      firestore.collection('posts').doc(postId).update({
        "mediaData": [newMedia],
      });
    } catch (e) {
      GlobalSnackBar.show(message: appText(context).strUnkownError);
    }
  }

  var unreadMessages = 0;

  List<String> recieverIds = [];

  restoreReciverList() {
    recieverIds.clear();
  }

  void sharePostData(
      {UserModel? currentUser,
      UserModel? appUser,
      PostModel? postModel,
      String? groupId,
      required String notimsg}) async {
    final messageRef = FirebaseFirestore.instance
        .collection("messages")
        .doc(getConversationDocId(currentUser!.id, appUser!.id));

    final chatRef = messageRef.collection('chats').doc();

    var p = postModel!.copyWith(groupId: groupId);

    var post = p.toMap();

    final MessageDetails messageDetails = MessageDetails(
      id: messageRef.id,
      creatorId: '',
      lastMessage: "Post",
      unreadMessageCount: 0,
      searchCharacters: [...appUser.name.toLowerCase().split('')],
      creatorDetails: CreatorDetails(
        name: appUser.name,
        imageUrl: appUser.imageStr,
        isVerified: appUser.isVerified,
      ),
      createdAt: DateTime.now().toUtc().toString(),
    );

    final Message message = Message(
      id: chatRef.id,
      sentToId: appUser.id,
      isReply: false,
      sentById: FirebaseAuth.instance.currentUser!.uid,
      content: post,
      caption: '',
      type: postModel.mediaData[0].type,
      createdAt: DateTime.now().toUtc().toString(),
      isSeen: false,
    );

    messageRef.set(messageDetails.toMap());
    chatRef.set(message.toMap());

    recieverIds.add(appUser.id);

    var postRef = groupId == null
        ? firestore.collection('posts').doc(postModel.id)
        : firestore
            .collection('groups')
            .doc(groupId)
            .collection('posts')
            .doc(postModel.id);

    await postRef.update({
      'shareCount': FieldValue.arrayUnion([currentUser.id])
    });

    // printLog(recieverIds.toString());
    notifyListeners();

    var recieverFCMToken = appUser.fcmToken;
    FirebaseMessagingService().sendNotificationToUser(
      appUserId: appUser.id,
      devRegToken: recieverFCMToken,
      notificationType: "msg",
      msg: notimsg,
      isMessage: false,
      content: postModel.mediaData[0].type == 'Photo'
          ? postModel.mediaData[0].link
          : "",
    );
  }
}
