import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/groups/banned_cmnt_users.dart';
import 'package:casarancha/screens/groups/banned_posts_users.dart';
import 'package:casarancha/screens/groups/banned_user_screen.dart';
import 'package:casarancha/screens/groups/group_admins.dart';
import 'package:casarancha/screens/groups/group_member_screen.dart';
import 'package:casarancha/screens/groups/group_notification_badge.dart';
import 'package:casarancha/screens/groups/provider/new_group_prov.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GroupSettings extends StatelessWidget {
  const GroupSettings({super.key, required this.grp});

  final GroupModel grp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: appText(context).groupSetting),
      body: StreamProvider.value(
        value: DataProvider().singleGroup(grp.id),
        initialData: null,
        catchError: (context, error) => null,
        child: Consumer<GroupModel?>(builder: (context, group, b) {
          if (group == null) {
            return centerLoader();
          }
          return ListView(
            children: [
              ListTile(
                onTap: () => Get.to(() => GroupMembersScreen(grp: group)),
                leading: GroupNotificationBadge(
                    groupId: grp.id, child: SvgPicture.asset(icGroupMember)),
                title: TextWidget(
                  text: appText(context).groupMembers,
                ),
                horizontalTitleGap: 0,
                trailing: const Icon(Icons.navigate_next),
              ),
              ListTile(
                onTap: () => Get.to(() => BannedUserScreen(groupId: group.id)),
                leading: SvgPicture.asset(icGroupMember),
                title: TextWidget(
                  text: appText(context).btnGrpBan,
                ),
                horizontalTitleGap: 0,
                trailing: const Icon(Icons.navigate_next),
              ),
              ListTile(
                onTap: () =>
                    Get.to(() => BannedFromCmntUsers(groupId: group.id)),
                leading: SvgPicture.asset(icGroupMember),
                title: TextWidget(
                  text: appText(context).btnGrpCommentBan,
                ),
                horizontalTitleGap: 0,
                trailing: const Icon(Icons.navigate_next),
              ),
              ListTile(
                onTap: () =>
                    Get.to(() => BannedFromPostsUsers(groupId: group.id)),
                leading: SvgPicture.asset(icGroupMember),
                title: TextWidget(
                  text: appText(context).btnGrpPostBan,
                ),
                horizontalTitleGap: 0,
                trailing: const Icon(Icons.navigate_next),
              ),
              ListTile(
                onTap: () => Get.to(() => GroupAdmins(groupId: group.id)),
                leading: SvgPicture.asset(icGroupMember),
                title: TextWidget(
                  text: appText(context).btnGrpAdmins,
                ),
                horizontalTitleGap: 0,
                trailing: const Icon(Icons.navigate_next),
              ),
              ListTile(
                leading: const Icon(Icons.public),
                title: TextWidget(
                  text: appText(context).makePrivate,
                ),
                horizontalTitleGap: 0,
                trailing: Switch(
                  value: !group.isPublic,
                  onChanged: (v) {
                    context.read<NewGroupProvider>().togglePrivate(
                          isPublic: group.isPublic,
                          groupId: group.id,
                        );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
