// import 'package:casarancha/widgets/video_player_Url.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:video_player/video_player.dart';

// class CustomVideoCard extends StatefulWidget {
//   const CustomVideoCard(
//       {Key? key,
//       this.aspectRatio,
//       this.videoUrl,
//       this.videoPlayerController,
//       this.menuButton})
//       : super(key: key);
//   final double? aspectRatio;
//   final String? videoUrl;
//   final VideoPlayerController? videoPlayerController;
//   final Widget? menuButton;

//   @override
//   State<CustomVideoCard> createState() => _CustomVideoCardState();
// }

// class _CustomVideoCardState extends State<CustomVideoCard> {
//   @override
//   void initState() {
//     // TODO: implement initState

//     super.initState();
//     widget.videoPlayerController!.play();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       margin: EdgeInsets.zero,
//       color: Colors.transparent,
//       child: Stack(
//         children: [
//           Center(
//             child: AspectRatio(
//               aspectRatio: widget.aspectRatio!,
//               child: SizedBox(
//                 height: 360.w,
//                 child: VideoPlayerWidget(
//                   videoUrl: widget.videoUrl!,
//                   videoPlayerController: widget.videoPlayerController,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 20,
//             right: 15,
//             child: widget.menuButton!,
//           )
//         ],
//       ),
//     );
//   }
// }
