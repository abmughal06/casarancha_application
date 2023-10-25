import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/profile/ProfileScreen/provider/profile_provider.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/primary_tabbar.dart';
import 'package:casarancha/widgets/profle_screen_widgets/follow_following_tile.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../resources/color_resources.dart';
import '../../resources/localization_text_strings.dart';

class CurruentUserFollowerFollowingScreen extends StatelessWidget {
  const CurruentUserFollowerFollowingScreen({Key? key, this.follow = false})
      : super(key: key);

  final bool? follow;
  final List<Widget> _myTabs = const [
    Tab(text: strProfileFollowers),
    Tab(text: strProfileFollowing),
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserModel?>();
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    return DefaultTabController(
      length: _myTabs.length,
      initialIndex: follow! ? 0 : 1,
      child: Scaffold(
        appBar: primaryAppbar(
          title: strFollowersFollowing,
          elevation: 0,
          bottom: TabBar(
            labelColor: colorPrimaryA05,
            unselectedLabelColor: colorAA3,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
            indicatorColor: colorF03,
            indicatorPadding:
                EdgeInsets.symmetric(vertical: 5.h, horizontal: 40.w),
            dividerColor: Colors.transparent,
            tabs: _myTabs,
          ),
        ),
        body: TabBarView(
          children: [
            //tab 1 followers

            Consumer<List<UserModel>?>(
              builder: (context, users, b) {
                if (users == null) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else {
                  var filterList = users
                      .where((element) =>
                          currentUser!.followersIds.contains(element.id))
                      .toList();
                  if (filterList.isEmpty) {
                    return const Center(
                      child: TextWidget(
                        text: strAlertFollowing,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (context, index) {
                      final user = filterList[index];
                      final isFriend =
                          currentUser!.followingsIds.contains(user.id);
                      return FollowFollowingTile(
                        user: user,
                        ontapToggleFollow: () =>
                            profileProvider.toggleFollowBtn(
                                userModel: user,
                                appUserId: filterList[index].id),
                        btnName: isFriend ? strFriends : strSrcFollow,
                      );
                    },
                  );
                }
              },
            ),
            //tab 2 followings
            Consumer<List<UserModel>?>(
              builder: (context, users, b) {
                if (users == null) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else {
                  var filterList = users
                      .where((element) =>
                          currentUser!.followingsIds.contains(element.id))
                      .toList();
                  if (filterList.isEmpty) {
                    return const Center(
                      child: TextWidget(
                        text: strAlertFollow,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (context, index) {
                      final user = filterList[index];
                      return FollowFollowingTile(
                        user: user,
                        ontapToggleFollow: () =>
                            profileProvider.toggleFollowBtn(
                                userModel: currentUser, appUserId: user.id),
                        btnName: strRemove,
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppUserFollowerFollowingScreen extends StatelessWidget {
  final String? appUserid;
  const AppUserFollowerFollowingScreen(
      {Key? key, this.follow = false, this.appUserid})
      : super(key: key);

  final bool? follow;
  final List<Widget> _myTabs = const [
    Tab(text: strProfileFollowers),
    Tab(text: strProfileFollowing),
  ];

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    return DefaultTabController(
      length: _myTabs.length,
      initialIndex: follow! ? 0 : 1,
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
            Consumer<List<UserModel>?>(
              builder: (context, users, b) {
                if (users == null) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else {
                  var appUser =
                      users.where((element) => element.id == appUserid).first;
                  var filterList = users
                      .where((element) =>
                          appUser.followersIds.contains(element.id))
                      .toList();
                  var currentUser = users
                      .where((element) =>
                          element.id == FirebaseAuth.instance.currentUser!.uid)
                      .first;
                  if (filterList.isEmpty) {
                    return const Center(
                      child: TextWidget(
                        text: strAlertAppUsrFollow,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (context, index) {
                      final user = filterList[index];
                      final isFriend =
                          currentUser.followingsIds.contains(user.id);
                      return FollowFollowingTile(
                        user: user,
                        ontapToggleFollow: () =>
                            profileProvider.toggleFollowBtn(
                                userModel: user,
                                appUserId: filterList[index].id),
                        btnName: user.id == currentUser.id
                            ? ""
                            : isFriend
                                ? strFriends
                                : strSrcFollow,
                      );
                    },
                  );
                }
              },
            ),
            //tab 2 followings
            Consumer<List<UserModel>?>(
              builder: (context, users, b) {
                if (users == null) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else {
                  var appUser =
                      users.where((element) => element.id == appUserid).first;
                  var currentUser = users
                      .where((element) =>
                          element.id == FirebaseAuth.instance.currentUser!.uid)
                      .first;
                  users.where((element) => element.id == appUserid).first;
                  var filterList = users
                      .where((element) =>
                          appUser.followingsIds.contains(element.id))
                      .toList();
                  if (filterList.isEmpty) {
                    return const Center(
                      child: TextWidget(
                        text: strAlertAppUsrFollowings,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (context, index) {
                      final user = filterList[index];
                      final isFriend =
                          currentUser.followingsIds.contains(user.id);
                      return FollowFollowingTile(
                        user: user,
                        ontapToggleFollow: () =>
                            profileProvider.toggleFollowBtn(
                                userModel: user,
                                appUserId: filterList[index].id),
                        btnName: user.id == currentUser.id
                            ? ""
                            : !isFriend
                                ? strFriends
                                : strSrcFollow,
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
