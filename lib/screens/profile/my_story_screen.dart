// import 'package:casarancha/widgets/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:story_view/story_view.dart';

// import '../../base/base_stateful_widget.dart';
// import '../../resources/color_resources.dart';
// import '../../resources/localization_text_strings.dart';
// import '../../utils/app_constants.dart';
// import '../../widgets/common_appbar.dart';

// class MyStoryScreen extends StatefulWidget {
//   const MyStoryScreen({Key? key}) : super(key: key);

//   @override
//   State<MyStoryScreen> createState() => _MyStoryScreenState();
// }

// class _MyStoryScreenState extends BaseStatefulWidgetState<MyStoryScreen> {
//   final controller = StoryController();
//   List<StoryItem> storyItems = [];
//   TextEditingController commentController = TextEditingController();
//   @override
//   void initState() {
//     // TODO: implement initState

//     super.initState();
//   }

//   @override
//   // TODO: implement scaffoldBgColor
//   Color? get scaffoldBgColor => colorBlack;

//   @override
//   PreferredSizeWidget? buildAppBar(BuildContext context) {
//     // TODO: implement buildAppBar
//     return const CommonAppBar(
//       title: "",
//       shouldShowBackButton: false,
//       statusBarColor: Colors.transparent,
//       statusBarBrightness: Brightness.dark,
//       statusBarIconBrightness: Brightness.light,
//       heightToolBar: 0,
//     );
//   }

//   @override
//   Widget buildBody(BuildContext context) {
//     return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//           return ConstrainedBox(
//               constraints: BoxConstraints(minHeight: constraints.maxHeight),
//               child: Stack(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Padding(
//                       //   padding: EdgeInsets.only(left: 20.w , right: 20.w , top: 20.h),
//                       //   child: profileImgName(
//                       //       imgUserNet: postProfileImg,
//                       //       isVerifyWithIc: true,
//                       //       isVerifyWithName: false,
//                       //       idIsVerified: true,
//                       //       dpRadius: 17.r,
//                       //       userName: "Allens.687",
//                       //       userNameClr: colorWhite,
//                       //       userNameFontSize: 12.sp,
//                       //       userNameFontWeight: FontWeight.w600,
//                       //       subText: "5 min ago",
//                       //       subTxtFontSize: 9.sp,subTxtClr: colorWhite.withOpacity(.5)
//                       //   ),
//                       // ),

//                       Expanded(
//                         child: StoryView(
//                             storyItems: [
//                               StoryItem.pageImage(
//                                   url: imgUrlStoryView, controller: controller),
//                             ],
//                             controller: controller,
//                             onComplete: () {
//                               goBack();
//                             },
//                             onVerticalSwipeComplete: (direction) {
//                               if (direction == Direction.down) {
//                                 goBack();
//                               }
//                             }),
//                       ),
//                     ],
//                   ),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Padding(
//                       padding:  EdgeInsets.symmetric(vertical: 20.h),
//                       child: TextWidget(
//                         text: strDeleteStory,
//                         fontSize: 17.sp,
//                         color: colorWhite,
//                       )
//                     ),
//                   )
//                 ],
//               ));
//         });
//   }
// }
