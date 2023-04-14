import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/widgets/app_user_tile.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:casarancha/widgets/primary_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';

import '../../resources/localization_text_strings.dart';

class FollowerFollowingScreen extends StatelessWidget {
  FollowerFollowingScreen({Key? key}) : super(key: key);
  final List<Widget> _myTabs = const [
    Tab(text: strProfileFollowers),
    Tab(text: strProfileFollowing),
  ];

  final ProfileScreenController profileScreenController =
      Get.find<ProfileScreenController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _myTabs.length,
      child: Scaffold(
        appBar: primaryAppbar(
          title: strFollowersFollowing,
          bottom: primaryTabBar(
            tabs: _myTabs,
          ),
        ),
        body: TabBarView(
          children: [
            FirestoreListView(
              query: FirebaseFirestore.instance.collection('users').where(
                    'followingsIds',
                    arrayContains: profileScreenController.user.value.id,
                  ),
              padding: EdgeInsets.all(10.h),
              itemBuilder:
                  (context, QueryDocumentSnapshot<Map<String, dynamic>> doc) {
                final UserModel user = UserModel.fromMap(doc.data());
                return AppUserTile(
                  appUser: user,
                  currentUser: profileScreenController.user.value,
                );
              },
            ),
            FirestoreListView(
              query: FirebaseFirestore.instance.collection('users').where(
                    'followersIds',
                    arrayContains: profileScreenController.user.value.id,
                  ),
              padding: EdgeInsets.all(10.h),
              itemBuilder:
                  (context, QueryDocumentSnapshot<Map<String, dynamic>> doc) {
                final UserModel user = UserModel.fromMap(doc.data());
                return AppUserTile(
                  appUser: user,
                  currentUser: profileScreenController.user.value,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
