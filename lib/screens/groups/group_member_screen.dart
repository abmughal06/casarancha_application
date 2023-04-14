import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/localization_text_strings.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:casarancha/widgets/app_user_tile.dart';
import 'package:casarancha/widgets/listView_users_whereIn_querry.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';

import '../../base/base_stateful_widget.dart';
import 'package:flutter/material.dart';
import '../../utils/app_constants.dart';

import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';

class GroupMemberScreen extends StatelessWidget {
  GroupMemberScreen({Key? key, required this.group}) : super(key: key);

  final GroupModel group;

  final ProfileScreenController profileScreenController =
      Get.find<ProfileScreenController>();

  final List<Widget> _myTabs = const [
    Tab(text: 'Members'),
    Tab(text: 'Join Requests'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: primaryAppbar(
          title: '${group.name} Members',
          elevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: commonTabBar(
                tabsList: _myTabs,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListViewUsersWithWhereInQuerry(
                    listOfIds: group.memberIds,
                    controllerTag: 'Members',
                  ),
                  ListViewUsersWithWhereInQuerry(
                    listOfIds: group.joinRequestIds,
                    controllerTag: 'JoinRequests',
                    isRequestedTile: true,
                    groupId: group.id,
                  ),
                ],
              ),
            ),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 20.w),
        //   child: CommonButton(
        //     height: 56.h,
        //     text: strAddMember,
        //     onTap: () {},
        //   ),
        // ),
      ),
    );
  }
}
