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

Future<UserModel> getUserById(id) async {
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(id)
      .get()
      .then((value) => UserModel.fromMap(value.data()!));
}

class ProfileProvider extends ChangeNotifier {
  final postRef = FirebaseFirestore.instance.collection("posts");

  void deletePost(postId) async {
    await postRef
        .doc(postId)
        .delete()
        .then((value) => Get.back())
        .whenComplete(() => Get.back());
  }

  void toggleFollowBtn({required String appUserId}) async {
    final currentUserRef = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    final appUserRef =
        FirebaseFirestore.instance.collection("users").doc(appUserId);

    final currentUser =
        await getUserById(FirebaseAuth.instance.currentUser!.uid);
    final appUser = await getUserById(appUserId);

    try {
      if (currentUser.followingsIds.contains(appUserId)) {
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
        FirebaseMessagingService().sendNotificationToUser(
          isMessage: false,
          appUserId: appUserId,
          groupId: null,
          content: null,
          notificationType: "user_follow",
          devRegToken: appUser.fcmToken,
          msg: 'follows you',
        );
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
          .signOut(currentUserId)
          .then((value) => Get.offAll(() => const LoginScreen()));
      await firestore.collection('users').doc(currentUserId).delete();
    } on FirebaseAuthException catch (e) {
      printLog(e.toString());
    } catch (e) {
      printLog(e.toString());
    }
  }

  toggleUserOnlineStatus(bool value) async {
    if (FirebaseAuth.instance.currentUser != null) {
      final currentUserRef = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid);

      currentUserRef.update({
        "isOnline": value,
      });
    }
  }
}
