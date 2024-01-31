import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/groups/provider/new_group_prov.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/group_widgets/group_member_tile.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/shared/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupAdmins extends StatelessWidget {
  const GroupAdmins({super.key, required this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<NewGroupProvider>(context);
    return Scaffold(
      appBar: primaryAppbar(title: 'Group Admins'),
      body: StreamProvider.value(
        value: DataProvider().singleGroup(groupId),
        initialData: null,
        catchError: (context, error) => null,
        child: Consumer<GroupModel?>(
          builder: (context, group, child) {
            if (group == null) {
              return centerLoader();
            }
            return StreamProvider.value(
              value: DataProvider()
                  .filterUserList(group.adminIds + [group.creatorId]),
              initialData: null,
              catchError: (context, error) => null,
              child: Consumer<List<UserModel>?>(
                builder: (_, users, b) {
                  if (users == null) {
                    return const ChatShimmerList();
                  }
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (_, index) {
                      return GroupAdminMemberTile(
                        onTapAction: () {
                          prov.removeGroupAdmins(
                              id: users[index].id, groupId: groupId);
                        },
                        isCreator: group.creatorId == users[index].id,
                        user: users[index],
                        group: group,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
