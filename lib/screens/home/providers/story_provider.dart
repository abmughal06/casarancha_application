import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryProvider extends ChangeNotifier {
  int currentIndex = 0;

  final FocusNode commentFocus = FocusNode();

  changeIndex(value) {
    currentIndex = int.parse(value
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll("<", "")
        .replaceAll(">", ""));
    notifyListeners();
  }

  removeFromStory({storyItems, storyId, controller}) async {
    if (storyItems[currentIndex].id == storyItems.last.id) {
      Get.back();

      print("last");
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

  changeFocus({bool? hasFocus, controller}) {
    hasFocus! ? controller!.pause() : controller!.play();
    notifyListeners();
  }

  // sentComment(){
  //   print(
  //                                       "comment == ${commentController.text}");

  //                                   final messageRefForCurrentUser =
  //                                       FirebaseFirestore.instance
  //                                           .collection("users")
  //                                           .doc(FirebaseAuth
  //                                               .instance.currentUser!.uid)
  //                                           .collection('messageList')
  //                                           .doc(widget.story.creatorId)
  //                                           .collection('messages')
  //                                           .doc();

  //                                   final messageRefForAppUser =
  //                                       FirebaseFirestore.instance
  //                                           .collection("users")
  //                                           .doc(widget.story.creatorId)
  //                                           .collection('messageList')
  //                                           .doc(FirebaseAuth
  //                                               .instance.currentUser!.uid)
  //                                           .collection('messages')
  //                                           .doc(
  //                                             messageRefForCurrentUser.id,
  //                                           );

  //                                   var story = storyItems.toList();
  //                                   var mediaDetail =
  //                                       story[provider.currentIndex].toMap();

  //                                   final Message message = Message(
  //                                     id: messageRefForCurrentUser.id,
  //                                     sentToId: widget.story.creatorId,
  //                                     sentById: FirebaseAuth
  //                                         .instance.currentUser!.uid,
  //                                     content: mediaDetail,
  //                                     caption: commentController.text,
  //                                     type:
  //                                         "story-${story[provider.currentIndex].type}",
  //                                     createdAt:
  //                                         DateTime.now().toIso8601String(),
  //                                     isSeen: false,
  //                                   );
  //                                   print(
  //                                       "============= ------------------- ------- --= ====== ==== $message");
  //                                   final appUserMessage = message.copyWith(
  //                                       id: messageRefForAppUser.id);

  //                                   messageRefForCurrentUser
  //                                       .set(message.toMap())
  //                                       .then((value) => print(
  //                                           "=========== XXXXXXXXXXXXXXXX ++++++++++ message sent success"));
  //                                   messageRefForAppUser
  //                                       .set(appUserMessage.toMap());
  //                                   var recieverRef = await FirebaseFirestore
  //                                       .instance
  //                                       .collection("users")
  //                                       .doc(widget.story.creatorId)
  //                                       .get();

  //                                   var recieverFCMToken =
  //                                       recieverRef.data()!['fcmToken'];
  //                                   print(
  //                                       "=========> reciever fcm token = $recieverFCMToken");
  //                                   FirebaseMessagingService()
  //                                       .sendNotificationToUser(
  //                                     appUserId: recieverRef.id,
  //                                     imageUrl: storyItems[
  //                                                     provider.currentIndex]
  //                                                 .type ==
  //                                             'Photo'
  //                                         ? storyItems[provider.currentIndex]
  //                                             .link
  //                                         : '',
  //                                     // creatorDetails: creatorDetails,
  //                                     devRegToken: recieverFCMToken,

  //                                     msg: "has commented on your story",
  //                                   );
  //                                   _commentFocus.unfocus();
  //                                   commentController.text = "";
  //                                   controller!.play();
  // }

  // countStoryViews() async {
  //   log("story play");
  //   var ref =
  //       FirebaseFirestore.instance.collection("stories").doc(widget.story.id);
  //   var data = await ref.get();
  //   List<dynamic> array = data.data()!['mediaDetailsList'];
  //   log("=========================> ${array.length}");

  //   for (var e = 0; e < array.length; e++) {
  //     var media = MediaDetails.fromMap(array[e]);
  //     if (media.id == storyItems[currentIndex.value].id) {
  //       if (!media.storyViews!
  //           .contains(FirebaseAuth.instance.currentUser!.uid)) {
  //         log("----------------- barabar");

  //         List prevId = media.storyViews!.toList();
  //         List viewid = [FirebaseAuth.instance.currentUser!.uid];
  //         media = media.type == 'Photo'
  //             ? MediaDetails(
  //                 id: media.id,
  //                 name: media.name,
  //                 type: media.type,
  //                 link: media.link,
  //                 imageHeight: media.imageHeight,
  //                 imageWidth: media.imageWidth,
  //                 storyViews: prevId + viewid,
  //               )
  //             : media.type == 'Video'
  //                 ? MediaDetails(
  //                     id: media.id,
  //                     name: media.name,
  //                     type: media.type,
  //                     link: media.link,
  //                     storyViews: prevId + viewid,
  //                     videoAspectRatio: media.videoAspectRatio,
  //                     videoViews: media.videoViews,
  //                   )
  //                 : MediaDetails(
  //                     id: media.id,
  //                     name: media.name,
  //                     type: media.type,
  //                     link: media.link,
  //                     storyViews: prevId + viewid,
  //                   );
  //         print(media);
  //         array[e] = media.toMap();
  //       }
  //     }
  //   }

  //   ref.update({'mediaDetailsList': array});
  // }
}
