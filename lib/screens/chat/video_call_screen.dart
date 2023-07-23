// import 'package:casarancha/resources/image_resources.dart';
// import 'package:casarancha/utils/app_constants.dart';
// import 'package:casarancha/widgets/common_appbar.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../base/base_stateful_widget.dart';
// import 'package:flutter/material.dart';

// class VideoCallScreen extends StatefulWidget {
//   const VideoCallScreen({Key? key}) : super(key: key);

//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends BaseStatefulWidgetState<VideoCallScreen> {
//   @override
//   // TODO: implement shouldHaveSafeArea
//   bool get shouldHaveSafeArea => false;

//   @override
//   // TODO: implement isBackgroundImage
//   bool get isBackgroundImage => true;

//   @override
//   // TODO: implement extendBodyBehindAppBar
//   bool get extendBodyBehindAppBar => true;

//   @override
//   PreferredSizeWidget? buildAppBar(BuildContext context) {
//     // TODO: implement buildAppBar
//     return onlyLeadIcAppbar(onTap: ()=> goBack(), leadIcon: icLeftArrowCall, actionsWidget: [
//     ]);
//   }

//   @override
//   Widget buildBody(BuildContext context) {
//     return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//       return ConstrainedBox(
//           constraints: BoxConstraints(minHeight: constraints.minHeight),
//           child: Stack(
//             children: [
//               Image.network(videoCallBack,
//                   fit: BoxFit.cover,
//                   height: double.infinity,
//                   width: double.infinity,
//                   alignment: Alignment.center),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding:  EdgeInsets.only(bottom: 35.h),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(imgCallMute,height: 50.h,width: 50.w,),
//                       widthBox(44.w),
//                       Image.asset(imgCallPickRed,height: 65.h,width: 65.w,),
//                       widthBox(44.w),
//                       Image.asset(imgCallSound,height: 50.h,width: 50.w,),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ));
//     });
//   }
// }
