// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/message_details.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../resources/firebase_cloud_messaging.dart';

class ChatProvider extends ChangeNotifier {
  // String? appUserId;
  // CreatorDetails? creatorDetails;

//variables

  late TextEditingController messageController;
  ChatProvider() {
    messageController = TextEditingController();
  }

//Observablaes
  var isChatExits = false;
  var isChecking = false;

  int unreadMessages = 0;

//Getters

  // String get currentUserId {
  //   return profileScreenController.user.value.id;
  // }

  // DocumentReference<Map<String, dynamic>> get appUserRef {
  //   return FirebaseFirestore.instance.collection('users').doc(appUserId);
  // }

  // DocumentReference<Map<String, dynamic>> get currentUserRef {
  //   return FirebaseFirestore.instance.collection('users').doc(currentUserId);
  // }

// //Methods
//   Future<void> checkChatExistenceStatus() async {
//     isChecking.value = true;

//     try {
//       final result = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(profileScreenController.user.value.id)
//           .collection('messageList')
//           .doc(appUserId)
//           .get();
//       if (result.exists) {
//         isChatExits.value = true;
//       } else {
//         isChatExits.value = false;
//       }
//     } catch (e) {
//       GlobalSnackBar.show(message: e.toString());
//     }

//     isChecking.value = false;
//   }

  final userRef = FirebaseFirestore.instance.collection("users");

  Future<void> sentMessage({UserModel? currentUser, UserModel? appUser}) async {
    if (messageController.text.isEmpty) {
      return;
    }
    try {
      final messageRefForCurrentUser = userRef
          .doc(currentUser!.id)
          .collection('messageList')
          .doc(appUser!.id)
          .collection('messages')
          .doc();

      final messageRefForAppUser = userRef
          .doc(appUser.id)
          .collection('messageList')
          .doc(currentUser.id)
          .collection('messages')
          .doc(
            messageRefForCurrentUser.id,
          );

      final MessageDetails appUserMessageDetails = MessageDetails(
        id: appUser.id,
        lastMessage: messageController.text,
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
        id: currentUser.id,
        lastMessage: messageController.text,
        unreadMessageCount: unreadMessages + 1,
        searchCharacters: [...currentUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: currentUser.name,
          imageUrl: currentUser.imageStr,
          isVerified: currentUser.isVerified,
        ),
        createdAt: DateTime.now().toIso8601String(),
      );

      // if (!isChatExits.value) {
      await userRef
          .doc(currentUser.id)
          .collection('messageList')
          .doc(appUser.id)
          .set(
            appUserMessageDetails.toMap(),
          );

      await userRef
          .doc(appUser.id)
          .collection('messageList')
          .doc(currentUser.id)
          .set(
            currentUserMessageDetails.toMap(),
          );

      // }

      final Message message = Message(
        id: messageRefForCurrentUser.id,
        sentToId: appUser.id,
        sentById: currentUser.id,
        content: messageController.text,
        caption: '',
        type: 'Text',
        createdAt: DateTime.now().toIso8601String(),
        isSeen: false,
      );

      final appUserMessage = message.copyWith(id: messageRefForAppUser.id);

      messageRefForCurrentUser.set(message.toMap());
      messageRefForAppUser.set(appUserMessage.toMap());

      // if (isChatExits.value) {
      userRef
          .doc(appUser.id)
          .collection('messageList')
          .doc(currentUser.id)
          .update(
            currentUserMessageDetails.toMap(),
          );
      unreadMessages += 1;
      // }
      var recieverRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(appUser.id)
          .get();
      var recieverFCMToken = recieverRef.data()!['fcmToken'];
      print("=========> reciever fcm token = $recieverFCMToken");
      FirebaseMessagingService().sendNotificationToUser(
        appUserId: recieverRef.id,
        devRegToken: recieverFCMToken,
        msg: "has sent you a $unreadMessages message",
      );

      messageController.clear();
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    }
  }

