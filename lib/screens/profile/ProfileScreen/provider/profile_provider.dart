import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ProfileProvider extends ChangeNotifier {
  VideoPlayerController? videoPlayerController;
  String? postId;
  String? creatorId;
  ChewieController? chewieController;

  ProfileProvider({this.videoPlayerController, this.postId, this.creatorId}) {
    initializeChewieController();
  }

  void initializeChewieController() {
    chewieController = ChewieController(
      autoPlay: true,
      aspectRatio: 9 / 16,
      videoPlayerController: videoPlayerController!,
    );
  }

  void deletePost() async {
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .delete()
        .then((value) => Get.back())
        .whenComplete(() => Get.back());
  }
}
