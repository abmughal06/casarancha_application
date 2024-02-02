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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> myTabs = [
      Tab(text: appText(context).strSrcPeople),
      Tab(text: appText(context).strSrcGroup),
      Tab(text: appText(context).strMentalHealth),
      Tab(text: appText(context).strSrcLocation),
    ];
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final search = Provider.of<SearchProvider>(context);
    return GhostScaffold(
      appBar: primaryAppbar(
        title: appText(context).strSearch,
        elevation: 0,
        leading: const GhostModeBtn(),
      ),
      body: DefaultTabController(
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
              indicatorColor: colorF03,
              indicatorPadding:
                  EdgeInsets.symmetric(vertical: 5.h, horizontal: 25.w),
              dividerColor: Colors.transparent,
              tabs: myTabs,
            ),
            heightBox(10.w),
            Expanded(
              child: TabBarView(
                children: [
                  /*people*/

                  StreamProvider.value(
                    value: DataProvider().allUsers(),
                    initialData: null,
                    catchError: (context, error) => null,
                    child: Consumer<List<UserModel>?>(
                      builder: (context, users, b) {
                        if (users == null) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }

                        if (searchController.text.isEmpty ||
                            searchController.text == '') {
                          var filterList = users
                              .where(
                                (element) =>
                                    element.id !=
                                        FirebaseAuth
                                            .instance.currentUser!.uid &&
                                    element.isVerified,
                              )
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
                                btnName: currentUser.followingsIds
                                        .contains(userSnap.id)
                                    ? appText(context).strUnFollow
                                    : appText(context).strSrcFollow,
                              );
                            },
                          );
                        }
                        var filterList = users
                            .where((element) =>
                                (element.name.toLowerCase().contains(
                                        searchController.text.toLowerCase()) ||
                                    element.username.toLowerCase().contains(
                                        searchController.text.toLowerCase())) &&
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
                              btnName: currentUser.followingsIds
                                      .contains(userSnap.id)
                                  ? appText(context).strUnFollow
                                  : appText(context).strSrcFollow,
                            );
                          },
                        );
                      },
                    ),
                  ),

                  /*group*/
                  StreamProvider.value(
                    value: DataProvider().allGroups(),
                    initialData: null,
                    catchError: (context, error) => null,
                    child: Consumer<List<GroupModel>?>(
                      builder: (context, groups, b) {
                        if (groups == null) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }

                        if (searchController.text.isEmpty ||
                            searchController.text == '') {
                          var filterList = groups
                              .where(
                                (element) =>
                                    element.creatorId !=
                                        FirebaseAuth
                                            .instance.currentUser!.uid &&
                                    !element.banFromCmntUsersIds
                                        .contains(currentUserUID) &&
                                    element.isVerified,
                              )
                              .toList();
                          return ListView.builder(
                            itemCount: filterList.length,
                            padding: const EdgeInsets.only(bottom: 100),
                            itemBuilder: (context, index) {
                              var groupSnap = filterList[index];

                              var isCurrentUserGroupMember = groupSnap.memberIds
                                  .contains(
                                      FirebaseAuth.instance.currentUser!.uid);
                              return GroupTile(
                                group: groupSnap,
                                ontapTrailing: () {
                                  if (!isCurrentUserGroupMember) {
                                    if (groupSnap.isPublic) {
                                      context
                                          .read<NewGroupProvider>()
                                          .addGroupMembers(
                                              id: FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              groupId: groupSnap.id);
                                    } else {
                                      context
                                          .read<NewGroupProvider>()
                                          .requestPrivateGroup(
                                              id: FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              groupId: groupSnap.id);
                                    }
                                  }
                                },
                                isSearchScreen: true,
                                btnText: groupSnap.isPublic
                                    ? isCurrentUserGroupMember
                                        ? appText(context).strJoined
                                        : appText(context).strSrcJoin
                                    : isCurrentUserGroupMember
                                        ? groupSnap.joinRequestIds
                                                .contains(currentUserUID)
                                            ? "Request Sent"
                                            : appText(context).strJoined
                                        : appText(context).strSrcJoin,
                              );
                            },
                          );
                        }
                        var filterList = groups
                            .where((element) =>
                                (element.name.toLowerCase().contains(
                                    searchController.text.toLowerCase())) &&
                                element.creatorId !=
                                    FirebaseAuth.instance.currentUser!.uid &&
                                !element.banFromCmntUsersIds
                                    .contains(currentUserUID))
                            .toList();

                        return ListView.builder(
                          itemCount: filterList.length,
                          padding: const EdgeInsets.only(bottom: 100),
                          itemBuilder: (context, index) {
                            var groupSnap = filterList[index];

                            var isCurrentUserGroupMember = groupSnap.memberIds
                                .contains(
                                    FirebaseAuth.instance.currentUser!.uid);
                            return GroupTile(
                              group: groupSnap,
                              ontapTrailing: () {
                                if (!isCurrentUserGroupMember) {
                                  if (groupSnap.isPublic) {
                                    context
                                        .read<NewGroupProvider>()
                                        .addGroupMembers(
                                            id: FirebaseAuth
                                                .instance.currentUser!.uid,
                                            groupId: groupSnap.id);
                                  } else {
                                    context
                                        .read<NewGroupProvider>()
                                        .requestPrivateGroup(
                                            id: FirebaseAuth
                                                .instance.currentUser!.uid,
                                            groupId: groupSnap.id);
                                  }
                                }
                              },
                              isSearchScreen: true,
                              btnText: groupSnap.isPublic
                                  ? isCurrentUserGroupMember
                                      ? appText(context).strJoined
                                      : appText(context).strSrcJoin
                                  : groupSnap.joinRequestIds
                                          .contains(currentUserUID)
                                      ? "Request Sent"
                                      : isCurrentUserGroupMember
                                          ? appText(context).strJoined
                                          : appText(context).strSrcJoin,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  //Mental Health
                  StreamProvider.value(
                    value: DataProvider().allUsers(),
                    initialData: null,
                    catchError: (context, error) => null,
                    child: StreamProvider.value(
                      value: DataProvider().allGroups(),
                      initialData: null,
                      catchError: (context, error) => null,
                      child: Consumer2<List<UserModel>?, List<GroupModel>?>(
                          builder: (context, users, groups, b) {
                        if (users == null || groups == null) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }

                        if (searchController.text.isEmpty ||
                            searchController.text == '') {
                          var groupsList = groups
                              .where((element) =>
                                  element.isVerified &&
                                  element.creatorId !=
                                      FirebaseAuth.instance.currentUser!.uid &&
                                  !element.banFromCmntUsersIds
                                      .contains(currentUserUID) &&
                                  element.isPublic)
                              .toList();

                          var usersList = users
                              .where((element) =>
                                  element.isVerified &&
                                  element.id !=
                                      FirebaseAuth.instance.currentUser!.uid)
                              .toList();
                          return ListView(
                            children: [
                              ListView.builder(
                                itemCount: groupsList.length,
                                padding: const EdgeInsets.only(bottom: 0),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var groupSnap = groupsList[index];

                                  var isCurrentUserGroupMember =
                                      groupSnap.memberIds.contains(FirebaseAuth
                                          .instance.currentUser!.uid);
                                  return GroupTile(
                                    group: groupSnap,
                                    ontapTrailing: () {
                                      if (!isCurrentUserGroupMember) {
                                        context
                                            .read<NewGroupProvider>()
                                            .addGroupMembers(
                                                id: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                groupId: groupSnap.id);
                                      }
                                    },
                                    isSearchScreen: true,
                                    btnText: isCurrentUserGroupMember
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
                                  var currentUser = users
                                      .where((element) =>
                                          element.id ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .first;
                                  return FollowFollowingTile(
                                    user: userSnap,
                                    ontapToggleFollow: () =>
                                        profileProvider.toggleFollowBtn(
                                      userModel: currentUser,
                                      appUserId: userSnap.id,
                                    ),
                                    btnName: currentUser.followingsIds
                                            .contains(userSnap.id)
                                        ? appText(context).strUnFollow
                                        : appText(context).strSrcFollow,
                                  );
                                },
                              )
                            ],
                          );
                        }
                        var groupsList = groups
                            .where((element) =>
                                element.isVerified &&
                                (element.name.toLowerCase().contains(
                                    searchController.text.toLowerCase())) &&
                                element.creatorId !=
                                    FirebaseAuth.instance.currentUser!.uid &&
                                element.isPublic)
                            .toList();

                        var usersList = users
                            .where((element) =>
                                element.isVerified &&
                                (element.name.toLowerCase().contains(
                                        searchController.text.toLowerCase()) ||
                                    element.username.toLowerCase().contains(
                                        searchController.text.toLowerCase())) &&
                                element.id !=
                                    FirebaseAuth.instance.currentUser!.uid)
                            .toList();

                        // var filterList = groupsList + usersList;

                        return ListView(
                          children: [
                            ListView.builder(
                              itemCount: groupsList.length,
                              padding: const EdgeInsets.only(bottom: 0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var groupSnap = groupsList[index];

                                var isCurrentUserGroupMember =
                                    groupSnap.memberIds.contains(
                                        FirebaseAuth.instance.currentUser!.uid);
                                return GroupTile(
                                  group: groupSnap,
                                  ontapTrailing: () {
                                    if (!isCurrentUserGroupMember) {
                                      context
                                          .read<NewGroupProvider>()
                                          .addGroupMembers(
                                              id: FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              groupId: groupSnap.id);
                                    }
                                  },
                                  isSearchScreen: true,
                                  btnText: isCurrentUserGroupMember
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
                                  btnName: currentUser.followingsIds
                                          .contains(userSnap.id)
                                      ? appText(context).strUnFollow
                                      : appText(context).strSrcFollow,
                                );
                              },
                            )
                          ],
                        );
                      }),
                    ),
                  ),
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
