import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/screens/groups/add_group_members.dart';
import 'package:casarancha/screens/groups/provider/new_group_prov.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:casarancha/widgets/common_button.dart';
import 'package:casarancha/widgets/group_widgets/group_member_tile.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/shared/alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_widget.dart';

class GroupMembersScreen extends StatelessWidget {
  const GroupMembersScreen({super.key, required this.grp});
  final GroupModel grp;

  @override
  Widget build(BuildContext context) {
    final isAdmin = (grp.isPublic ||
        grp.creatorId == FirebaseAuth.instance.currentUser!.uid);
    final grpProv = Provider.of<NewGroupProvider>(context);
    return Scaffold(
      appBar: primaryAppbar(
        title: '${grp.name.capitalize} ${appText(context).strMembers}',
        elevation: 0.2,
        actions: [
          grp.creatorId == currentUserUID
              ? widthBox(0)
              : TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return CustomAdaptiveAlertDialog(
                          actiionBtnName: appText(context).strLeave,
                          actionBtnColor: colorPrimaryA05,
                          alertMsg: 'Are you sure you want to leave the group?',
                          onAction: () {
                            grpProv.leaveGroup(
                              groupId: grp.id,
                              id: currentUserUID,
                            );
                          },
                        );
                      },
                    );
                  },
                  child: TextWidget(
                    text: appText(context).strLeave,
                    color: colorPrimaryA05,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )
        ],
      ),
      body: StreamProvider.value(
        value: DataProvider().singleGroup(grp.id),
        initialData: null,
        catchError: (context, error) => null,
        child: Consumer<GroupModel?>(builder: (context, group, b) {
          if (group == null) {
            return centerLoader();
          }

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  labelColor: colorPrimaryA05,
                  unselectedLabelColor: colorAA3,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                  indicatorColor: colorF03,
                  indicatorPadding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 70.w),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      text: appText(context).strMembers,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tab(
                          text: appText(context).strJoinRequest,
                        ),
                        if (group.joinRequestIds.isNotEmpty &&
                            (group.creatorId == currentUserUID ||
                                group.adminIds.contains(currentUserUID)))
                          Row(
                            children: [
                              widthBox(5.w),
                              const CircleAvatar(
                                radius: 4,
                                backgroundColor: colorPrimaryA05,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
                heightBox(15.h),
                Expanded(
                  child: TabBarView(
                    children: [
                      StreamProvider.value(
                        value: DataProvider().filterUserList(group.memberIds),
                        initialData: null,
                        catchError: (context, error) => null,
                        child: Consumer<List<UserModel>?>(
                          builder: (context, value, child) {
                            if (value == null) {
                              return centerLoader();
                            }

                            return ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                return GroupMemberTile(
                                  user: value[index],
                                  group: group,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      group.creatorId == currentUserUID ||
                              group.adminIds.contains(currentUserUID)
                          ? StreamProvider.value(
                              value: DataProvider()
                                  .filterUserList(group.joinRequestIds),
                              initialData: null,
                              catchError: (context, error) => null,
                              child: Consumer<List<UserModel>?>(
                                builder: (context, value, child) {
                                  if (value == null) {
                                    return centerLoader();
                                  }

                                  return ListView.builder(
                                    itemCount: value.length,
                                    itemBuilder: (context, index) {
                                      return GroupJoinRequestCard(
                                        user: value[index],
                                        group: group,
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: TextWidget(
                                  text: appText(context).strAlertNoJoinReq)),
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isAdmin
          ? CommonButton(
              onTap: () => Get.to(() => AddGroupMembers(group: grp)),
              text: appText(context).strAddMembers,
              height: 58.w,
              verticalOutMargin: 10.w,
              horizontalOutMargin: 20.w,
            )
          : null,
    );
  }
}
