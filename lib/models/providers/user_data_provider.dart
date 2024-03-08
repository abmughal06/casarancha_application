import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/message.dart';
import 'package:casarancha/models/notification_model.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../utils/firebase_collection.dart';
import '../comment_model.dart';
import '../ghost_message_details.dart';
import '../message_details.dart';
import '../post_model.dart';
import '../story_model.dart';
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

  Stream<List<UserModel>?>? users() {
    try {
      if (FirebaseAuth.instance.currentUser?.uid != null) {
        return FirebaseFirestore.instance
            .collection(cUsers)
            .snapshots()
            .map((event) => event.docs
                .where(
                  (element) =>
                      element.id != FirebaseAuth.instance.currentUser!.uid &&
                      element.data().isNotEmpty &&
                      element.data().containsKey('name') &&
                      element.data().containsKey('username') &&
                      element.data().containsKey('bio') &&
                      element.data().containsKey('dob'),
                )
                .map((e) => UserModel.fromMap(e.data()))
                .toList());
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<UserModel>?>? allUsers() {
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

  Stream<List<UserModel>?>? searchUser(String search) {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        if (search.isEmpty) {
          return FirebaseFirestore.instance
              .collection(cUsers)
              .snapshots()
              .map((event) => event.docs
                  .where(
                    (element) =>
                        element.id != FirebaseAuth.instance.currentUser!.uid &&
                        element.data().isNotEmpty &&
                        element.data().containsKey('name') &&
                        element.data().containsKey('username') &&
                        element.data().containsKey('bio') &&
                        element.data().containsKey('dob') &&
                        element.data()['isVerified'],
                  )
                  .map((e) => UserModel.fromMap(e.data()))
                  .toList());
        }
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
                          element.data().containsKey('dob') &&
                          element.id !=
                              FirebaseAuth.instance.currentUser!.uid &&
                          element
                              .data()['username']
                              .toString()
                              .toLowerCase()
                              .contains(search.toLowerCase()) ||
                      element.data()['name'].toString().toLowerCase().contains(
                            search.toLowerCase(),
                          ),
                )
                .map((e) => UserModel.fromMap(e.data()))
                .toList());
      }
      return null;
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

  Stream<List<PostModel>?> posts() {
    try {
      final ref = FirebaseFirestore.instance.collection('posts');
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

  Stream<List<PostModel>?> homeFeedPosts() {
    try {
      final ref = FirebaseFirestore.instance.collection('posts');
      return ref.orderBy("createdAt", descending: true).snapshots().map(
          (event) => event.docs
              .where((element) =>
                  element.data().isNotEmpty &&
                  element.data()['mediaData'].isNotEmpty)
              .map((e) => PostModel.fromMap(e.data()))
              .where((element) => !element.isForumPost && !element.isGhostPost)
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<PostModel>?> ghostModePosts(
      List followingsIds, List followersIds, String currentUserId) {
    try {
      final ref = FirebaseFirestore.instance.collection('posts');
      return ref.orderBy("createdAt", descending: true).snapshots().map(
          (event) => event.docs
              .where((element) =>
                  (followersIds.contains(element.data()['creatorId']) ||
                      followingsIds.contains(element.data()['creatorId']) ||
                      element.data()['creatorId'] == currentUserId) &&
                  element.data().isNotEmpty &&
                  element.data()['mediaData'].isNotEmpty)
              .map((e) => PostModel.fromMap(e.data()))
              .where((element) => !element.isForumPost && !element.isGhostPost)
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<PostModel>?> groupPosts(String? groupId) {
    try {
      final ref = FirebaseFirestore.instance
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

  Stream<List<PostModel>?> profilePostsAccordingToType(List<String> postsIds) {
    try {
      final ref = FirebaseFirestore.instance.collection('posts');
      return ref.orderBy("createdAt", descending: true).snapshots().map(
          (event) => event.docs
              .where((element) =>
                  element.data().isNotEmpty &&
                  element.data()['mediaData'].isNotEmpty &&
                  postsIds.contains(element.id))
              .map((e) => PostModel.fromMap(e.data()))
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<PostModel>?>? savedPostsScreen() {
    try {
      if (FirebaseAuth.instance.currentUser?.uid != null) {
        final ref = FirebaseFirestore.instance.collection('posts');
        return ref.orderBy("createdAt", descending: true).snapshots().map(
            (event) => event.docs
                .where((element) =>
                    element.data().isNotEmpty &&
                    element.data()['mediaData'].isNotEmpty &&
                    element.data()['creatorId'] ==
                        FirebaseAuth.instance.currentUser!.uid)
                .map((e) => PostModel.fromMap(e.data()))
                .toList());
      } else {
        return null;
      }
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

  Stream<List<PostModel>?> ghostPosts() {
    try {
      return FirebaseFirestore.instance
          .collection('posts')
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map((event) => event.docs
              .where((element) =>
                  element.data().isNotEmpty &&
                  element.data()['isGhostPost'] == true &&
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

  Future<PostModel?> singlePostFuture(
      {String? groupId, required String postId}) {
    try {
      final ref = groupId == null
          ? FirebaseFirestore.instance.collection('posts').doc(postId)
          : FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection('posts')
              .doc(postId);
      return ref.get().then((value) => PostModel.fromMap(value.data()!));
    } catch (e) {
      rethrow;
    }
  }

  Stream<Story?>? myStory() {
    try {
      if (FirebaseAuth.instance.currentUser?.uid != null) {
        return FirebaseFirestore.instance
            .collection(cStories)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots()
            .map((event) => Story.fromMap(
                  event.data()!,
                ));
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Story>?> allStories(List a) {
    final twentyFourHoursAgo =
        DateTime.now().toUtc().subtract(const Duration(hours: 24));
    DateTime givenDate = DateTime.now().toUtc();
    try {
      return FirebaseFirestore.instance.collection('stories').snapshots().map(
          (event) => event.docs
                  .where((element) =>
                      element.data().isNotEmpty && a.contains(element.id))
                  .map((e) => Story.fromMap(e.data()))
                  .where((element) {
                for (var i = 0; i < element.mediaDetailsList.length;) {
                  givenDate = DateTime.parse(element.mediaDetailsList[i].id);
                  if (givenDate.isAfter(twentyFourHoursAgo)) {
                    return true;
                  }
                  return false;
                }
                return false;
              }).toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<NotificationModel>?>? notifications() {
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

  static Stream<int>? notficationLength() {
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
              .where(
                (element) =>
                    element.data().isNotEmpty &&
                    // element.data()['sentById'] != null &&
                    // element.data()['sentById'] !=
                    //     FirebaseAuth.instance.currentUser!.uid &&
                    element.data()['isRead'] == false,
              )
              .map((e) => NotificationModel.fromMap(e.data()))
              .toList()
              .length);
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

  Stream<List<Comment>?> recentComment({cmntId, groupId}) {
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

  Stream<Comment?>? getSingleComment({postId, cmntId, groupId}) {
    try {
      final ref = groupId != null
          ? FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .collection(cPosts)
              .doc(postId)
          : FirebaseFirestore.instance.collection(cPosts).doc(postId);
      return ref
          .collection(cComments)
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map((event) => Comment.fromMap(event.docs.first.data()));
    } catch (e) {
      return null;
    }
  }

  Stream<List<MessageDetails>?>? getchatListUsers() {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        return null;
      }
      return FirebaseFirestore.instance
          .collection('messages')
          // .doc(FirebaseAuth.instance.currentUser!.uid)
          // .collection(cMessageList)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (event) => event.docs
                .where((element) => element
                    .data()['id']
                    .toString()
                    .contains(FirebaseAuth.instance.currentUser!.uid))
                .map((e) => MessageDetails.fromMap(e.data()))
                .toList(),
          );
    } catch (e) {
      return null;
    }
  }

  Stream<Message?>? lastChatUser(id) {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        return null;
      }
      return FirebaseFirestore.instance
          .collection(cUsers)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(cMessageList)
          .doc(id)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .snapshots()
          .map(
            (event) => event.docs.map((e) => Message.fromMap(e.data())).first,
          );
    } catch (e) {
      return null;
    }
  }

  Stream<int>? unSeenMessagesLength(id) {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        return null;
      }
      return FirebaseFirestore.instance
          .collection('messages')
          .doc(id)
          .collection('chats')
          .snapshots()
          .map(
            (event) => event.docs
                .where((element) =>
                    element.data()['content'].isNotEmpty &&
                    element.data()['sentById'] !=
                        FirebaseAuth.instance.currentUser!.uid &&
                    !element.data()['isSeen'])
                .map((e) => e.data())
                .length,
          );
    } catch (e) {
      return null;
    }
  }

  Stream<int>? unSeenMessagesLengthGhost(id) {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        return null;
      }
      return FirebaseFirestore.instance
          .collection('ghost_messages')
          .doc(id)
          .collection('chats')
          .snapshots()
          .map(
            (event) => event.docs
                .where((element) =>
                    element.data()['sentById'] !=
                        FirebaseAuth.instance.currentUser!.uid &&
                    !element.data()['isSeen'])
                .map((e) => e.data())
                .length,
          );
    } catch (e) {
      return null;
    }
  }

  Stream<int> getTotalUnseenMessageCount() {
    return FirebaseFirestore.instance
        .collection('messages')
        .snapshots()
        .asyncMap((snapshot) async {
      List<QuerySnapshot> querySnapshots = await Future.wait(
          snapshot.docs.map((doc) => doc.reference.collection('chats').get()));
      int totalCount = 0;
      for (var querySnapshot in querySnapshots) {
        totalCount += querySnapshot.docs.where(
          (chatDoc) {
            var data = chatDoc.data() as Map<String,
                dynamic>?; // Explicit cast to Map<String, dynamic>
            return data != null &&
                data['content'].isNotEmpty &&
                data['sentToId'] == currentUserUID &&
                data['isSeen'] == false;
          },
        ).length;
      }
      return totalCount;
    });
  }

  Stream<int> getTotalUnseenMessageCountGhost() {
    return FirebaseFirestore.instance
        .collection('ghost_message')
        .snapshots()
        .asyncMap((snapshot) async {
      List<QuerySnapshot> querySnapshots = await Future.wait(
          snapshot.docs.map((doc) => doc.reference.collection('chats').get()));
      int totalCount = 0;
      for (var querySnapshot in querySnapshots) {
        totalCount += querySnapshot.docs.where(
          (chatDoc) {
            var data = chatDoc.data() as Map<String,
                dynamic>?; // Explicit cast to Map<String, dynamic>
            return data != null &&
                data['sentToId'] == currentUserUID &&
                data['isSeen'] == false;
          },
        ).length;
      }
      return totalCount;
    });
  }

  Stream<int> combineStreams(Stream<int> stream1, Stream<int> stream2) async* {
    await for (var value in stream1) {
      yield value;
    }
    await for (var value in stream2) {
      yield value;
    }
  }

  Stream<int> get totalUnReadMessages => combineStreams(
        getTotalUnseenMessageCount(),
        getTotalUnseenMessageCountGhost(),
      );

  // Stream<int> get totalUnReadMessages =>
  //     getTotalUnseenMessageCount().listen((event) => event) +
  //     getTotalUnseenMessageCountGhost().listen((event) => event);

  Stream<List<UserModel>?>? filterUserList(List chatUsers) {
    try {
      return FirebaseFirestore.instance.collection('users').snapshots().map(
            (event) => event.docs
                .where((element) => chatUsers.contains(element.id))
                .map((e) => UserModel.fromMap(e.data()))
                .toList(),
          );
    } catch (e) {
      return null;
    }
  }

  Stream<List<UserModel>?>? nonChatUsers(List friends, Set msgIds) {
    try {
      // List<String> msgIds = [];
      // FirebaseFirestore.instance
      //     .collection(cUsers)
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .collection(cMessageList)
      //     .get()
      //     .then((value) =>
      //         value.docs.where((element) => element.data().isNotEmpty).map((e) {
      //           var msg = MessageDetails.fromMap(e.data());
      //           msgIds.add(msg.id);
      //         }).toList());
      // print(msgIds);

      return FirebaseFirestore.instance.collection('users').snapshots().map(
            (event) => event.docs
                .where((element) =>
                    friends.contains(element.id) &&
                    !msgIds.contains(element.id))
                .map((e) => UserModel.fromMap(e.data()))
                .toList(),
          );
    } catch (e) {
      return null;
    }
  }

  Stream<List<UserModel>?>? ghostNonChatUsers(List friends) {
    try {
      List<String> msgIds = [];
      FirebaseFirestore.instance
          .collection(cUsers)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(cGhostMessageList)
          .get()
          .then((value) =>
              value.docs.where((element) => element.data().isNotEmpty).map((e) {
                var msg = MessageDetails.fromMap(e.data());
                msgIds.add(msg.id);
              }).toList());

      if (kDebugMode) {
        print(msgIds);
      }

      return FirebaseFirestore.instance.collection('users').snapshots().map(
            (event) => event.docs
                .where((element) => friends.contains(element.id))
                .where((element) => msgIds.contains(element.id))
                .map((e) => UserModel.fromMap(e.data()))
                .toList(),
          );
    } catch (e) {
      return null;
    }
  }

  Stream<List<GhostMessageDetails>?>? ghostChatListUsers() {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        return null;
      }
      return FirebaseFirestore.instance
          .collection('ghost_messages')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (event) => event.docs
                .where((element) => element
                    .data()['id']
                    .toString()
                    .contains(FirebaseAuth.instance.currentUser!.uid))
                .map((e) => GhostMessageDetails.fromMap(e.data()))
                .toList(),
          );
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
          .collection(isGhost ? 'ghost_messages' : "messages")
          .doc("$userId")
          .collection('chats')
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

  Stream<List<GroupModel>?>? joinedGroups() {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        return null;
      }
      return FirebaseFirestore.instance.collection(cGroups).snapshots().map(
          (event) => event.docs
              .where((element) =>
                  element
                      .data()['memberIds']
                      .contains(FirebaseAuth.instance.currentUser!.uid) &&
                  element.data()['creatorId'] !=
                      FirebaseAuth.instance.currentUser!.uid)
              .map(
                (e) => GroupModel.fromMap(e.data()),
              )
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<GroupModel>?>? createdGroups() {
    try {
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        return null;
      }
      return FirebaseFirestore.instance.collection(cGroups).snapshots().map(
          (event) => event.docs
              .where((element) =>
                  element.data()['creatorId'] ==
                  FirebaseAuth.instance.currentUser!.uid)
              .map(
                (e) => GroupModel.fromMap(e.data()),
              )
              .toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<GroupModel>?>? allGroups() {
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

  Stream<List<GroupModel>?>? searchGroups(String search) {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        return null;
      }
      if (search.isEmpty) {
        return FirebaseFirestore.instance.collection(cGroups).snapshots().map(
            (event) => event.docs
                .where((element) =>
                    element.data()['isVerified'] &&
                    element.data()['creatorId'] !=
                        FirebaseAuth.instance.currentUser!.uid)
                .map(
                  (e) => GroupModel.fromMap(e.data()),
                )
                .toList());
      }
      return FirebaseFirestore.instance.collection(cGroups).snapshots().map(
          (event) => event.docs
              .where((element) => element
                  .data()['name']
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase()))
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
      if (FirebaseAuth.instance.currentUser?.uid == null || groupId == null) {
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
