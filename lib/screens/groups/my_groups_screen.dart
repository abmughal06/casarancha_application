// import 'package:casarancha/models/group_model.dart';
// import 'package:casarancha/models/post_creator_details.dart';
// import 'package:casarancha/screens/groups/create_group_screen.dart';
// import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
// import 'package:casarancha/widgets/group_tile.dart';
// import 'package:casarancha/widgets/listView_groups_whereIn_querry.dart';
// import 'package:casarancha/widgets/primary_Appbar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:flutterfire_ui/firestore.dart';
// import 'package:get/get.dart';

// import '../../base/base_stateful_widget.dart';
// import '../../resources/color_resources.dart';
// import '../../resources/image_resources.dart';
// import '../../resources/localization_text_strings.dart';
// import '../../utils/app_constants.dart';
// import '../../view_models/group_vm/my_group_view_model.dart';
// import '../../widgets/common_appbar.dart';

// import '../../widgets/common_widgets.dart';
// import '../../widgets/home_page_widgets.dart';
// import '../../widgets/text_widget.dart';
// import '../dashboard/dashboard.dart';

// class MyGroupsScreen extends StatefulWidget {
//   const MyGroupsScreen({Key? key}) : super(key: key);

//   @override
//   State<MyGroupsScreen> createState() => _MyGroupScreenState();
// }

// class _MyGroupScreenState extends State<MyGroupsScreen> {
//   final profileScreenController = Get.find<ProfileScreenController>();

//   final List<Widget> _myTabs = const [
//     Tab(text: strMyGroups),
//     Tab(text: strMyCreatedGroups),
//   ];

//   //

//   grpEditDelBottom(contextMenu) {
//     showModalBottomSheet(
//         context: contextMenu,
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r)),
//         ),
//         builder: (BuildContext context) {
//           return Padding(
//               padding: const EdgeInsets.all(33),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Align(
//                       alignment: Alignment.center,
//                       child: Container(
//                         height: 6.h,
//                         width: 78.w,
//                         decoration: BoxDecoration(
//                           color: colorDD9,
//                           borderRadius: BorderRadius.all(Radius.circular(30.r)),
//                         ),
//                       ),
//                     ),
//                     heightBox(30.h),
//                     TextWidget(
//                       onTap: () {},
//                       text: strEditGrpInfo,
//                       color: color13F,
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     heightBox(23.h),
//                     TextWidget(
//                       onTap: () {},
//                       text: strDeleteGrp,
//                       color: color13F,
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ]));
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: primaryAppbar(
//           title: 'My Groups',
//           // leading: ghostModeBtn(),
//           elevation: 0,
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Get.to(
//                   () => CreateGroupScreen(
//                     currentUser: profileScreenController.user.value,
//                   ),
//                 );
//               },
//               icon: SvgPicture.asset(
//                 icAddPostRed,
//               ),
//             ),
//           ],
//         ),
//         body: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               child: commonTabBar(
//                 tabsList: _myTabs,
//               ),
//             ),
//             heightBox(10.w),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   /*my groups*/
//                   ListViewGroupsWithWhereInQuerry(
//                     listOfIds: profileScreenController.user.value.groupIds,
//                     controllerTag: 'MyGroups',
//                   ),
//                   /*my created group*/
//                   FirestoreListView(
//                     padding: EdgeInsets.only(
//                       bottom: 100.h,
//                       left: 20.w,
//                       right: 20.w,
//                     ),
//                     query:
//                         FirebaseFirestore.instance.collection('groups').where(
//                               'creatorId',
//                               isEqualTo: profileScreenController.user.value.id,
//                             ),
//                     itemBuilder: (BuildContext context,
//                         QueryDocumentSnapshot<dynamic> doc) {
//                       final GroupModel group = GroupModel.fromMap(doc.data());
//                       return GroupTile(
//                         group: group,
//                         currentUserId: profileScreenController.user.value.id,
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Widget cardMyGroup({
// //   required String strProfileImg,
// //   required String userName,
// //   required String subTxt,
// //   GestureTapCallback? onTapAction,
// //   GestureTapCallback? onTapCard,
// // }) {
// //   return Padding(
// //     padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 20.w),
// //     child: GestureDetector(
// //       onTap: onTapCard,
// //       child: Container(
// //         padding: const EdgeInsets.all(15),
// //         decoration: BoxDecoration(
// //             color: colorWhite,
// //             borderRadius: BorderRadius.all(Radius.circular(15.r)),
// //             boxShadow: [
// //               BoxShadow(
// //                   color: Colors.grey.withOpacity(0.5),
// //                   blurRadius: 3.0,
// //                   offset: const Offset(0, 2)),
// //             ]),
// //         child: Row(
// //           mainAxisSize: MainAxisSize.max,
// //           children: [
// //             profileImgName(
// //                 dpRadius: 25.r,
// //                 imgUserNet: strProfileImg,
// //                 isVerifyWithName: true,
// //                 isVerifyWithIc: false,
// //                 idIsVerified: false,
// //                 userName: userName,
// //                 userNameFontWeight: FontWeight.w600,
// //                 subText: subTxt,
// //                 subTxtClr: colorAA3,
// //                 subTxtFontSize: 12.sp),
// //             const Spacer(),
// //             svgImgButton(svgIcon: icCardMenu, onTap: onTapAction),
// //           ],
// //         ),
// //       ),
// //     ),
// //   );
// // }
