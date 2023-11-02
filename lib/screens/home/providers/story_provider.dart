import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_view/controller/story_controller.dart';

import '../../../models/media_details.dart';
import '../../../models/message.dart';
import '../../../resources/firebase_cloud_messaging.dart';

class StoryProvider extends ChangeNotifier {
  int currentIndex = 0;

  final StoryController controller = StoryController();
  final FocusNode commentFocus = FocusNode();
  TextEditingController commentController = TextEditingController();

  List<MediaDetails> storyItems = [];

  changeIndex(value) {
    currentIndex = int.parse(value
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll("<", "")
        .replaceAll(">", ""));
    // notifyListeners();
  }

  removeFromStory({storyItems, storyId, controller}) async {
    if (storyItems[currentIndex].id == storyItems.last.id) {
      Get.back();

      // print("last");
      var ref1 = FirebaseFirestore.instance.collection("stories").doc(storyId);
      var ref = await ref1.get();

      List<dynamic> storyRef = ref.data()!['mediaDetailsList'];

      storyRef.removeWhere(
          (element) => element['id'] == storyItems[currentIndex].id);

      await ref1.update({"mediaDetailsList": storyRef});
    } else {
      var ref1 = FirebaseFirestore.instance.collection("stories").doc(storyId);
      var ref = await ref1.get();

      List<dynamic> storyRef = ref.data()!['mediaDetailsList'];

      storyRef.removeWhere(
          (element) => element['id'] == storyItems[currentIndex].id);
      await ref1.update({"mediaDetailsList": storyRef});
      controller!.next();
    }
  }

  changeFocus(bool hasFocus) {
    hasFocus ? controller.pause() : controller.play();
    notifyListeners();
  }

  sentComment({String? creatorId}) async {
    final messageRefForCurrentUser = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messageList')
        .doc(creatorId)
        .collection('messages')
        .doc();

    final messageRefForAppUser = FirebaseFirestore.instance
        .collection("users")
        .doc(creatorId)
        .collection('messageList')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .doc(
          messageRefForCurrentUser.id,
        );

    var story = storyItems;
    var mediaDetail = story[currentIndex].toMap();

    final Message message = Message(
      id: messageRefForCurrentUser.id,
      sentToId: creatorId!,
      sentById: FirebaseAuth.instance.currentUser!.uid,
      content: mediaDetail,
      caption: commentController.text,
      type: "story-${story[currentIndex].type}",
      createdAt: DateTime.now().toIso8601String(),
      isSeen: false,
    );

    final appUserMessage = message.copyWith(id: messageRefForAppUser.id);

    messageRefForCurrentUser.set(message.toMap());
    messageRefForAppUser.set(appUserMessage.toMap());
    var recieverRef = await FirebaseFirestore.instance
        .collection("users")
        .doc(creatorId)
        .get();

    var recieverFCMToken = recieverRef.data()!['fcmToken'];

    FirebaseMessagingService().sendNotificationToUser(
      appUserId: recieverRef.id,
      content: storyItems[currentIndex].type == 'Photo'
          ? storyItems[currentIndex].link
          : '',
      notificationType: "story_cmnt",
      groupId: null,
      isMessage: false,
      // creatorDetails: creatorDetails,
      devRegToken: recieverFCMToken,

      msg: "has commented on your story",
    );
    commentFocus.unfocus();
    commentController.text = "";
    controller.play();
  }

  countStoryViews({String? storyId}) async {
    var storyViewsList = storyItems[currentIndex].storyViews;

    if (!storyViewsList!.contains(FirebaseAuth.instance.currentUser!.uid)) {
      storyViewsList.add(FirebaseAuth.instance.currentUser!.uid);
      storyItems[currentIndex].storyViews = storyViewsList;

      var ref = FirebaseFirestore.instance.collection("stories").doc(storyId);

      var media = storyItems.map((e) => e.toMap()).toList();
      ref.update({'mediaDetailsList': media});
    }
  }
}
