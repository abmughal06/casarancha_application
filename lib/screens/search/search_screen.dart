import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/dashboard/ghost_mode_btn.dart';
import 'package:casarancha/screens/profile/ProfileScreen/provider/profile_provider.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../widgets/common_widgets.dart';
import '../../widgets/profle_screen_widgets/follow_following_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Widget> _myTabs = const [
    Tab(text: 'People'),
    Tab(text: 'Groups'),
    Tab(text: 'Location'),
  ];

  late TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  bool compareStrings(String string1, String string2) {
    int matchCount = 0;

    // Loop through each character of the first string
    for (int i = 0; i < string1.length; i++) {
      // Loop through each character of the second string
      for (int j = 0; j < string2.length; j++) {
        // If the characters match, increment the match count
        if (string1[i] == string2[j]) {
          matchCount++;
        }
      }
    }
    // Return true if two or more characters match
    return matchCount >= 2;
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: primaryAppbar(
        title: 'Search',
        elevation: 0,
        leading: const GhostModeBtn(),
      ),
      body: DefaultTabController(
        length: _myTabs.length,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: searchTextField(
                context: context,
                controller: searchController,
                onChange: (value) {
                  // setState(() {});
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: commonTabBar(tabsList: _myTabs),
            ),
            heightBox(10.w),
            Expanded(
              child: TabBarView(
                children: [
                  /*people*/

                  Consumer<List<UserModel>?>(builder: (context, users, b) {
                    if (users == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: users.length,
                      padding: const EdgeInsets.only(bottom: 100),
                      itemBuilder: (context, index) {
                        if (compareStrings(
                                users[index].name, searchController.text) &&
                            users[index].id !=
                                FirebaseAuth.instance.currentUser!.uid) {
                          var userSnap = users[index];
                          var currentUser = users
                              .where((element) =>
                                  element.id ==
                                  FirebaseAuth.instance.currentUser!.uid)
                              .first;
                          return FollowFollowingTile(
                            user: userSnap,
                            ontapToggleFollow: () =>
                                profileProvider.toggleFollowBtn(
                              userModel: currentUser,
                              appUserId: userSnap.id,
                            ),
                            btnName:
                                currentUser.followingsIds.contains(userSnap.id)
                                    ? "Unfollow"
                                    : "Follow",
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  }),

                  /*group*/
                  Container(),
                  /*location*/
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
