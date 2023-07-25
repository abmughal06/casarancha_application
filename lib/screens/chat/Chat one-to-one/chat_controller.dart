import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/message_details.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/ghost_message_details.dart';
import '../../../models/user_model.dart';
import '../../../resources/firebase_cloud_messaging.dart';

class ChatProvider extends ChangeNotifier {
//variables

  late TextEditingController messageController;
  ChatProvider() {
    messageController = TextEditingController();
  }

//Observablaes
  var isChatExits = false;
  var isChecking = false;

  int unreadMessages = 0;

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

      // userRef
      //     .doc(appUser.id)
      //     .collection('messageList')
      //     .doc(currentUser.id)
      //     .update(
      //       currentUserMessageDetails.toMap(),
      //     );
      unreadMessages += 1;
      var recieverRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(appUser.id)
          .get();
      var recieverFCMToken = recieverRef.data()!['fcmToken'];
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

  Future<void> sentMessageGhost(
      {UserModel? currentUser,
      UserModel? appUser,
      bool? firstMessageByMe}) async {
    if (messageController.text.isEmpty) {
      return;
    }
    try {
      final messageRefForCurrentUser = userRef
          .doc(currentUser!.id)
          .collection('ghostMessageList')
          .doc(appUser!.id)
          .collection('messages')
          .doc();

      final messageRefForAppUser = userRef
          .doc(appUser.id)
          .collection('ghostMessageList')
          .doc(currentUser.id)
          .collection('messages')
          .doc(
            messageRefForCurrentUser.id,
          );

      final GhostMessageDetails appUserMessageDetails = GhostMessageDetails(
        id: appUser.id,
        lastMessage: messageController.text,
        firstMessage: firstMessageByMe! ? currentUser.id : appUser.id,
        unreadMessageCount: 0,
        searchCharacters: [...appUser.name.toLowerCase().split('')],
        creatorDetails: CreatorDetails(
          name: appUser.name,
          imageUrl: appUser.imageStr,
          isVerified: appUser.isVerified,
        ),
        createdAt: DateTime.now().toIso8601String(),
      );

      final GhostMessageDetails currentUserMessageDetails = GhostMessageDetails(
        id: currentUser.id,
        lastMessage: messageController.text,
        firstMessage: firstMessageByMe ? currentUser.id : appUser.id,
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
          .collection('ghostMessageList')
          .doc(appUser.id)
          .set(
            appUserMessageDetails.toMap(),
          );

      await userRef
          .doc(appUser.id)
          .collection('ghostMessageList')
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
          .collection('ghostMessageList')
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
      FirebaseMessagingService().sendNotificationToUser(
        appUserId: recieverRef.id,
        devRegToken: recieverFCMToken,
        msg: "has sent you a $unreadMessages message in ghost",
      );

      messageController.clear();
    } catch (e) {
      GlobalSnackBar(message: e.toString());
    }
  }

  Future<void> resetMessageCount({currentUserId, appUserId, messageid}) async {
    await userRef
        .doc(currentUserId)
        .collection('messageList')
        .doc(appUserId)
        .update({
      'unreadMessageCount': 0,
    });
    await userRef
        .doc(appUserId)
        .collection('messageList')
        .doc(currentUserId)
        .collection("messages")
        .doc(messageid)
        .update({
      'isSeen': true,
    });
  }

  Future<void> resetMessageCountGhost(
      {currentUserId, appUserId, messageid}) async {
    userRef
        .doc(currentUserId)
        .collection("ghostMessageList")
        .doc(appUserId)
        .update({
      'unreadMessageCount': 0,
    });
    await userRef
        .doc(appUserId)
        .collection('ghostMessageList')
        .doc(currentUserId)
        .collection("messages")
        .doc(messageid)
        .update({
      'isSeen': true,
    });
  }

  void clearMessageController() {
    messageController.clear();
    unreadMessages = 0;
  }
}
