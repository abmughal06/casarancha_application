import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/dashboard/ghost_mode_btn.dart';
import 'package:casarancha/screens/dashboard/ghost_scaffold.dart';
import 'package:casarancha/screens/groups/provider/new_group_prov.dart';
import 'package:casarancha/screens/profile/ProfileScreen/provider/profile_provider.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/group_widgets/group_tile.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/group_model.dart';
import '../../resources/color_resources.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/profle_screen_widgets/follow_following_tile.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> myTabs = [
      Tab(text: appText(context).all),
      Tab(text: appText(context).strSrcPeople),
      Tab(text: appText(context).strSrcGroup),
      Tab(text: appText(context).strMentalHealth),
      Tab(text: appText(context).strSrcLocation),
    ];

    final search = Provider.of<SearchProvider>(context);
    final currentUser = context.watch<UserModel?>();
    return GhostScaffold(
      appBar: primaryAppbar(
        title: appText(context).strSearch,
        elevation: 0,
        leading: const GhostModeBtn(),
      ),
      body: currentUser == null
          ? centerLoader()
          : DefaultTabController(
              length: myTabs.length,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: searchTextField(
                      context: context,
                      controller: searchController,
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
                    isScrollable: true,
                    indicatorColor: colorF03,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    indicatorPadding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                    dividerColor: Colors.transparent,
                    tabs: myTabs,
                  ),
                  heightBox(10.w),
                  Expanded(
                    child: TabBarView(
                      children: [
                        /*All*/
                        AllSearch(
                            cUser: currentUser,
                            isMentalHealth: false,
                            searchText: searchController.text),

                        /*people*/
                        PeopleSearch(
                            cUser: currentUser,
                            searchText: searchController.text),

                        /*group*/
                        GroupSearch(searchText: searchController.text),

                        //Mental Health
                        AllSearch(
                            cUser: currentUser,
                            isMentalHealth: true,
                            searchText: searchController.text),

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
  void searchText(value) {
    notifyListeners();
  }
}

class AllSearch extends StatelessWidget {
  const AllSearch(
      {super.key,
      required this.cUser,
      required this.searchText,
      required this.isMentalHealth});

  final UserModel cUser;
  final String searchText;
  final bool isMentalHealth;

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    return StreamProvider.value(
      value: DataProvider().searchUser(searchText),
      initialData: null,
      catchError: (context, error) => null,
      child: StreamProvider.value(
        value: DataProvider().searchGroups(searchText),
        initialData: null,
        catchError: (context, error) => null,
        child: Consumer2<List<UserModel>?, List<GroupModel>?>(
            builder: (context, users, groups, b) {
          if (users == null || groups == null) {
            return centerLoader();
          }

          var groupsList = isMentalHealth
              ? groups.where((element) => element.isVerified).toList()
              : groups;

          var usersList = isMentalHealth
              ? users.where((element) => element.isVerified).toList()
              : users;

          return ListView(
            children: [
              ListView.builder(
                itemCount: groupsList.length,
                padding: const EdgeInsets.only(bottom: 0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var groupSnap = groupsList[index];

                  var isCurrentUserGroupMember = groupSnap.memberIds
                      .contains(FirebaseAuth.instance.currentUser!.uid);
                  return GroupTile(
                    group: groupSnap,
                    ontapTrailing: () {
                      if (!isCurrentUserGroupMember) {
                        // print(groupSnap.isPublic);
                        if (groupSnap.isPublic) {
                          context.read<NewGroupProvider>().addGroupMembers(
                              id: FirebaseAuth.instance.currentUser!.uid,
                              groupId: groupSnap.id);
                        } else {
                          context.read<NewGroupProvider>().requestPrivateGroup(
                              id: FirebaseAuth.instance.currentUser!.uid,
                              groupId: groupSnap.id);
                        }
                      }
                    },
                    isSearchScreen: true,
                    btnText: groupSnap.isPublic
                        ? isCurrentUserGroupMember
                            ? appText(context).strJoined
                            : appText(context).strSrcJoin
                        : groupSnap.joinRequestIds.contains(currentUserUID)
                            ? appText(context).reqSent
                            : isCurrentUserGroupMember
                                ? appText(context).strJoined
                                : appText(context).strSrcJoin,
                  );
                },
              ),
              const Divider(),
              ListView.builder(
                itemCount: usersList.length,
                padding: const EdgeInsets.only(bottom: 100),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var userSnap = usersList[index];
                  return FollowFollowingTile(
                    user: userSnap,
                    ontapToggleFollow: () => profileProvider.toggleFollowBtn(
                      context,
                      userModel: cUser,
                      appUserId: userSnap.id,
                    ),
                    btnName: cUser.followingsIds.contains(userSnap.id)
                        ? appText(context).strUnFollow
                        : appText(context).strSrcFollow,
                  );
                },
              )
            ],
          );
        }),
      ),
    );
  }
}

class PeopleSearch extends StatelessWidget {
  const PeopleSearch(
      {super.key, required this.cUser, required this.searchText});
  final UserModel cUser;
  final String searchText;

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    return StreamProvider.value(
      value: DataProvider().searchUser(searchText),
      initialData: null,
      catchError: (context, error) => null,
      child: Consumer<List<UserModel>?>(
        builder: (context, users, b) {
          if (users == null) {
            return centerLoader();
          }

          return ListView.builder(
            itemCount: users.length,
            padding: const EdgeInsets.only(bottom: 100),
            itemBuilder: (context, index) {
              var userSnap = users[index];

              return FollowFollowingTile(
                user: userSnap,
                ontapToggleFollow: () => profileProvider.toggleFollowBtn(
                  context,
                  userModel: cUser,
                  appUserId: userSnap.id,
                ),
                btnName: cUser.followingsIds.contains(userSnap.id)
                    ? appText(context).strUnFollow
                    : appText(context).strSrcFollow,
              );
            },
          );
        },
      ),
    );
  }
}

class GroupSearch extends StatelessWidget {
  const GroupSearch({super.key, required this.searchText});
  final String searchText;

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: DataProvider().searchGroups(searchText),
      initialData: null,
      catchError: (context, error) => null,
      child: Consumer<List<GroupModel>?>(
        builder: (context, groups, b) {
          if (groups == null) {
            return centerLoader();
          }

          return ListView.builder(
            itemCount: groups.length,
            padding: const EdgeInsets.only(bottom: 100),
            itemBuilder: (context, index) {
              var groupSnap = groups[index];

              var isCurrentUserGroupMember = groupSnap.memberIds
                  .contains(FirebaseAuth.instance.currentUser!.uid);
              return GroupTile(
                group: groupSnap,
                ontapTrailing: () {
                  if (!isCurrentUserGroupMember) {
                    // print(groupSnap.isPublic);
                    if (groupSnap.isPublic) {
                      context.read<NewGroupProvider>().addGroupMembers(
                          id: FirebaseAuth.instance.currentUser!.uid,
                          groupId: groupSnap.id);
                    } else {
                      context.read<NewGroupProvider>().requestPrivateGroup(
                          id: FirebaseAuth.instance.currentUser!.uid,
                          groupId: groupSnap.id);
                    }
                  }
                },
                isSearchScreen: true,
                btnText: groupSnap.isPublic
                    ? isCurrentUserGroupMember
                        ? appText(context).strJoined
                        : appText(context).strSrcJoin
                    : groupSnap.joinRequestIds.contains(currentUserUID)
                        ? appText(context).reqSent
                        : isCurrentUserGroupMember
                            ? appText(context).strJoined
                            : appText(context).strSrcJoin,
              );
            },
          );
        },
      ),
    );
  }
}
