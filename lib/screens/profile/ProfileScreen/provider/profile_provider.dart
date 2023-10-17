import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  final postRef = FirebaseFirestore.instance.collection("posts");

  void deletePost(postId) async {
    await postRef
        .doc(postId)
        .delete()
        .then((value) => Get.back())
        .whenComplete(() => Get.back());
  }

  void toggleFollowBtn({UserModel? userModel, String? appUserId}) async {
    final currentUserRef = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    log(userModel!.id);
    try {
      if (userModel.followingsIds.contains(appUserId)) {
        await currentUserRef.update({
          "followingsIds": FieldValue.arrayRemove([appUserId])
        });
        log('Follow hogya');
      } else {
        await currentUserRef.update({
          "followingsIds": FieldValue.arrayUnion([appUserId])
        });
        log('Follow nai hwa');
        var ref = await currentUserRef.get();
        log(ref.id);
      }
    } catch (e) {
      log('$e');
    }
  }
}
