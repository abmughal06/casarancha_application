import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  final postRef = FirebaseFirestore.instance.collection("posts");
  final currentUserRef = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);

  void deletePost(postId) async {
    await postRef
        .doc(postId)
        .delete()
        .then((value) => Get.back())
        .whenComplete(() => Get.back());
  }

  void toggleFollowBtn({UserModel? userModel, String? appUserId}) async {
    log('in metthod');
    try {
      if (userModel!.followingsIds.contains(appUserId)) {
        await currentUserRef.update({
          "followingsIds": FieldValue.arrayRemove([appUserId])
        });
        log(userModel.name);
      } else {
        await currentUserRef.update({
          "followingsIds": FieldValue.arrayUnion([appUserId])
        });
      }
    } catch (e) {
      log('$e');
    }
  }
}