  // Future<void> sentMessageGhost() async {
  //   if (messageController.text.isEmpty) {
  //     return;
  //   }
  //   try {
  //     final messageRefForCurrentUser = currentUserRef
  //         .collection("ghostMessageList")
  //         .doc(appUserId)
  //         .collection('messages')
  //         .doc();

  //     final messageRefForAppUser = appUserRef
  //         .collection("ghostMessageList")
  //         .doc(currentUserId)
  //         .collection('messages')
  //         .doc(
  //           messageRefForCurrentUser.id,
  //         );

  //     final MessageDetails appUserMessageDetails = MessageDetails(
  //       id: appUserId,
  //       lastMessage: messageController.text,
  //       unreadMessageCount: 0,
  //       searchCharacters: [...creatorDetails.name.toLowerCase().split('')],
  //       creatorDetails: CreatorDetails(
  //         name: creatorDetails.name,
  //         imageUrl: creatorDetails.imageUrl,
  //         isVerified: creatorDetails.isVerified,
  //       ),
  //       createdAt: DateTime.now().toIso8601String(),
  //     );

  //     final MessageDetails currentUserMessageDetails = MessageDetails(
  //       id: currentUserId,
  //       lastMessage: messageController.text,
  //       unreadMessageCount: unreadMessages + 1,
  //       searchCharacters: [
  //         ...profileScreenController.user.value.name.toLowerCase().split('')
  //       ],
  //       creatorDetails: CreatorDetails(
  //         name: 'Ghost_${Random().nextInt(10000).toString()}',
  //         imageUrl: '',
  //         isVerified: false,
  //       ),
  //       createdAt: DateTime.now().toIso8601String(),
  //     );

  //     // if (!isChatExits.value) {
  //     await currentUserRef.collection("ghostMessageList").doc(appUserId).set(
  //           appUserMessageDetails.toMap(),
  //         );

  //     await appUserRef.collection("ghostMessageList").doc(currentUserId).set(
  //           currentUserMessageDetails.toMap(),
  //         );

  //     isChatExits.value = true;
  //     // }

  //     final Message message = Message(
  //       id: messageRefForCurrentUser.id,
  //       sentToId: appUserId,
  //       sentById: currentUserId,
  //       content: messageController.text,
  //       caption: '',
  //       type: 'Text',
  //       createdAt: DateTime.now().toIso8601String(),
  //       isSeen: false,
  //     );

  //     final appUserMessage = message.copyWith(id: messageRefForAppUser.id);

  //     messageRefForCurrentUser.set(message.toMap());
  //     messageRefForAppUser.set(appUserMessage.toMap());

  //     // if (isChatExits.value) {
  //     appUserRef.collection("ghostMessageList").doc(currentUserId).update(
  //           currentUserMessageDetails.toMap(),
  //         );
  //     unreadMessages += 1;
  //     // }
  //     var recieverRef = await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(appUserId)
  //         .get();
  //     var recieverFCMToken = recieverRef.data()!['fcmToken'];
  //     print("=========> reciever fcm token = $recieverFCMToken");
  //     FirebaseMessagingService().sendNotificationToUser(
  //       appUserId: recieverRef.id,
  //       devRegToken: recieverFCMToken,
  //       msg: "has sent you a $unreadMessages message in ghost",
  //     );

  //     messageController.clear();
  //   } catch (e) {
  //     GlobalSnackBar(message: e.toString());
  //   }
  // }

  Future<void> resetMessageCount({currentUserId, appUserId}) async {
    await userRef
        .doc(currentUserId)
        .collection('messageList')
        .doc(appUserId)
        .update({
      'unreadMessageCount': 0,
    });
  }

  Future<void> resetMessageCountGhost({currentUserId, appUserId}) async {
    userRef
        .doc(currentUserId)
        .collection("ghostMessageList")
        .doc(appUserId)
        .update({
      'unreadMessageCount': 0,
    });
  }

  // @override
  // void onInit() {
  //   messageController = TextEditingController();
  //   checkChatExistenceStatus();

  //   super.onInit();
  // }

  // @override
  // void dispose() {
  //   messageController.dispose();
  //   super.dispose();
  // }

  void clearMessageController() {
    messageController.clear();
  }
}
