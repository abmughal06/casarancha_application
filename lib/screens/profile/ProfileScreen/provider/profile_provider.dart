import 'dart:developer';
import 'package:casarancha/screens/auth/login_screen.dart';
import 'package:casarancha/screens/auth/providers/auth_provider.dart';
import 'package:casarancha/utils/app_utils.dart';
import 'package:casarancha/widgets/menu_user_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/user_model.dart';
import '../../../../resources/firebase_cloud_messaging.dart';

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

    final appUserRef =
        FirebaseFirestore.instance.collection("users").doc(appUserId);
    try {
      if (userModel!.followingsIds.contains(appUserId)) {
        await currentUserRef.update({
          "followingsIds": FieldValue.arrayRemove([appUserId])
        });
        await appUserRef.update({
          'followersIds':
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        });
      } else {
        await currentUserRef.update({
          "followingsIds": FieldValue.arrayUnion([appUserId])
        });
        await appUserRef.update({
          'followersIds':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        });
        final appUserDevToken = await appUserRef.get();
        FirebaseMessagingService().sendNotificationToUser(
            isMessage: false,
            appUserId: appUserId!,
            groupId: null,
            content: null,
            notificationType: "user_follow",
            devRegToken: appUserDevToken.data()!['fcmToken'],
            msg: "follow you");
      }
    } catch (e) {
      log('$e');
    }
  }

  Future<void> deleteUserAccount() async {
    try {
      Get.back();
      var currentUserId = FirebaseAuth.instance.currentUser!.uid;
      AuthenticationProvider(FirebaseAuth.instance)
          .signOut()
          .then((value) => Get.offAll(() => const LoginScreen()));
      await firestore.collection('users').doc(currentUserId).delete();
    } on FirebaseAuthException catch (e) {
      printLog(e.toString());
    } catch (e) {
      printLog(e.toString());
      // Handle general exception
    }
  }
}
