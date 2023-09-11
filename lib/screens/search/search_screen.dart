import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/dashboard/ghost_mode_btn.dart';
import 'package:casarancha/screens/dashboard/ghost_scaffold.dart';
import 'package:casarancha/screens/profile/ProfileScreen/provider/profile_provider.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../resources/color_resources.dart';
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

  late TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final search = Provider.of<SearchProvider>(context);
    return GhostScaffold(
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
                controller: search.searchController,
                onChange: (value) {
                  search.searchText(value);
                },
              ),
            ),
            TabBar(
              labelColor: colorPrimaryA05,
              unselectedLabelColor: colorAA3,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
              indicatorColor: colorF03,
              indicatorPadding:
                  EdgeInsets.symmetric(vertical: 5.h, horizontal: 25.w),
              dividerColor: Colors.transparent,
              tabs: _myTabs,
            ),
            heightBox(10.w),
            Expanded(
              child: TabBarView(
                children: [
                  /*people*/

                  Consumer<List<UserModel>?>(
                    builder: (context, users, b) {
                      if (users == null) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }

                      if (search.searchController.text.isEmpty ||
                          search.searchController.text == '') {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: TextWidget(
                              textAlign: TextAlign.center,
                              text:
                                  "Write user name above to search and follow them",
                            ),
                          ),
                        );
                      }
                      var filterList = users
                          .where((element) =>
                              (element.name.toLowerCase().contains(search
                                      .searchController.text
                                      .toLowerCase()) ||
                                  element.username.toLowerCase().contains(search
                                      .searchController.text
                                      .toLowerCase())) &&
                              element.id !=
                                  FirebaseAuth.instance.currentUser!.uid)
                          .toList();

                      return ListView.builder(
                        itemCount: filterList.length,
                        padding: const EdgeInsets.only(bottom: 100),
                        itemBuilder: (context, index) {
                          var userSnap = filterList[index];
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
                        },
                      );
                    },
                  ),

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

class SearchProvider extends ChangeNotifier {
  late TextEditingController searchController;

  SearchProvider() {
    searchController = TextEditingController();
  }

  void searchText(value) {
    notifyListeners();
  }
}
