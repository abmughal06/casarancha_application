// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/message_details.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  String appUserId;
  CreatorDetails creatorDetails;
  ChatController({
    required this.appUserId,
    required this.creatorDetails,
  });
//variables
  ProfileScreenController profileScreenController =
      Get.find<ProfileScreenController>();

  late TextEditingController messageController;

//Observablaes
  var isChatExits = false.obs;
  var isChecking = false.obs;

  int unreadMessages = 0;

//Getters

  String get currentUserId {
    return profileScreenController.user.value.id;
  }

  DocumentReference<Map<String, dynamic>> get appUserRef {
    return FirebaseFirestore.instance.collection('users').doc(appUserId);
  }

  DocumentReference<Map<String, dynamic>> get currentUserRef {
    return FirebaseFirestore.instance.collection('users').doc(currentUserId);
  }

//Methods
  Future<void> checkChatExistenceStatus() async {
    isChecking.value = true;

    try {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .doc(profileScreenController.user.value.id)
          .collection('messageList')
          .doc(appUserId)
          .get();
      if (result.exists) {
        isChatExits.value = true;
      } else {
        isChatExits.value = false;
      }
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    }

    isChecking.value = false;
  }

  Future<void> sentMessage() async {
    if (messageController.text.isEmpty) {
      return;
    }
    try {
      final messageRefForCurrentUser = currentUserRef
          .collection('messageList')
          .doc(appUserId)
          .collection('messages')
          .doc();

      final messageRefForAppUser = appUserRef
          .collection('messageList')
          .doc(currentUserId)
          .collection('messages')
          .doc(
            messageRefForCurrentUser.id,
          );

      final MessageDetails appUserMessageDetails = MessageDetails(
        id: appUserId,
        lastMessage: messageController.text,
        unreadMessageCount: unreadMessages + 1,
        searchCharacters: [...creatorDetails.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: creatorDetails.name,
          imageUrl: creatorDetails.imageUrl,
          isVerified: creatorDetails.isVerified,
        ),
        createdAt: DateTime.now().toIso8601String(),
      );

      final MessageDetails currentUserMessageDetails = MessageDetails(
        id: currentUserId,
        lastMessage: messageController.text,
        unreadMessageCount: unreadMessages + 1,
        searchCharacters: [
          ...profileScreenController.user.value.name.toLowerCase().split('')
        ],
        creatorDetails: CreatorDetails(
          name: profileScreenController.isGhostModeOn.value
              ? 'Ghost_${Random().nextInt(10000).toString()}'
              : profileScreenController.user.value.name,
          imageUrl: profileScreenController.isGhostModeOn.value
              ? ''
              : profileScreenController.user.value.imageStr,
          isVerified: profileScreenController.isGhostModeOn.value
              ? false
              : profileScreenController.user.value.isVerified,
        ),
        createdAt: DateTime.now().toIso8601String(),
      );

      if (!isChatExits.value) {
        await currentUserRef.collection('messageList').doc(appUserId).set(
              appUserMessageDetails.toMap(),
            );

        await appUserRef.collection('messageList').doc(currentUserId).set(
              currentUserMessageDetails.toMap(),
            );

        isChatExits.value = true;
      }

      final Message message = Message(
        id: messageRefForCurrentUser.id,
        sentToId: appUserId,
        sentById: currentUserId,
        content: messageController.text,
        caption: '',
        type: 'Text',
        createdAt: DateTime.now().toIso8601String(),
        isSeen: false,
      );

      final appUserMessage = message.copyWith(id: messageRefForAppUser.id);

      messageRefForCurrentUser.set(message.toMap());
      messageRefForAppUser.set(appUserMessage.toMap());

      if (isChatExits.value) {
        appUserRef.collection('messageList').doc(currentUserId).update(
              currentUserMessageDetails.toMap(),
            );
        unreadMessages += 1;
      }

      messageController.clear();
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    }
  }

  Future<void> resetMessageCount() async {
    currentUserRef.collection('messageList').doc(appUserId).update({
      'unreadMessageCount': 0,
    });
  }

  @override
  void onInit() {
    messageController = TextEditingController();
    checkChatExistenceStatus();

    super.onInit();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
