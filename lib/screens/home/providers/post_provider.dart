import 'dart:developer';

import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  void toggleLikeDislike({PostModel? postModel, String? groupId}) async {
    final postRef = groupId != null
        ? FirebaseFirestore.instance
            .collection("groups")
            .doc(groupId)
            .collection('posts')
        : FirebaseFirestore.instance.collection("posts");

    log(postModel!.id.toString());
    try {
      log('1');
      var uid = fauth.currentUser!.uid;
      log('2');

      if (postModel.likesIds.contains(uid)) {
        log('3');

        await postRef.doc(postModel.id).update({
          'likesIds': FieldValue.arrayRemove([uid])
        });
      } else {
        log('4');

        await postRef.doc(postModel.id).update({
          'likesIds': FieldValue.arrayUnion([uid])
        });
      }
      log('5');
    } catch (e) {
      log("$e");
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
    try {
      await postRef.doc(postModel!.id).delete().then((value) => Get.back());
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

  void deletePostComment({String? postId, String? groupId}) async {
    final postRef = groupId != null
        ? FirebaseFirestore.instance
            .collection("groups")
            .doc(groupId)
            .collection('posts')
        : FirebaseFirestore.instance.collection("posts");
    try {
      await postRef.doc(postId).collection("comments").get().then((value) {});
    } catch (e) {
      log('$e');
    }
  }

  void blockUnblockUser({
    UserModel? currentUser,
    String? appUser,
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
                  text: "The user is unblocked now",
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
                  text: "The user is blocked now",
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

  void postComment({
    PostModel? postModel,
    UserModel? user,
    String? comment,
    String? groupId,
  }) {
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
      createdAt: DateTime.now().toIso8601String(),
      message: comment!,
      postId: postModel.id,
    );

    postRef
        .collection("comments")
        .doc(cmntId)
        .set(cmnt.toMap(), SetOptions(merge: true))
        .then((value) async {
      postRef.set({
        "commentIds": FieldValue.arrayUnion([cmntId])
      }, SetOptions(merge: true));

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
        msg:
            "has commented on your ${groupId == null ? "post" : "group post"}.",
      );
    });
  }

  var unreadMessages = 0;

  List<String> recieverIds = [];

  restoreReciverList() {
    recieverIds.clear();
  }

  void sharePostData(
      {UserModel? currentUser,
      UserModel? appUser,
      PostModel? postModel}) async {
    final messageRefForCurrentUser = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messageList')
        .doc(appUser!.id)
        .collection('messages')
        .doc();

    final messageRefForAppUser = FirebaseFirestore.instance
        .collection("users")
        .doc(appUser.id)
        .collection('messageList')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .doc(messageRefForCurrentUser.id);

    var post = postModel!.toMap();

    final MessageDetails appUserMessageDetails = MessageDetails(
      id: appUser.id,
      lastMessage: "Post",
      unreadMessageCount: 0,
      searchCharacters: [...appUser.name.toLowerCase().split('')],
      creatorDetails: CreatorDetails(
        name: appUser.name,
        imageUrl: appUser.imageStr,
        isVerified: appUser.isVerified,
      ),
      createdAt: DateTime.now().toIso8601String(),
    );

    final MessageDetails currentUserMessageDetails = MessageDetails(
      id: currentUser!.id,
      lastMessage: "Post",
      unreadMessageCount: unreadMessages + 1,
      searchCharacters: [...currentUser.name.toLowerCase().split('')],
      creatorDetails: CreatorDetails(
        name: currentUser.name,
        imageUrl: currentUser.imageStr,
        isVerified: currentUser.isVerified,
      ),
      createdAt: DateTime.now().toIso8601String(),
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .collection('messageList')
        .doc(appUser.id)
        .set(
          appUserMessageDetails.toMap(),
        );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(appUser.id)
        .collection('messageList')
        .doc(currentUser.id)
        .set(
          currentUserMessageDetails.toMap(),
        );

    final Message message = Message(
      id: messageRefForCurrentUser.id,
      sentToId: appUser.id,
      sentById: FirebaseAuth.instance.currentUser!.uid,
      content: post,
      caption: '',
      type: postModel.mediaData[0].type,
      createdAt: DateTime.now().toIso8601String(),
      isSeen: false,
    );
    final appUserMessage = message.copyWith(id: messageRefForAppUser.id);

    messageRefForCurrentUser.set(message.toMap());
    messageRefForAppUser.set(appUserMessage.toMap());

    recieverIds.add(appUser.id);

    printLog(recieverIds.toString());
    notifyListeners();

    var recieverFCMToken = appUser.fcmToken;
    FirebaseMessagingService().sendNotificationToUser(
      appUserId: appUser.id,
      devRegToken: recieverFCMToken,
      notificationType: "msg",
      msg: "has sent you a post",
      isMessage: false,
      content: postModel.mediaData[0].type == 'Photo'
          ? postModel.mediaData[0].link
          : "",
    );
  }
}
