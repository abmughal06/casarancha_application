import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/widgets/app_user_tile.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:casarancha/widgets/primary_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart';

import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_widget.dart';
import 'AppUser/app_user_controller.dart';
import 'AppUser/app_user_screen.dart';

class FollowerFollowingScreen extends StatelessWidget {
  const FollowerFollowingScreen({Key? key, this.follow = false})
      : super(key: key);
  final bool? follow;
  final List<Widget> _myTabs = const [
    Tab(text: strProfileFollowers),
    Tab(text: strProfileFollowing),
  ];

  // final ProfileScreenController profileScreenController =
  //     Get.find<ProfileScreenController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _myTabs.length,
      child: Scaffold(
        appBar: primaryAppbar(
          title: strFollowersFollowing,
          elevation: 0,
          bottom: primaryTabBar(
            tabs: _myTabs,
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snap) {
                  if (snap.hasData) {
                    print("sdlasda");
                    var currentUser = UserModel.fromMap(snap.data!.data()!);
                    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where(
                            'id',
                            whereIn: currentUser.followersIds,
                          )
                          .snapshots(),
                      builder: (context, doc) {
                        if (doc.hasData) {
                          return ListView.builder(
                            itemCount: doc.data!.docs.length,
                            itemBuilder: (context, index) {
                              final UserModel appUser = UserModel.fromMap(
                                  doc.data!.docs[index].data());
                              print(appUser);
                              return Card(
                                elevation: 0.5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.sp)),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 4),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.to(
                                                () => AppUserScreen(
                                                  appUserController: Get.put(
                                                    AppUserController(
                                                      appUserId: appUser.id,
                                                      currentUserId:
                                                          currentUser.id,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 50.h,
                                              width: 50.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.amber,
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          appUser.imageStr),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          widthBox(12.w),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.to(
                                                    () => AppUserScreen(
                                                      appUserController:
                                                          Get.put(
                                                        AppUserController(
                                                          appUserId: appUser.id,
                                                          currentUserId:
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    TextWidget(
                                                        text: appUser.name,
                                                        fontSize: 14.sp,
                                                        color: const Color(
                                                            0xff212121),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    widthBox(4.w),
                                                    if (appUser.isVerified)
                                                      SvgPicture.asset(
                                                          icVerifyBadge),
                                                  ],
                                                ),
                                              ),
                                              heightBox(2.h),
                                              TextWidget(
                                                text: appUser.username,
                                                fontSize: 12.sp,
                                                color: const Color(0xff5f5f5f),
                                                fontWeight: FontWeight.w400,
                                                textOverflow:
                                                    TextOverflow.visible,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(appUser.id)
                                              .update({
                                            "followersIds":
                                                FieldValue.arrayRemove(
                                                    [currentUser.id])
                                          });

                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(currentUser.id)
                                              .update({
                                            "followersIds":
                                                FieldValue.arrayRemove(
                                                    [appUser.id])
                                          });
                                        },
                                        child: TextWidget(
                                          text: "Remove",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                          color: colorPrimaryA05,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  } else if (snap.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        height: 30.h,
                        width: 30.h,
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Text("hshha");
                  }
                }),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snap) {
                  if (snap.hasData) {
                    print("sdlasda");
                    var currentUser = UserModel.fromMap(snap.data!.data()!);
                    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where(
                            'id',
                            whereIn: currentUser.followingsIds,
                          )
                          .snapshots(),
                      builder: (context, doc) {
                        if (doc.hasData) {
                          return ListView.builder(
                            itemCount: doc.data!.docs.length,
                            itemBuilder: (context, index) {
                              final UserModel appUser = UserModel.fromMap(
                                  doc.data!.docs[index].data());
                              print(appUser);
                              return Card(
                                elevation: 0.5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.sp)),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 4),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.to(
                                                () => AppUserScreen(
                                                  appUserController: Get.put(
                                                    AppUserController(
                                                      appUserId: appUser.id,
                                                      currentUserId:
                                                          currentUser.id,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 50.h,
                                              width: 50.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.amber,
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          appUser.imageStr),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          widthBox(12.w),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.to(
                                                    () => AppUserScreen(
                                                      appUserController:
                                                          Get.put(
                                                        AppUserController(
                                                          appUserId: appUser.id,
                                                          currentUserId:
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    TextWidget(
                                                        text: appUser.name,
                                                        fontSize: 14.sp,
                                                        color: const Color(
                                                            0xff212121),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    widthBox(4.w),
                                                    if (appUser.isVerified)
                                                      SvgPicture.asset(
                                                          icVerifyBadge),
                                                  ],
                                                ),
                                              ),
                                              heightBox(2.h),
                                              TextWidget(
                                                text: appUser.username,
                                                fontSize: 12.sp,
                                                color: const Color(0xff5f5f5f),
                                                fontWeight: FontWeight.w400,
                                                textOverflow:
                                                    TextOverflow.visible,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            "followingsIds":
                                                FieldValue.arrayRemove(
                                                    [appUser.id])
                                          });
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(appUser.id)
                                              .update({
                                            "followingsIds":
                                                FieldValue.arrayRemove(
                                                    [currentUser.id])
                                          });
                                        },
                                        child: TextWidget(
                                          text: "Unfollow",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                          color: colorPrimaryA05,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  } else if (snap.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        height: 30.h,
                        width: 30.h,
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Text("hshha");
                  }
                }),

            //tab 2 follower
          ],
        ),
      ),
    );
  }
}
