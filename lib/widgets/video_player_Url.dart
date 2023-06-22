import 'dart:math';

import 'package:casarancha/models/media_details.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

// class VideoPlayerUrl extends StatefulWidget {
//   VideoPlayerUrl({
//     Key? key,
//     required this.mediaDetails,
//     required this.pageIndex,
//     this.videoPlayerController,
//     this.pageController,
//   }) : super(key: key);
//   final MediaDetails mediaDetails;
//   final int pageIndex;

//   PageController? pageController;

//   final VideoPlayerController? videoPlayerController;

//   @override
//   State<VideoPlayerUrl> createState() => _VideoPlayerUrlState();
// }

// class _VideoPlayerUrlState extends State<VideoPlayerUrl>
//     with AutomaticKeepAliveClientMixin {
//   late VideoPlayerController videoPlayerController;

//   late ChewieController chewieController;
//   bool isPlaying = false;
//   bool isVisible = false;
//   bool isMuted = true;

//   @override
//   void initState() {
//     widget.pageController?.addListener(() {
//       setState(() {});
//     });
//     super.initState();
//     if (widget.videoPlayerController == null) {
//       videoPlayerController =
//           VideoPlayerController.network(widget.mediaDetails.link);
//     } else {
//       videoPlayerController = widget.videoPlayerController!;
//     }
//     videoPlayerController =
//         VideoPlayerController.network(widget.mediaDetails.link)
//           ..initialize().then((_) async {
//             // Future.delayed(const Duration(seconds: 3));
//             setState(() {
//               isPlaying = true;

//               videoPlayerController.setVolume(0.0); // Mute the video initially
//               videoPlayerController.addListener(_videoPlayerListener);
//             });
//           });
//     chewieController = ChewieController(
//         videoPlayerController: videoPlayerController,
//         allowMuting: true,
//         showOptions: false,
//         autoPlay: false,
//         allowPlaybackSpeedChanging: false,
//         autoInitialize: true,
//         allowFullScreen: false,
//         showControlsOnInitialize: false,
//         deviceOrientationsOnEnterFullScreen: [
//           DeviceOrientation.landscapeLeft,
//           DeviceOrientation.landscapeRight
//         ],
//         deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//         aspectRatio: 2 / 3,
//         looping: false);
//   }

//   void _videoPlayerListener() {
//     if (isPlaying && isVisible && isMuted) {
//       videoPlayerController.setVolume(1.0); // Enable sound when visible
//       isMuted = false;
//     }
//   }

//   @override
//   void dispose() {
//     videoPlayerController.dispose();
//     chewieController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return VisibilityDetector(
//       key: Key(widget.mediaDetails.link),
//       onVisibilityChanged: (visibilityInfo) {
//         setState(() {
//           isVisible = visibilityInfo.visibleFraction == 1.0;
//           if (isVisible) {
//             videoPlayerController.play();
//             isPlaying = true;
//             // isMuted = false;
//             videoPlayerController.setVolume(1.0);
//           } else {
//             videoPlayerController.pause();
//             // isMuted = true;
//             isPlaying = false;
//             videoPlayerController.setVolume(0.0);
//           }
//         });
//       },
//       child: Chewie(controller: chewieController),
//     ); /* Stack(
//       children: [
//         (videoPlayerController?.value.isInitialized ?? false)
//             ? VideoPlayer(videoPlayerController!)
//             : const Center(child: CircularProgressIndicator.adaptive()),
//         if (videoPlayerController?.value.isInitialized ?? false)
//           Align(
//             alignment: Alignment.bottomLeft,
//             child: IconButton(
//               onPressed: () async {
//                 if (videoPlayerController?.value.isPlaying ?? false) {
//                   await videoPlayerController?.pause();
//                 } else {
//                   await videoPlayerController?.play();
//                 }
//               },
//               icon: Icon(
//                 (videoPlayerController?.value.isPlaying ?? false)
//                     ? Icons.pause_circle_filled_rounded
//                     : Icons.play_circle_fill_rounded,
//               ),
//             ),
//           )
//       ],
//     ); */
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key, required this.videoUrl, this.postId})
      : super(key: key);
  final String videoUrl;
  final String? postId;
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;
  // bool isPlaying = false;
  bool isVisible = false;
  // bool isMuted = true;s

  late ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    // if (widget.videoPlayerController == null) {
    //   videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    // } else {
    //   videoPlayerController = widget.videoPlayerController!;
    // }

    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    // Future.delayed(const Duration(seconds: 3));
    countVideoViews();

    // setState(() {
    // isPlaying = true;

    videoPlayerController.setVolume(0.0); // Mute the video initially
    // videoPlayerController.addListener(_videoPlayerListener);
    // });

    chewieController = ChewieController(
        // allowMuting: true,
        videoPlayerController: videoPlayerController,
        showOptions: false,
        autoPlay: false,
        allowPlaybackSpeedChanging: true,
        autoInitialize: true,
        showControlsOnInitialize: true,
        allowFullScreen: true,
        deviceOrientationsOnEnterFullScreen: [DeviceOrientation.portraitUp],
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        aspectRatio: 9 / 16,
        looping: false);
  }

  // void _videoPlayerListener() {
  //   if (isPlaying && isVisible && isMuted) {
  //     videoPlayerController.setVolume(1.0); // Enable sound when visible
  //     isMuted = false;
  //   }
  // }

  countVideoViews() async {
    var postRef =
        FirebaseFirestore.instance.collection("posts").doc(widget.postId);
    var data = await postRef.get();
    if (data.data()!.containsKey("viedoViews")) {
      List viwers = data.data()!['videoViews'];
      if (viwers.contains(FirebaseAuth.instance.currentUser!.uid)) {
      } else {
        postRef.update({
          "videoViews":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        });
        log(00000000000000);
      }
    } else {
      postRef.update({
        "videoViews":
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });
      log(00000000000000);
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (visibilityInfo) {
        setState(() {
          isVisible = visibilityInfo.visibleFraction > 0.5;
          if (isVisible) {
            videoPlayerController.play();
            // isPlaying = true;
            videoPlayerController.setVolume(1.0);
          } else {
            videoPlayerController.pause();
            // isPlaying = false;
            videoPlayerController.setVolume(0.0);
          }
        });
      },
      child: Chewie(controller: chewieController),
    );
    /* Stack(
      children: [
        (videoPlayerController?.value.isInitialized ?? false)
            ? VideoPlayer(videoPlayerController!)
            : const Center(child: CircularProgressIndicator.adaptive()),
        if (videoPlayerController?.value.isInitialized ?? false)
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              onPressed: () async {
                if (videoPlayerController?.value.isPlaying ?? false) {
                  await videoPlayerController?.pause();
                } else {
                  await videoPlayerController?.play();
                }
              },
              icon: Icon(
                (videoPlayerController?.value.isPlaying ?? false)
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_fill_rounded,
              ),
            ),
          )
      ],
    ); */
  }
}
