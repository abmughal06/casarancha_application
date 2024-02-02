import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/groups/banned_cmnt_users.dart';
import 'package:casarancha/screens/groups/banned_posts_users.dart';
import 'package:casarancha/screens/groups/banned_user_screen.dart';
import 'package:casarancha/screens/groups/group_admins.dart';
import 'package:casarancha/screens/groups/group_member_screen.dart';
import 'package:casarancha/screens/groups/provider/new_group_prov.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GroupSettings extends StatelessWidget {
  const GroupSettings({super.key, required this.grp});

  final GroupModel grp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: 'Group Settings'),
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
                leading: SvgPicture.asset(icGroupMember),
                title: Row(
                  children: [
                    const TextWidget(
                      text: 'Group members',
                    ),
                    widthBox(5.w),
                    Visibility(
                      visible: group.joinRequestIds.isNotEmpty &&
                          (group.creatorId == currentUserUID ||
                              group.adminIds.contains(currentUserUID)),
                      child: const CircleAvatar(
                        radius: 4,
                        backgroundColor: colorPrimaryA05,
                      ),
                    ),
                  ],
                ),
                horizontalTitleGap: 0,
                trailing: const Icon(Icons.navigate_next),
              ),
              ListTile(
                onTap: () => Get.to(() => BannedUserScreen(groupId: group.id)),
                leading: SvgPicture.asset(icGroupMember),
                title: const TextWidget(
                  text: 'Banned from group users',
                ),
                horizontalTitleGap: 0,
                trailing: const Icon(Icons.navigate_next),
              ),
              ListTile(
                onTap: () =>
                    Get.to(() => BannedFromCmntUsers(groupId: group.id)),
                leading: SvgPicture.asset(icGroupMember),
                title: const TextWidget(
                  text: 'Banned from comments members',
                ),
                horizontalTitleGap: 0,
                trailing: const Icon(Icons.navigate_next),
              ),
              ListTile(
                onTap: () =>
                    Get.to(() => BannedFromPostsUsers(groupId: group.id)),
                leading: SvgPicture.asset(icGroupMember),
                title: const TextWidget(
                  text: 'Banned from Posts members',
                ),
                horizontalTitleGap: 0,
                trailing: const Icon(Icons.navigate_next),
              ),
              ListTile(
                onTap: () => Get.to(() => GroupAdmins(groupId: group.id)),
                leading: SvgPicture.asset(icGroupMember),
                title: const TextWidget(
                  text: 'Group Admins',
                ),
                horizontalTitleGap: 0,
                trailing: const Icon(Icons.navigate_next),
              ),
              ListTile(
                leading: const Icon(Icons.public),
                title: const TextWidget(
                  text: 'Make group private',
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
