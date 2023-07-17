import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/notification_model.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../comment_model.dart';
import '../ghost_message_details.dart';
import '../message_details.dart';
import '../post_model.dart';
import '../user_model.dart';

class DataProvider extends ChangeNotifier {
  Stream<UserModel?>? get currentUser {
    notifyListeners();

    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .map((event) =>
              event.exists ? UserModel.fromMap(event.data()!) : null);
    } else {
      return null;
    }
  }

  Stream<List<UserModel>?> get users {
    return FirebaseFirestore.instance.collection("users").snapshots().map(
        (event) => event.docs
            .where((element) => element.data().isNotEmpty)
            .map((e) => UserModel.fromMap(e.data()))
            .toList());
  }

  Stream<List<PostModel>?> get posts {
    return FirebaseFirestore.instance
        .collection("posts")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((event) => event.docs
            .where((element) =>
                element.data().isNotEmpty &&
                element.data()['mediaData'].isNotEmpty)
            .map((e) => PostModel.fromMap(e.data()))
            .toList());
  }

  Stream<List<Story>?> get stories {
    return FirebaseFirestore.instance.collection("stories").snapshots().map(
        (event) => event.docs
            .where((element) => element.data().isNotEmpty)
            .map((e) => Story.fromMap(e.data()))
            .toList());
  }

  Stream<List<NotificationModel>?>? get notifications {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return null;
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notificationlist")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((event) => event.docs
            .where((element) => element.data().isNotEmpty)
            .map((e) => NotificationModel.fromMap(e.data()))
            .toList());
  }

  Stream<List<Comment>>? comment(id) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(id)
        .collection("comments")
        .snapshots()
        .map((event) => event.docs
            .where((element) => element.data().isNotEmpty)
            .map((e) => Comment.fromMap(e.data()))
            .toList());
  }

  Stream<List<MessageDetails>?>? get chatListUsers {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return null;
    }
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messageList")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((event) => event.docs
            .where((element) => element.data().isNotEmpty)
            .map((e) => MessageDetails.fromMap(e.data()))
            .toList());
  }

  Stream<List<GhostMessageDetails>?>? get ghostChatListUsers {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return null;
    }
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("ghostMessageList")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((event) => event.docs
            .where((element) => element.data().isNotEmpty)
            .map((e) => GhostMessageDetails.fromMap(e.data()))
            .toList());
  }

  Stream<List<Message>?>? messages(userId) {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return null;
    }
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messageList")
        .doc(userId)
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((event) => event.docs
            .where((element) =>
                element.data().isNotEmpty &&
                element.data()['content'].isNotEmpty)
            .map((e) => Message.fromMap(e.data()))
            .toList());
  }
}
