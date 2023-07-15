// // ignore_for_file: use_build_context_synchronously

// import 'dart:developer';

// import 'package:casarancha/models/user_model.dart';
// import 'package:casarancha/resources/color_resources.dart';
// import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
// import 'package:casarancha/view_models/home_vm/story_view_view_model.dart';
// import 'package:casarancha/widgets/PostCard/PostCardController.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../models/media_details.dart';
// import '../models/post_model.dart';
// import '../models/story_model.dart';

// FirebaseFirestore get firestore => FirebaseFirestore.instance;
// Widget menuButton(context, var postOrPostCtrl,
//     {EdgeInsetsGeometry? margin,
//     EdgeInsetsGeometry? padding,
//     ProfileScreenController? profileScreenController}) {
//   PostModel? post;
//   if (postOrPostCtrl is PostCardController) {
//     post = postOrPostCtrl.post.value;
//   } else if (postOrPostCtrl is PostModel) {
//     post = postOrPostCtrl;
//   } else {
//     post = null;
//   }
//   if (post != null) {
//     return PopupMenuButton<String>(
//       offset: const Offset(0, -8),
//       onSelected: (value) async {
//         switch (value) {
//           case 'Open_Dialog':
//             reportPostDialog(context, postId: post!.id);
//             break;
//           case 'Delete_Post':
//             await deletePost(post!);
//             Get.back();
//             break;
//           default:
//             throw UnimplementedError();
//         }
//       },
//       position: PopupMenuPosition.under,
//       child: Container(
//           alignment: Alignment.center,
//           padding: padding ?? const EdgeInsets.all(4),
//           decoration: const BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                     offset: Offset(0.5, 0.5),
//                     spreadRadius: 1.5,
//                     blurRadius: 1.5,
//                     color: Colors.black12)
//               ],
//               shape: BoxShape.circle),
//           child: const Icon(
//             Icons.more_horiz,
//             size: 25,
//             color: Colors.black,
//           )),
//       itemBuilder: (context) {
//         return [
//           if (FirebaseAuth.instance.currentUser?.uid == post?.creatorId)
//             const PopupMenuItem(
//               value: "Delete_Post",
//               height: kMinInteractiveDimension / 1.8,
//               child: Text("Delete"),
//             ),
//           if (FirebaseAuth.instance.currentUser?.uid != post?.creatorId)
//             const PopupMenuItem(
//               value: "Open_Dialog",
//               height: kMinInteractiveDimension / 1.8,
//               child:
//                   Text("Report Post", style: TextStyle(color: colorPrimaryA05)),
//             )
//         ];
//       },
//     );
//   }
//   return const SizedBox(height: 0, width: 0);
// }

// deletePost(
//   PostModel post,
// ) async {
//   ProfileScreenController pSCtrl = Get.isRegistered<ProfileScreenController>()
//       ? Get.find<ProfileScreenController>()
//       : Get.put(ProfileScreenController());
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   DocumentSnapshot<Map<String, dynamic>> doc =
//       await firestore.collection("users").doc(post.creatorId).get();
//   UserModel user = UserModel.fromMap(doc.data() ?? {});
//   var posts = user.postsIds;
//   posts.removeWhere((element) => element == post.id);
//   await doc.reference.update({"postsIds": posts});
//   await deleteFileFromStore(post.mediaData
//       .where((element) => element.type.toLowerCase().toString() != "qoute")
//       .toList());
//   var batch = firestore.batch();
//   await firestore
//       .collection("posts")
//       .doc(post.id)
//       .collection("comments")
//       .get()
//       .then((value) async {
//     for (var element in value.docs) {
//       if (element.exists) {
//         batch.delete(element.reference);
//       }
//     }
//     batch.commit();
//     pSCtrl.updatePostList(post: post);
//   });

//   await firestore.collection("posts").doc(post.id).delete();
//   pSCtrl.user.value.updatePostsIds(posts);
// }

// Future<void> deleteFileFromStore(List<MediaDetails> details) async {
//   FirebaseStorage storage = FirebaseStorage.instance;
//   for (var element in details) {
//     await storage.refFromURL(element.link).delete();
//   }
// }

// deleteStories(String userId) async {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   await firestore.collection("stories").doc(userId).get().then((value) async {
//     if (value.exists) {
//       Story story = Story.fromMap(value.data() ?? {});
//       await deleteFileFromStore(story.mediaDetailsList
//           .where((element) => element.type.toLowerCase().toString() != "qoute")
//           .toList());
//       await value.reference.delete();
//     }
//   });
// }

