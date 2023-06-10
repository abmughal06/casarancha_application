import 'package:casarancha/models/comment_model.dart';
import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/models/post_model.dart';
import 'package:casarancha/resources/firebase_cloud_messaging.dart';
import 'package:casarancha/screens/dashboard/dashboard_controller.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_controller.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_screen.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../screens/chat/GhostMode/ghost_chat_screen.dart';

class PostCardController extends GetxController {
  PostCardController({required this.postdata});
  final PostModel postdata;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ProfileScreenController? profileScreenController;
  late TextEditingController commentController;

  String currentUserId = '';
  late var isLiked = false.obs;
  late var isSaved = false.obs;
  late DocumentReference<Map<String, dynamic>> postRef;
  MediaDetails? message;

  //Obserables
  var post = PostModel(
    id: '',
    creatorId: '',
    creatorDetails: CreatorDetails(
      name: '',
      imageUrl: '',
      isVerified: false,
    ),
    createdAt: '',
    description: '',
    locationName: '',
    shareLink: '',
  ).obs;

  //Methods

  Future<void> likeDisLikePost(currentUser, postId, creatorId) async {
    try {
      var ref = FirebaseFirestore.instance.collection("posts").doc(postId);
      if (isLiked.value) {
        ref.update({
          'likesIds': FieldValue.arrayUnion([currentUser])
        }).whenComplete(() async {
          var recieverRef = await FirebaseFirestore.instance
              .collection("users")
              .doc(creatorId)
              .get();
          var recieverFCMToken = recieverRef.data()!['fcmToken'];
          FirebaseMessagingService().sendNotificationToUser(
            creatorDetails: CreatorDetails(
                name: postdata.creatorDetails.name,
                imageUrl: postdata.creatorDetails.imageUrl,
                isVerified: postdata.creatorDetails.isVerified),
            title: user!.name,
            devRegToken: recieverFCMToken,
            userReqID: creatorId,
            msg: "has liked your post.",
          );
        });
      } else {
        ref.update({
          'likesIds': FieldValue.arrayRemove([currentUser])
        });
      }
      isLiked.value = !isLiked.value;
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    }
  }

  Future<void> commentOnPost() async {
    final commentText = commentController.text.trim();
    if (commentText.isEmpty) {
      GlobalSnackBar.show(message: 'Please write a comment');
      return;
    }
    final commentRef = postRef.collection('comments').doc();
    final commentId = commentRef.id;
    final comment = Comment(
        id: commentId,
        creatorId: currentUserId,
        creatorDetails: CreatorDetails(
          name: profileScreenController!.user.value.name,
          imageUrl: profileScreenController!.user.value.imageStr,
          isVerified: profileScreenController!.user.value.isVerified,
        ),
        createdAt: DateTime.now().toIso8601String(),
        message: commentText);
    try {
      postRef.update({
        'commentIds': FieldValue.arrayUnion([commentId])
      });
      commentRef.set(comment.toMap());
      commentController.clear();
      post.update((val) {
        val!.commentIds.add(commentId);
      });
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    }
  }

  Future<void> savePost() async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(post.value.id);
      if (isSaved.value) {
        userRef.update({
          'savedPostsIds': FieldValue.arrayRemove([post.value.id])
        });
        profileScreenController!.user.update((val) {
          val!.savedPostsIds.remove(currentUserId);
        });
      } else {
        userRef.update({
          'savedPostsIds': FieldValue.arrayUnion([post.value.id])
        });
        profileScreenController!.user.update((val) {
          val!.savedPostsIds.add(currentUserId);
        });
      }
      isSaved.value = !isSaved.value;
    } catch (e) {
      GlobalSnackBar.show(message: e.toString());
    }
  }

  void gotoAppUserScreen(String appUserId) {
    appUserId != FirebaseAuth.instance.currentUser?.uid
        ? Get.to(
            () => AppUserScreen(
              appUserController: Get.put(
                AppUserController(
                  appUserId: appUserId,
                  currentUserId: FirebaseAuth.instance.currentUser!.uid,
                ),
              ),
            ),
          )
        : Get.find<DashboardController>().pageController.jumpToPage(4);
  }

  //OverRides
  @override
  void onInit() {
    profileScreenController = Get.find<ProfileScreenController>();
    commentController = TextEditingController();

    currentUserId = profileScreenController!.user.value.id;
    post.value = postdata;

    postRef = FirebaseFirestore.instance.collection('posts').doc(post.value.id);

    isLiked.value = post.value.likesIds.contains(currentUserId);

    isSaved.value = profileScreenController!.user.value.savedPostsIds
        .contains(post.value.id);

    super.onInit();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}
