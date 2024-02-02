import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/screens/groups/provider/new_group_prov.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/group_model.dart';
import '../../models/user_model.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/profle_screen_widgets/follow_following_tile.dart';
import '../search/search_screen.dart';

class AddGroupMembers extends StatelessWidget {
  AddGroupMembers({super.key, required this.group});
  final GroupModel group;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final search = Provider.of<SearchProvider>(context);
    final prov = Provider.of<NewGroupProvider>(context);
    final currentUser = context.watch<UserModel?>();

    return Scaffold(
      appBar: primaryAppbar(
          title: 'Add Memmbers in ${group.name}', elevation: 0.2.w),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: searchTextField(
              context: context,
              controller: searchController,
              onChange: (value) {
                search.searchText(value);
              },
            ),
          ),
          currentUser == null
              ? centerLoader()
              : Expanded(
                  child: StreamProvider.value(
                    value: group.isPublic
                        ? DataProvider().allUsers()
                        : DataProvider().filterUserList(
                            currentUser.followersIds +
                                currentUser.followingsIds),
                    initialData: null,
                    catchError: (context, error) => null,
                    child: Consumer<List<UserModel>?>(
                      builder: (context, user, b) {
                        if (user == null) {
                          return centerLoader();
                        }

                        if (searchController.text.isEmpty ||
                            searchController.text == '') {
                          return ListView.builder(
                            itemCount: user.length,
                            padding: const EdgeInsets.only(bottom: 50),
                            itemBuilder: (context, index) {
                              var userSnap = user[index];

                              return StreamProvider.value(
                                value: DataProvider().singleGroup(group.id),
                                initialData: null,
                                catchError: (context, error) => null,
                                child: Consumer<GroupModel?>(
                                    builder: (context, grp, b) {
                                  if (grp == null) {
                                    return const SizedBox();
                                  }
                                  return FollowFollowingTile(
                                    user: userSnap,
                                    ontapToggleFollow: () {
                                      if (grp.memberIds.contains(userSnap.id)) {
                                        prov.removeGroupMembers(
                                            id: userSnap.id, groupId: grp.id);
                                      } else {
                                        prov.addGroupMembers(
                                            id: userSnap.id, groupId: grp.id);
                                      }
                                    },
                                    btnName: grp.memberIds.contains(userSnap.id)
                                        ? appText(context).strRemove
                                        : appText(context).strAdd,
                                  );
                                }),
                              );
                            },
                          );
                        }

                        var filterList = user
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

                            return StreamProvider.value(
                              value: DataProvider().singleGroup(group.id),
                              initialData: null,
                              catchError: (context, error) => null,
                              child: Consumer<GroupModel?>(
                                  builder: (context, grp, b) {
                                if (grp == null) {
                                  return const SizedBox();
                                }
                                return FollowFollowingTile(
                                  user: userSnap,
                                  ontapToggleFollow: () {
                                    if (grp.memberIds.contains(userSnap.id)) {
                                      prov.removeGroupMembers(
                                          id: userSnap.id, groupId: grp.id);
                                    } else {
                                      prov.addGroupMembers(
                                          id: userSnap.id, groupId: grp.id);
                                    }
                                  },
                                  btnName: grp.memberIds.contains(userSnap.id)
                                      ? appText(context).strRemove
                                      : appText(context).strAdd,
                                );
                              }),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
