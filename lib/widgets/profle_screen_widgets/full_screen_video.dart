import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../resources/image_resources.dart';
import '../text_widget.dart';

class FullScreenVideo extends StatefulWidget {
  const FullScreenVideo(
      {Key? key, this.videoPlayerController, this.postId, this.creatorId})
      : super(key: key);

  final VideoPlayerController? videoPlayerController;
  final String? postId;
  final String? creatorId;

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    chewieController = ChewieController(
      autoPlay: true,
      aspectRatio: 9 / 16,
      videoPlayerController: widget.videoPlayerController!,
    );
  }

  @override
  void dispose() {
    super.dispose();
    chewieController!.pause();
    chewieController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      child: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: Chewie(
                controller: chewieController!,
              ),
            ),
          ),
          Visibility(
            visible: widget.creatorId == FirebaseAuth.instance.currentUser!.uid,
            child: Positioned(
              top: 40,
              right: 15,
              child: InkWell(
                onTap: () {
                  Get.bottomSheet(
                    Container(
                      decoration: const BoxDecoration(color: Colors.red),
                      height: 80,
                      child: InkWell(
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection("posts")
                              .doc(widget.postId)
                              .delete()
                              .then((value) => Get.back())
                              .whenComplete(() => Get.back());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: "Delete Post",
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    isScrollControlled: true,
                  );
                  // Get.back();
                },
                child: Container(
                  height: 30.h,
                  width: 30.h,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: SvgPicture.asset(icThreeDots),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 15,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: SvgPicture.asset(icIosBackArrow),
              ),
            ),
          )
        ],
      ),
    );
  }
}
