import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/localization_text_strings.dart';
import 'package:casarancha/screens/groups/add_group_members.dart';
import 'package:casarancha/widgets/common_button.dart';
import 'package:casarancha/widgets/group_widgets/group_member_tile.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
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
    return Scaffold(
      appBar: primaryAppbar(title: '${grp.name} Members', elevation: 0.2),
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
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 60.w),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(
                      text: strMembers,
                    ),
                    Tab(
                      text: strJoinRequest,
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
                      const Center(child: TextWidget(text: strAlertNoJoinReq)),
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
              text: strAddMembers,
              height: 58.w,
              verticalOutMargin: 10.w,
              horizontalOutMargin: 20.w,
            )
          : null,
    );
  }
}
