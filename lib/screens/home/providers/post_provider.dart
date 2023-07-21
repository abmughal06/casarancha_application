import 'dart:developer';

import 'package:casarancha/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/comment_model.dart';
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

  void postComment({PostModel? postModel, UserModel? user, String? comment}) {
    var cmnt = Comment(
      id: postModel!.id,
      creatorId: FirebaseAuth.instance.currentUser!.uid,
      creatorDetails: CreatorDetails(
          name: user!.name,
          imageUrl: user.imageStr,
          isVerified: user.isVerified),
      createdAt: DateTime.now().toIso8601String(),
      message: comment!,
    );

    FirebaseFirestore.instance
        .collection("posts")
        .doc(postModel.id)
        .collection("comments")
        .doc()
        .set(cmnt.toMap(), SetOptions(merge: true))
        .then((value) async {
      var cmntId = await FirebaseFirestore.instance
          .collection("posts")
          .doc(postModel.id)
          .collection("comments")
          .get();

      List listOfCommentsId = [];
      for (var i in cmntId.docs) {
        listOfCommentsId.add(i.id);
      }

      FirebaseFirestore.instance
          .collection("posts")
          .doc(postModel.id)
          .set({"commentIds": listOfCommentsId}, SetOptions(merge: true));

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
}
