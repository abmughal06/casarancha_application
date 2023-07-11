// import 'dart:developer';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:casarancha/models/user_model.dart';
// import 'package:casarancha/resources/color_resources.dart';
// import 'package:casarancha/widgets/primary_Appbar.dart';
// import 'package:casarancha/widgets/primary_tabbar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';

// import '../../resources/image_resources.dart';
// import '../../resources/localization_text_strings.dart';
// import '../../widgets/common_widgets.dart';
// import '../../widgets/text_widget.dart';
// import 'AppUser/app_user_controller.dart';
// import 'AppUser/app_user_screen.dart';

// class CurruentUserFollowerFollowingScreen extends StatelessWidget {
//   const CurruentUserFollowerFollowingScreen({Key? key, this.follow = false})
//       : super(key: key);

//   final bool? follow;
//   final List<Widget> _myTabs = const [
//     Tab(text: strProfileFollowers),
//     Tab(text: strProfileFollowing),
//   ];

//   // final ProfileScreenController profileScreenController =
//   //     Get.find<ProfileScreenController>();

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: _myTabs.length,
//       child: Scaffold(
//         appBar: primaryAppbar(
//           title: strFollowersFollowing,
//           elevation: 0,
//           bottom: primaryTabBar(
//             tabs: _myTabs,
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//               stream: FirebaseFirestore.instance
//                   .collection("users")
//                   .doc(FirebaseAuth.instance.currentUser!.uid)
//                   .snapshots(),
//               builder: (context, snap) {
//                 if (snap.hasData) {
//                   log("sdlasda");
//                   var currentUser = UserModel.fromMap(snap.data!.data()!);
//                   return ListView.builder(
//                     itemCount: currentUser.followersIds.length,
//                     itemBuilder: (context, index) {
//                       return StreamBuilder<
//                           DocumentSnapshot<Map<String, dynamic>>>(
//                         stream: currentUser.followersIds.isNotEmpty
//                             ? FirebaseFirestore.instance
//                                 .collection('users')
//                                 .doc(currentUser.followersIds[index])
//                                 .snapshots()
//                             : null,
//                         builder: (context, doc) {
//                           if (doc.hasData) {
//                             final UserModel appUser =
//                                 UserModel.fromMap(doc.data!.data()!);
//                             print(appUser);
//                             return Card(
//                               elevation: 0.5,
//                               color: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15.sp)),
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 18, vertical: 4),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(15),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             Get.to(
//                                               () => AppUserScreen(
//                                                 appUserController: Get.put(
//                                                   AppUserController(
//                                                     appUserId: appUser.id,
//                                                     currentUserId:
//                                                         currentUser.id,
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: Container(
//                                             height: 50.h,
//                                             width: 50.h,
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: Colors.amber,
//                                               image: DecorationImage(
//                                                 image:
//                                                     CachedNetworkImageProvider(
//                                                         appUser.imageStr),
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         widthBox(12.w),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             InkWell(
//                                               onTap: () {
//                                                 Get.to(
//                                                   () => AppUserScreen(
//                                                     appUserController: Get.put(
//                                                       AppUserController(
//                                                         appUserId: appUser.id,
//                                                         currentUserId:
//                                                             FirebaseAuth
//                                                                 .instance
//                                                                 .currentUser!
//                                                                 .uid,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                               child: Row(
//                                                 children: [
//                                                   TextWidget(
//                                                       text: appUser.name,
//                                                       fontSize: 14.sp,
//                                                       color: const Color(
//                                                           0xff212121),
//                                                       fontWeight:
//                                                           FontWeight.w600),
//                                                   widthBox(4.w),
//                                                   if (appUser.isVerified)
//                                                     SvgPicture.asset(
//                                                         icVerifyBadge),
//                                                 ],
//                                               ),
//                                             ),
//                                             heightBox(2.h),
//                                             TextWidget(
//                                               text: appUser.username,
//                                               fontSize: 12.sp,
//                                               color: const Color(0xff5f5f5f),
//                                               fontWeight: FontWeight.w400,
//                                               textOverflow:
//                                                   TextOverflow.visible,
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     InkWell(
//                                       onTap: () async {
//                                         await FirebaseFirestore.instance
//                                             .collection("users")
//                                             .doc(appUser.id)
//                                             .update({
//                                           "followersIds":
//                                               FieldValue.arrayRemove(
//                                                   [currentUser.id])
//                                         });

//                                         await FirebaseFirestore.instance
//                                             .collection("users")
//                                             .doc(currentUser.id)
//                                             .update({
//                                           "followersIds":
//                                               FieldValue.arrayRemove(
//                                                   [appUser.id])
//                                         });
//                                       },
//                                       child: TextWidget(
//                                         text: "Remove",
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 14.sp,
//                                         color: colorPrimaryA05,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else if (doc.data == null) {
//                             return Container();
//                           } else {
//                             return Container();
//                           }
//                         },
//                       );
//                     },
//                   );
//                 } else if (snap.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: SizedBox(
//                       height: 30.h,
//                       width: 30.h,
//                       child: const CircularProgressIndicator(),
//                     ),
//                   );
//                 } else {
//                   return const Text("You don't have any followers right now");
//                 }
//               },
//             ),
//             StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//               stream: FirebaseFirestore.instance
//                   .collection("users")
//                   .doc(FirebaseAuth.instance.currentUser!.uid)
//                   .snapshots(),
//               builder: (context, snap) {
//                 if (snap.hasData) {
//                   log("sdlasda");
//                   var currentUser = UserModel.fromMap(snap.data!.data()!);
//                   return ListView.builder(
//                     itemCount: currentUser.followingsIds.length,
//                     itemBuilder: (context, index) {
//                       return StreamBuilder<
//                           DocumentSnapshot<Map<String, dynamic>>>(
//                         stream: currentUser.followingsIds.isNotEmpty
//                             ? FirebaseFirestore.instance
//                                 .collection('users')
//                                 .doc(currentUser.followingsIds[index])
//                                 .snapshots()
//                             : null,
//                         builder: (context, doc) {
//                           if (doc.hasData && doc.data!.exists) {
//                             final UserModel appUser =
//                                 UserModel.fromMap(doc.data!.data()!);
//                             print(appUser);
//                             return Card(
//                               elevation: 0.5,
//                               color: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15.sp)),
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 18, vertical: 4),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(15),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             Get.to(
//                                               () => AppUserScreen(
//                                                 appUserController: Get.put(
//                                                   AppUserController(
//                                                     appUserId: appUser.id,
//                                                     currentUserId:
//                                                         currentUser.id,
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           child: Container(
//                                             height: 50.h,
//                                             width: 50.h,
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: Colors.amber,
//                                               image: DecorationImage(
//                                                 image:
//                                                     CachedNetworkImageProvider(
//                                                         appUser.imageStr),
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         widthBox(12.w),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             InkWell(
//                                               onTap: () {
//                                                 Get.to(
//                                                   () => AppUserScreen(
//                                                     appUserController: Get.put(
//                                                       AppUserController(
//                                                         appUserId: appUser.id,
//                                                         currentUserId:
//                                                             FirebaseAuth
//                                                                 .instance
//                                                                 .currentUser!
//                                                                 .uid,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                               child: Row(
//                                                 children: [
//                                                   TextWidget(
//                                                       text: appUser.name,
//                                                       fontSize: 14.sp,
//                                                       color: const Color(
//                                                           0xff212121),
//                                                       fontWeight:
//                                                           FontWeight.w600),
//                                                   widthBox(4.w),
//                                                   if (appUser.isVerified)
//                                                     SvgPicture.asset(
//                                                         icVerifyBadge),
//                                                 ],
//                                               ),
//                                             ),
//                                             heightBox(2.h),
//                                             TextWidget(
//                                               text: appUser.username,
//                                               fontSize: 12.sp,
//                                               color: const Color(0xff5f5f5f),
//                                               fontWeight: FontWeight.w400,
//                                               textOverflow:
//                                                   TextOverflow.visible,
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     InkWell(
//                                       onTap: () async {
//                                         await FirebaseFirestore.instance
//                                             .collection("users")
//                                             .doc(appUser.id)
//                                             .update({
//                                           "followersIds":
//                                               FieldValue.arrayRemove(
//                                                   [currentUser.id])
//                                         });

//                                         await FirebaseFirestore.instance
//                                             .collection("users")
//                                             .doc(currentUser.id)
//                                             .update({
//                                           "followersIds":
//                                               FieldValue.arrayRemove(
//                                                   [appUser.id])
//                                         });
//                                       },
//                                       child: TextWidget(
//                                         text: "Remove",
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 14.sp,
//                                         color: colorPrimaryA05,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else if (doc.data == null) {
//                             return Center(
//                               child: TextWidget(
//                                 text: "You don't have any followings right now",
//                               ),
//                             );
//                           } else {
//                             return Container();
//                           }
//                         },
//                       );
//                     },
//                   );
//                 } else if (snap.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: SizedBox(
//                       height: 30.h,
//                       width: 30.h,
//                       child: const CircularProgressIndicator(),
//                     ),
//                   );
//                 } else {
//                   return const Text("You don't have any followings right now");
//                 }
//               },
//             ),

//             //tab 2 follower
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AppUserFollowerFollowingScreen extends StatelessWidget {
//   final String? appUserid;
//   const AppUserFollowerFollowingScreen(
//       {Key? key, this.follow = false, this.appUserid})
//       : super(key: key);

//   final bool? follow;
//   final List<Widget> _myTabs = const [
//     Tab(text: strProfileFollowers),
//     Tab(text: strProfileFollowing),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: _myTabs.length,
//       child: Scaffold(
//         appBar: primaryAppbar(
//           title: strFollowersFollowing,
//           elevation: 0,
//           bottom: primaryTabBar(
//             tabs: _myTabs,
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                 stream: FirebaseFirestore.instance
//                     .collection("users")
//                     .doc(appUserid)
//                     .snapshots(),
//                 builder: (context, snap) {
//                   if (snap.hasData) {
//                     log("sdlasda");
//                     var appuser = UserModel.fromMap(snap.data!.data()!);
//                     log("------------------------ >>>> ${appuser.followersIds.length}");
//                     return ListView.builder(
//                       itemCount: appuser.followersIds.length,
//                       itemBuilder: (context, index) {
//                         return StreamBuilder<
//                             DocumentSnapshot<Map<String, dynamic>>>(
//                           stream: appuser.followersIds.isNotEmpty
//                               ? FirebaseFirestore.instance
//                                   .collection('users')
//                                   .doc(appuser.followersIds[index])
//                                   .snapshots()
//                               : null,
//                           builder: (context, doc) {
//                             if (doc.hasData &&
//                                 doc.data != null &&
//                                 doc.data!.exists) {
//                               final UserModel userModel =
//                                   UserModel.fromMap(doc.data!.data()!);
//                               // print(userModel);
//                               return Card(
//                                 elevation: 0.5,
//                                 color: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(15.sp)),
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 18, vertical: 4),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(15),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           InkWell(
//                                             onTap: () {
//                                               Get.to(
//                                                 () => AppUserScreen(
//                                                   appUserController: Get.put(
//                                                     AppUserController(
//                                                       appUserId: appuser.id,
//                                                       currentUserId:
//                                                           FirebaseAuth.instance
//                                                               .currentUser!.uid,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             child: Container(
//                                               height: 50.h,
//                                               width: 50.h,
//                                               decoration: BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 color: Colors.amber,
//                                                 image: DecorationImage(
//                                                   image:
//                                                       CachedNetworkImageProvider(
//                                                           userModel.imageStr),
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           widthBox(12.w),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               InkWell(
//                                                 onTap: () {
//                                                   Get.to(
//                                                     () => AppUserScreen(
//                                                       appUserController:
//                                                           Get.put(
//                                                         AppUserController(
//                                                           appUserId:
//                                                               userModel.id,
//                                                           currentUserId:
//                                                               FirebaseAuth
//                                                                   .instance
//                                                                   .currentUser!
//                                                                   .uid,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Row(
//                                                   children: [
//                                                     TextWidget(
//                                                         text: userModel.name,
//                                                         fontSize: 14.sp,
//                                                         color: const Color(
//                                                             0xff212121),
//                                                         fontWeight:
//                                                             FontWeight.w600),
//                                                     widthBox(4.w),
//                                                     if (userModel.isVerified)
//                                                       SvgPicture.asset(
//                                                           icVerifyBadge),
//                                                   ],
//                                                 ),
//                                               ),
//                                               heightBox(2.h),
//                                               TextWidget(
//                                                 text: userModel.username,
//                                                 fontSize: 12.sp,
//                                                 color: const Color(0xff5f5f5f),
//                                                 fontWeight: FontWeight.w400,
//                                                 textOverflow:
//                                                     TextOverflow.visible,
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       InkWell(
//                                         onTap: () async {
//                                           await FirebaseFirestore.instance
//                                               .collection("users")
//                                               .doc(FirebaseAuth
//                                                   .instance.currentUser!.uid)
//                                               .update({
//                                             "followersIds":
//                                                 FieldValue.arrayRemove(
//                                                     [userModel.id])
//                                           });

//                                           await FirebaseFirestore.instance
//                                               .collection("users")
//                                               .doc(FirebaseAuth
//                                                   .instance.currentUser!.uid)
//                                               .update({
//                                             "followersIds":
//                                                 FieldValue.arrayRemove(
//                                                     [userModel.id])
//                                           });
//                                         },
//                                         child: StreamBuilder<
//                                             DocumentSnapshot<
//                                                 Map<String, dynamic>>>(
//                                           stream: FirebaseFirestore.instance
//                                               .collection("users")
//                                               .doc(FirebaseAuth
//                                                   .instance.currentUser!.uid)
//                                               .snapshots(),
//                                           builder: (context, snapshot) {
//                                             if (snapshot.hasData) {
//                                               final cUser = UserModel.fromMap(
//                                                   snapshot.data!.data()!);
//                                               return TextWidget(
//                                                 text: cUser.followingsIds
//                                                         .contains(userModel.id)
//                                                     ? "Unfollow"
//                                                     : "Follow",
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 14.sp,
//                                                 color: colorPrimaryA05,
//                                               );
//                                             } else {
//                                               return TextWidget(
//                                                 text: "---",
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 14.sp,
//                                                 color: colorPrimaryA05,
//                                               );
//                                             }
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             } else if (doc.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const SizedBox(
//                                 height: 30,
//                                 width: 30,
//                                 child: CircularProgressIndicator(),
//                               );
//                             } else {
//                               return Container();
//                             }
//                           },
//                         );
//                       },
//                     );
//                   } else if (snap.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: SizedBox(
//                         height: 30.h,
//                         width: 30.h,
//                         child: const CircularProgressIndicator(),
//                       ),
//                     );
//                   } else {
//                     return Text("hshha");
//                   }
//                 }),
//             StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                 stream: FirebaseFirestore.instance
//                     .collection("users")
//                     .doc(appUserid)
//                     .snapshots(),
//                 builder: (context, snap) {
//                   if (snap.hasData) {
//                     log("sdlasda");
//                     var appuser = UserModel.fromMap(snap.data!.data()!);
//                     log("------------------------ >>>> ${appuser.followingsIds.length}");
//                     return ListView.builder(
//                       itemCount: appuser.followingsIds.length,
//                       itemBuilder: (context, index) {
//                         return StreamBuilder<
//                             DocumentSnapshot<Map<String, dynamic>>>(
//                           stream: appuser.followingsIds.isNotEmpty
//                               ? FirebaseFirestore.instance
//                                   .collection('users')
//                                   .doc(appuser.followingsIds[index])
//                                   .snapshots()
//                               : null,
//                           builder: (context, doc) {
//                             if (doc.hasData &&
//                                 doc.data != null &&
//                                 doc.data!.exists) {
//                               final UserModel userModel =
//                                   UserModel.fromMap(doc.data!.data()!);
//                               // print(userModel);
//                               return Card(
//                                 elevation: 0.5,
//                                 color: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(15.sp)),
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 18, vertical: 4),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(15),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           InkWell(
//                                             onTap: () {
//                                               Get.to(
//                                                 () => AppUserScreen(
//                                                   appUserController: Get.put(
//                                                     AppUserController(
//                                                       appUserId: appuser.id,
//                                                       currentUserId:
//                                                           FirebaseAuth.instance
//                                                               .currentUser!.uid,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             child: Container(
//                                               height: 50.h,
//                                               width: 50.h,
//                                               decoration: BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 color: Colors.amber,
//                                                 image: DecorationImage(
//                                                   image:
//                                                       CachedNetworkImageProvider(
//                                                           userModel.imageStr),
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           widthBox(12.w),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               InkWell(
//                                                 onTap: () {
//                                                   Get.to(
//                                                     () => AppUserScreen(
//                                                       appUserController:
//                                                           Get.put(
//                                                         AppUserController(
//                                                           appUserId:
//                                                               userModel.id,
//                                                           currentUserId:
//                                                               FirebaseAuth
//                                                                   .instance
//                                                                   .currentUser!
//                                                                   .uid,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                                 child: Row(
//                                                   children: [
//                                                     TextWidget(
//                                                         text: userModel.name,
//                                                         fontSize: 14.sp,
//                                                         color: const Color(
//                                                             0xff212121),
//                                                         fontWeight:
//                                                             FontWeight.w600),
//                                                     widthBox(4.w),
//                                                     if (userModel.isVerified)
//                                                       SvgPicture.asset(
//                                                           icVerifyBadge),
//                                                   ],
//                                                 ),
//                                               ),
//                                               heightBox(2.h),
//                                               TextWidget(
//                                                 text: userModel.username,
//                                                 fontSize: 12.sp,
//                                                 color: const Color(0xff5f5f5f),
//                                                 fontWeight: FontWeight.w400,
//                                                 textOverflow:
//                                                     TextOverflow.visible,
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       InkWell(
//                                         onTap: () async {
//                                           await FirebaseFirestore.instance
//                                               .collection("users")
//                                               .doc(FirebaseAuth
//                                                   .instance.currentUser!.uid)
//                                               .update({
//                                             "followersIds":
//                                                 FieldValue.arrayRemove(
//                                                     [userModel.id])
//                                           });

//                                           await FirebaseFirestore.instance
//                                               .collection("users")
//                                               .doc(FirebaseAuth
//                                                   .instance.currentUser!.uid)
//                                               .update({
//                                             "followersIds":
//                                                 FieldValue.arrayRemove(
//                                                     [userModel.id])
//                                           });
//                                         },
//                                         child: StreamBuilder<
//                                             DocumentSnapshot<
//                                                 Map<String, dynamic>>>(
//                                           stream: FirebaseFirestore.instance
//                                               .collection("users")
//                                               .doc(FirebaseAuth
//                                                   .instance.currentUser!.uid)
//                                               .snapshots(),
//                                           builder: (context, snapshot) {
//                                             if (snapshot.hasData) {
//                                               final cUser = UserModel.fromMap(
//                                                   snapshot.data!.data()!);
//                                               return TextWidget(
//                                                 text: cUser.followingsIds
//                                                         .contains(userModel.id)
//                                                     ? "Unfollow"
//                                                     : "Follow",
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 14.sp,
//                                                 color: colorPrimaryA05,
//                                               );
//                                             } else {
//                                               return TextWidget(
//                                                 text: "---",
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 14.sp,
//                                                 color: colorPrimaryA05,
//                                               );
//                                             }
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             } else if (doc.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const SizedBox(
//                                 height: 30,
//                                 width: 30,
//                                 child: CircularProgressIndicator(),
//                               );
//                             } else {
//                               return Container();
//                             }
//                           },
//                         );
//                       },
//                     );
//                   } else if (snap.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: SizedBox(
//                         height: 30.h,
//                         width: 30.h,
//                         child: const CircularProgressIndicator(),
//                       ),
//                     );
//                   } else {
//                     return Text("hshha");
//                   }
//                 }),
//             //tab 2 follower
//           ],
//         ),
//       ),
//     );
//   }
// }
