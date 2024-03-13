import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/profile/ProfileScreen/provider/profile_provider.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/primary_tabbar.dart';
import 'package:casarancha/widgets/profle_screen_widgets/follow_following_tile.dart';
import 'package:casarancha/widgets/text_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../resources/color_resources.dart';

class CurruentUserFollowerFollowingScreen extends StatelessWidget {
  const CurruentUserFollowerFollowingScreen({super.key, this.follow = false});

  final bool? follow;

  @override
  Widget build(BuildContext context) {
    final List<Widget> myTabs = [
      Tab(text: appText(context).strProfileFollowers),
      Tab(text: appText(context).strProfileFollowing),
    ];
    final currentUser = context.watch<UserModel?>();
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    return DefaultTabController(
      length: myTabs.length,
      initialIndex: follow! ? 0 : 1,
      child: Scaffold(
        appBar: primaryAppbar(
          title: appText(context).strFollowersFollowing,
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
            tabs: myTabs,
          ),
        ),
        body: currentUser == null
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                ),
              )
            : TabBarView(
                children: [
                  //tab 1 followers

                  StreamProvider.value(
                    value:
                        DataProvider().filterUserList(currentUser.followersIds),
                    initialData: null,
                    catchError: (context, error) => null,
                    child: Consumer<List<UserModel>?>(
                      builder: (context, users, b) {
                        if (users == null) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        }
                        if (users.isEmpty) {
                          return Center(
                            child: TextWidget(
                              text: appText(context).strAlertFollowing,
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            final isFriend =
                                currentUser.followingsIds.contains(user.id);
                            return FollowFollowingTile(
                              user: user,
                              ontapToggleFollow: () => profileProvider
                                  .toggleFollowBtn(context, appUserId: user.id),
                              btnName: isFriend
                                  ? appText(context).strFriends
                                  : appText(context).strSrcFollow,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  //tab 2 followings
                  StreamProvider.value(
                    value: DataProvider()
                        .filterUserList(currentUser.followingsIds),
                    initialData: null,
                    catchError: (context, error) => null,
                    child: Consumer<List<UserModel>?>(
                        builder: (context, users, b) {
                      if (users == null) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }
                      if (users.isEmpty) {
                        return Center(
                          child: TextWidget(
                            text: appText(context).strAlertFollow,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return FollowFollowingTile(
                            user: user,
                            ontapToggleFollow: () => profileProvider
                                .toggleFollowBtn(context, appUserId: user.id),
                            btnName: appText(context).strRemove,
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}

class AppUserFollowerFollowingScreen extends StatelessWidget {
  final UserModel appUser;
  const AppUserFollowerFollowingScreen(
      {super.key, this.follow = false, required this.appUser});

  final bool? follow;

  @override
  Widget build(BuildContext context) {
    final List<Widget> myTabs = [
      Tab(text: appText(context).strProfileFollowers),
      Tab(text: appText(context).strProfileFollowing),
    ];
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final currentUser = context.watch<UserModel?>();

    return DefaultTabController(
      length: myTabs.length,
      initialIndex: follow! ? 0 : 1,
      child: Scaffold(
        appBar: primaryAppbar(
          title: appText(context).strFollowersFollowing,
          elevation: 0,
          bottom: primaryTabBar(
            tabs: myTabs,
          ),
        ),
        body: currentUser == null
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                ),
              )
            : TabBarView(
                children: [
                  StreamProvider.value(
                    value: DataProvider().filterUserList(appUser.followersIds),
                    initialData: null,
                    catchError: (context, error) => null,
                    child: Consumer<List<UserModel>?>(
                        builder: (context, users, b) {
                      if (users == null) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }

                      if (users.isEmpty) {
                        return Center(
                          child: TextWidget(
                            text: appText(context).strAlertAppUsrFollow,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final isFriend =
                              currentUser.followingsIds.contains(user.id);
                          return FollowFollowingTile(
                            user: user,
                            ontapToggleFollow: () =>
                                profileProvider.toggleFollowBtn(
                              context,
                              appUserId: user.id,
                            ),
                            btnName: user.id == currentUser.id
                                ? ""
                                : isFriend
                                    ? appText(context).strFriends
                                    : appText(context).strSrcFollow,
                          );
                        },
                      );
                    }),
                  ),
                  //tab 2 followings
                  StreamProvider.value(
                    value: DataProvider().filterUserList(appUser.followingsIds),
                    initialData: null,
                    catchError: (context, error) => null,
                    child: Consumer<List<UserModel>?>(
                      builder: (context, users, b) {
                        if (users == null) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        } else {
                          if (users.isEmpty) {
                            return Center(
                              child: TextWidget(
                                text: appText(context).strAlertAppUsrFollowings,
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              final isFriend =
                                  currentUser.followingsIds.contains(user.id);
                              return FollowFollowingTile(
                                user: user,
                                ontapToggleFollow: () =>
                                    profileProvider.toggleFollowBtn(
                                  context,
                                  appUserId: user.id,
                                ),
                                btnName: user.id == currentUser.id
                                    ? ""
                                    : isFriend
                                        ? appText(context).strFriends
                                        : appText(context).strSrcFollow,
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
