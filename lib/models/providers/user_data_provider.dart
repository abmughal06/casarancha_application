import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/notification_model.dart';
import 'package:casarancha/models/story_model.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/firebase_collection.dart';
import '../comment_model.dart';
import '../ghost_message_details.dart';
import '../message_details.dart';
import '../post_model.dart';
import '../user_model.dart';

class DataProvider extends ChangeNotifier {
  Stream<UserModel?>? get currentUser {
    try {
      notifyListeners();

      if (FirebaseAuth.instance.currentUser?.uid != null) {
        return FirebaseFirestore.instance
            .collection(cUsers)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots()
            .map((event) =>
                event.exists ? UserModel.fromMap(event.data()!) : null);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
      // return null;
    }
  }

  Stream<List<UserModel>?> get users {
    try {
      return FirebaseFirestore.instance
          .collection(cUsers)
          .snapshots()
          .map((event) => event.docs
              .where(
                (element) =>
                    element.data().isNotEmpty &&
                    element.data().containsKey('name') &&
                    element.data().containsKey('username') &&
                    element.data().containsKey('bio') &&
                    element.data().containsKey('dob'),
              )
              .map((e) => UserModel.fromMap(e.data()))
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<UserModel?>? getSingleUser(id) {
    try {
      return FirebaseFirestore.instance
          .collection(cUsers)
          .doc(id)
          .snapshots()
          .map((event) =>
              event.exists ? UserModel.fromMap(event.data()!) : null);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<PostModel>?> posts(String? groupId) {
    try {
      final ref = groupId == null
          ? FirebaseFirestore.instance.collection('posts')
          : FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection('posts');
      return ref.orderBy("createdAt", descending: true).snapshots().map(
          (event) => event.docs
              .where((element) =>
                  element.data().isNotEmpty &&
                  element.data()['mediaData'].isNotEmpty)
              .map((e) => PostModel.fromMap(e.data()))
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<PostModel>?> forums() {
    try {
      return FirebaseFirestore.instance
          .collection('posts')
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map((event) => event.docs
              .where((element) =>
                  element.data().isNotEmpty &&
                  element.data()['isForumPost'] == true &&
                  element.data()['mediaData'].isNotEmpty)
              .map((e) => PostModel.fromMap(e.data()))
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<PostModel?> singlePost({String? groupId, required String postId}) {
    try {
      final ref = groupId == null
          ? FirebaseFirestore.instance.collection('posts').doc(postId)
          : FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection('posts')
              .doc(postId);
      return ref.snapshots().map((event) => PostModel.fromMap(event.data()!));
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Story>?> get stories {
    try {
      return FirebaseFirestore.instance.collection(cStories).snapshots().map(
          (event) => event.docs
              .where((element) => element.data().isNotEmpty)
              .map((e) => Story.fromMap(e.data()))
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<NotificationModel>?>? get notifications {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        return null;
      }
      return FirebaseFirestore.instance
          .collection(cUsers)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(cNotificationList)
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map((event) => event.docs
              .where((element) =>
                  element.data().isNotEmpty &&
                  element.data()['sentById'] != null &&
                  element.data()['sentById'] !=
                      FirebaseAuth.instance.currentUser!.uid)
              .map((e) => NotificationModel.fromMap(e.data()))
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Comment>?> comment({cmntId, groupId}) {
    try {
      var ref = groupId == null
          ? FirebaseFirestore.instance
              .collection(cPosts)
              .doc(cmntId)
              .collection(cComments)
          : FirebaseFirestore.instance
              .collection(cGroups)
              .doc(groupId)
              .collection(cPosts)
              .doc(cmntId)
              .collection(cComments);
      return ref.orderBy("createdAt", descending: true).snapshots().map(
          (event) => event.docs
              .where((element) =>
                  element.data().isNotEmpty &&
                  element.data().containsKey('postId'))
              .map((e) => Comment.fromMap(e.data()))
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Comment>?> commentReply({postId, groupId, cmntId}) {
    try {
      var ref = groupId == null
          ? FirebaseFirestore.instance
              .collection(cPosts)
              .doc(postId)
              .collection(cComments)
              .doc(cmntId)
              .collection('reply')
          : FirebaseFirestore.instance
              .collection(cGroups)
              .doc(groupId)
              .collection(cPosts)
              .doc(postId)
              .collection(cComments)
              .doc(cmntId)
              .collection('reply');
      return ref.orderBy("createdAt", descending: false).snapshots().map(
          (event) => event.docs
              .where((element) =>
                  element.data().isNotEmpty &&
                  element.data().containsKey('postId'))
              .map((e) => Comment.fromMap(e.data()))
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<Comment?>? getSingleComment({postId, cmntId}) {
    try {
      return FirebaseFirestore.instance
          .collection(cPosts)
          .doc(postId)
          .collection(cComments)
          .doc(cmntId)
          .snapshots()
          .map((event) => Comment.fromMap(event.data()!));
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<MessageDetails>?>? get chatListUsers {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        return null;
      }
      return FirebaseFirestore.instance
          .collection(cUsers)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(cMessageList)
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map((event) => event.docs
              .where((element) => element.data().isNotEmpty)
              .map((e) => MessageDetails.fromMap(e.data()))
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<GhostMessageDetails>?>? get ghostChatListUsers {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        return null;
      }
      return FirebaseFirestore.instance
          .collection(cUsers)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(cGhostMessageList)
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map((event) => event.docs
              .where((element) =>
                  element.data().containsKey('firstMessage') &&
                  element.data().isNotEmpty)
              .map((e) => GhostMessageDetails.fromMap(e.data()))
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Message>?>? messages(userId, isGhost) {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        return null;
      }
      return FirebaseFirestore.instance
          .collection(cUsers)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(isGhost ? cGhostMessageList : cMessageList)
          .doc(userId)
          .collection(cMessage)
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map((event) => event.docs
              .where((element) =>
                  element.data().isNotEmpty &&
                  element.data()['content'].isNotEmpty)
              .map((e) => Message.fromMap(e.data()))
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<GroupModel>?>? get groups {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        return null;
      }
      return FirebaseFirestore.instance
          .collection(cGroups)
          .snapshots()
          .map((event) => event.docs
              .map(
                (e) => GroupModel.fromMap(e.data()),
              )
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<GroupModel>? singleGroup(groupId) {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        return null;
      }
      return FirebaseFirestore.instance
          .collection(cGroups)
          .doc(groupId)
          .snapshots()
          .map(
            (event) => GroupModel.fromMap(event.data()!),
          );
    } catch (e) {
      rethrow;
    }
  }

  // Stream<List<PostModel>?>? groupsPosts(groupId) {
  //   if (FirebaseAuth.instance.currentUser?.uid == null) {
  //     return null;
  //   }
  //   return FirebaseFirestore.instance
  //       .collection(cGroups)
  //       .doc(groupId)
  //       .collection(cPosts)
  //       .snapshots()
  //       .map((event) => event.docs
  //           .map(
  //             (e) => PostModel.fromMap(e.data()),
  //           )
  //           .toList());
  // }
}
