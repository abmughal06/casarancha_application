import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/group_widgets/group_member_tile.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/shared/alert_text.dart';
import 'package:casarancha/widgets/shared/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BannedUserScreen extends StatelessWidget {
  const BannedUserScreen({super.key, required this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: 'Banned User Screens'),
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
              value: DataProvider().filterUserList(group.banUsersIds),
              initialData: null,
              catchError: (context, error) => null,
              child: Consumer<List<UserModel>?>(
                builder: (_, users, b) {
                  if (users == null) {
                    return const ChatShimmerList();
                  }
                  if (users.isEmpty) {
                    return const AlertText(text: 'No User is banned yet');
                  }
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (_, index) {
                      return GroupBannedMemberTile(
                          isCommentBan: false,
                          user: users[index],
                          group: group);
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