// deleteUser(String userId) async {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   var batch = firestore.batch();
//   await firestore.collection("users").doc(userId).get().then((value) async {
//     if (value.exists) {
//       UserModel userModel = UserModel.fromMap(value.data() ?? {});
//       QuerySnapshot<Map<String, dynamic>> querySnapshot =
//           await value.reference.collection("ghostConversation").get();
//       for (var chat in querySnapshot.docs) {
//         DocumentReference<Map<String, dynamic>> chatRef =
//             firestore.collection("ghostChatRooms").doc(chat['chatId']);
//         QuerySnapshot<Map<String, dynamic>> messages =
//             await chatRef.collection("ghostMessages").get();
//         for (var message in messages.docs) {
//           if (message.exists) {
//             batch.delete(message.reference);
//           }
//         }
//         var chatsnap = await chatRef.get();
//         if (chatsnap.exists) {
//           batch.delete(chatRef);
//         }
//         if (chat.exists) {
//           batch.delete(chat.reference);
//         }
//         await batch.commit();
//       }
//       if (userModel.imageStr.isNotEmpty) {
//         deleteFileFromStore([
//           MediaDetails(
//               id: "0", name: "0", type: "image", link: userModel.imageStr)
//         ]);
//       }
//       await value.reference.delete();
//     }
//   });
// }

// Future<bool?> reportPost(String postId, String reporterUserId) async {
//   try {
//     DocumentSnapshot docSnapshot = await firestore
//         .collection("reportPost")
//         .doc("${postId}_$reporterUserId")
//         .get();
//     if (!docSnapshot.exists) {
//       DocumentReference reportDocRef = docSnapshot.reference;
//       await reportDocRef.set({
//         "objId": reportDocRef.id,
//         "reporterUserId": reporterUserId,
//         "postId": postId,
//         "createAt": DateTime.now().microsecondsSinceEpoch
//       });
//       return true;
//     } else {
//       return false;
//     }
//   } catch (e) {
//     log("error in reportPost => $e");
//   }
//   return null;
// }

// Future<bool?> addPostReportCount(String postId, String reporterUserId) async {
//   bool? reportSuccess;
//   try {
//     reportSuccess = await reportPost(postId, reporterUserId);
//     if (reportSuccess == true) {
//       DocumentSnapshot<Map<String, dynamic>> docSnap =
//           await firestore.collection("posts").doc(postId).get();
//       PostModel post = PostModel.fromMap(docSnap.data() ?? {});
//       DocumentReference postRef = docSnap.reference;
//       await postRef.set({"reportCount": (post.reportCount ?? 0) + 1},
//           SetOptions(merge: true));
//     }
//   } catch (e) {
//     log("error in addPostReportCount => $e");
//   }
//   return reportSuccess;
// }

// thanksForPostReportDialog(context) async {
//   await showDialog(
//       context: context,
//       builder: (context) {
//         return CupertinoAlertDialog(
//           title: const Text("Thanks for report!"),
//           content: const Text(
//               "Support team will take action as soon as possible on this post."),
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   Get.back();
//                 },
//                 child: const Text("Back"))
//           ],
//         );
//       });
// }

// alreadyPostReportDialog(context) async {
//   await showDialog(
//       context: context,
//       builder: (context) {
//         return CupertinoAlertDialog(
//           title: const Text("Report already submitted"),
//           content: const Text(
//               "Report already submitted! Support team will take action as soon as possible on this post."),
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   Get.back();
//                 },
//                 child: const Text("Back"))
//           ],
//         );
//       });
// }

// reportPostDialog(context, {required String postId}) async {
//   String? uid = FirebaseAuth.instance.currentUser?.uid;
//   if (uid != null) {
//     await showDialog(
//         context: context,
//         builder: (context) {
//           bool isLoading = false;
//           return StatefulBuilder(builder: (context, setState) {
//             return isLoading
//                 ? const Center(
//                     child: CircularProgressIndicator(color: colorPrimaryA05))
//                 : CupertinoAlertDialog(
//                     title: const Text("Report Post!"),
//                     content: const Text(
//                         "Are you sure you want to report this post?"),
//                     actions: [
//                       TextButton(
//                           onPressed: () async {
//                             setState(() {
//                               isLoading = true;
//                             });
//                             bool? reportSuccess =
//                                 await addPostReportCount(postId, uid);
//                             setState(() {
//                               isLoading = false;
//                             });
//                             if (reportSuccess == true) {
//                               Get.back();
//                               thanksForPostReportDialog(context);
//                             } else if (reportSuccess == false) {
//                               Get.back();
//                               alreadyPostReportDialog(context);
//                             }
//                           },
//                           child: const Text(
//                             "Report",
//                             style: TextStyle(color: colorPrimaryA05),
//                           )),
//                       TextButton(
//                           onPressed: () {
//                             Get.back();
//                           },
//                           child: const Text(
//                             "Cancel",
//                             style: TextStyle(color: colorBlack),
//                           ))
//                     ],
//                   );
//           });
//         });
//   }
// }
