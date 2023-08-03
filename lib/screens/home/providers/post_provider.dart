import 'dart:developer';

import 'package:casarancha/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/comment_model.dart';
import '../../../models/message.dart';
import '../../../models/message_details.dart';
import '../../../models/post_creator_details.dart';
import '../../../models/post_model.dart';
import '../../../resources/firebase_cloud_messaging.dart';

class PostProvider extends ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  final fauth = FirebaseAuth.instance;
  final currentUserRef = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final postRef = FirebaseFirestore.instance.collection("posts");

  void toggleLikeDislike({PostModel? postModel}) async {
    try {
      var uid = fauth.currentUser!.uid;
      if (postModel!.likesIds.contains(uid)) {
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
    }
  }

  void onTapSave({UserModel? userModel, String? postId}) async {
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

  void deletePost({PostModel? postModel}) async {
    try {
      await postRef.doc(postModel!.id).delete().then((value) => Get.back());
    } catch (e) {
      log("$e");
    }
  }

  void countVideoViews({PostModel? postModel}) async {
    try {
      if (!postModel!.videoViews.contains(fauth.currentUser!.uid)) {
        await postRef.doc(postModel.id).set({
          'videoViews': FieldValue.arrayUnion([fauth.currentUser!.uid])
        }, SetOptions(merge: true));
      }
    } catch (e) {
      log('$e');
    }
  }

  void deletePostComment({String? postId}) async {
    try {
      // if (!postModel!.videoViews.contains(fauth.currentUser!.uid)) {
      //   await postRef.doc(postModel.id).set({
      //     'videoViews': FieldValue.arrayUnion([fauth.currentUser!.uid])
      //   }, SetOptions(merge: true));
      // }
      await postRef.doc(postId).collection("comments").get().then((value) {});
    } catch (e) {
      log('$e');
    }
  }

  void postComment({PostModel? postModel, UserModel? user, String? comment}) {
    var cmntRef = FirebaseFirestore.instance
        .collection("posts")
        .doc(postModel!.id)
        .collection("comments")
        .doc();
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

    FirebaseFirestore.instance
        .collection("posts")
        .doc(postModel.id)
        .collection("comments")
        .doc(cmntId)
        .set(cmnt.toMap(), SetOptions(merge: true))
        .then((value) async {
      FirebaseFirestore.instance.collection("posts").doc(postModel.id).set({
        "commentIds": FieldValue.arrayUnion([cmntId])
      }, SetOptions(merge: true));

      // FirebaseFirestore.instance
      //     .collection("posts")
      //     .doc(postModel.id)
      //     .collection('comments')
      //     .doc(cmntId)
      //     .set({"commentIds": listOfCommentsId}, SetOptions(merge: true));

      var recieverRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(postModel.creatorId)
          .get();

      var recieverFCMToken = recieverRef.data()!['fcmToken'];
      FirebaseMessagingService().sendNotificationToUser(
        appUserId: recieverRef.id,
        imageUrl: postModel.mediaData[0].type == 'Photo'
            ? postModel.mediaData[0].link
            : '',
        devRegToken: recieverFCMToken,
        msg: "has commented on your post.",
      );
    });
  }

  var isSent = false;
  var unreadMessages = 0;

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
    isSent = true;
    notifyListeners();

    var recieverFCMToken = appUser.fcmToken;
    FirebaseMessagingService().sendNotificationToUser(
      appUserId: appUser.id,
      devRegToken: recieverFCMToken,
      msg: "has sent you a post",
      imageUrl: postModel.mediaData[0].type != 'Video'
          ? postModel.mediaData[0].link
          : "",
    );
  }

  void disposeSendButton() {
    isSent = false;
  }
}
