import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/groups/provider/new_group_prov.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/group_widgets/group_member_tile.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/shared/alert_dialog.dart';
import 'package:casarancha/widgets/shared/alert_text.dart';
import 'package:casarancha/widgets/shared/shimmer_list.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BannedUserScreen extends StatelessWidget {
  const BannedUserScreen({super.key, required this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context) {
    final grpProv = Provider.of<NewGroupProvider>(context);
    return Scaffold(
      appBar: primaryAppbar(title: appText(context).grpUsersBan),
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
                    return AlertText(text: appText(context).alertgrpNoBan);
                  }
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (_, index) {
                      return GroupBannedMemberTile(
                        user: users[index],
                        group: group,
                        onTapAction: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return CustomAdaptiveAlertDialog(
                                title: appText(context).alertTitileUnban,
                                alertMsg: appText(context).alertMsgUserUnban,
                                actiionBtnName: appText(context).unban,
                                onAction: () {
                                  grpProv.unBanUserFromGroup(
                                      groupId: groupId, id: users[index].id);
                                  Get.back();
                                },
                              );
                            },
                          );
                        },
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
