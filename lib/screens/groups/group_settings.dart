import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/groups/group_member_screen.dart';
import 'package:casarancha/screens/groups/provider/new_group_prov.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GroupSettings extends StatelessWidget {
  const GroupSettings({super.key, required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: 'Group Settings'),
      body: ListView(
        // padding: const EdgeInsets.all(15),
        children: [
          ListTile(
            onTap: () => Get.to(() => GroupMembersScreen(grp: group)),
            leading: SvgPicture.asset(icGroupMember),
            title: const TextWidget(
              text: 'Group members',
            ),
            horizontalTitleGap: 0,
            trailing: const Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: SvgPicture.asset(icGroupMember),
            title: const TextWidget(
              text: 'Banned from group users',
            ),
            horizontalTitleGap: 0,
            trailing: const Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: SvgPicture.asset(icGroupMember),
            title: const TextWidget(
              text: 'Banned from comments members',
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
                      isPublic: !group.isPublic,
                      groupId: group.id,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
