import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:casarancha/widgets/primary_tabbar.dart';
import 'package:casarancha/widgets/profle_screen_widgets/follow_following_tile.dart';
import 'package:casarancha/widgets/text_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            //tab 1 followers

            Consumer<List<UserModel>?>(
              builder: (context, users, b) {
                if (users == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  var filterList = users
                      .where((element) =>
                          currentUser!.followersIds.contains(element.id))
                      .toList();
                  if (filterList.isEmpty) {
                    return const Center(
                      child: TextWidget(
                        text: "You don't have any followers right now",
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
                        ontapToggleFollow: () {},
                        btnName: isFriend ? "Friends" : "Follow",
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
                  return const Center(child: CircularProgressIndicator());
                } else {
                  var filterList = users
                      .where((element) =>
                          currentUser!.followingsIds.contains(element.id))
                      .toList();
                  if (filterList.isEmpty) {
                    return const Center(
                      child: TextWidget(
                        text: "Start following people to see them here.",
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (context, index) {
                      final user = filterList[index];
                      return FollowFollowingTile(
                        user: user,
                        ontapToggleFollow: () {},
                        btnName: "Remove",
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
                  return const Center(child: CircularProgressIndicator());
                } else {
                  var appUser =
                      users.where((element) => element.id == appUserid).first;
                  var filterList = users
                      .where((element) =>
                          appUser.followersIds.contains(element.id))
                      .toList();
                  if (filterList.isEmpty) {
                    return const Center(
                      child: TextWidget(
                        text: "This user didn't have any followers",
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (context, index) {
                      final user = filterList[index];
                      final isFriend = appUser.followingsIds.contains(user.id);
                      return FollowFollowingTile(
                        user: user,
                        ontapToggleFollow: () {},
                        btnName: isFriend ? "Friends" : "Follow",
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
                  return const Center(child: CircularProgressIndicator());
                } else {
                  var appUser =
                      users.where((element) => element.id == appUserid).first;
                  var filterList = users
                      .where((element) =>
                          appUser.followingsIds.contains(element.id))
                      .toList();
                  if (filterList.isEmpty) {
                    return const Center(
                      child: TextWidget(
                        text: "This user didn't follow anyone yet",
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (context, index) {
                      final user = filterList[index];
                      return FollowFollowingTile(
                        user: user,
                        ontapToggleFollow: () {},
                        btnName: "Remove",
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
