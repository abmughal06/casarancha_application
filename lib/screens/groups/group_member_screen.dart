import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/localization_text_strings.dart';
import 'package:casarancha/screens/groups/add_group_members.dart';
import 'package:casarancha/screens/groups/provider/new_group_prov.dart';
import 'package:casarancha/widgets/common_button.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/profle_screen_widgets/follow_following_tile.dart';
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
  const GroupMembersScreen({Key? key, required this.group}) : super(key: key);
  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    final users = context.watch<List<UserModel>?>();
    final prov = Provider.of<NewGroupProvider>(context);
    final isAdmin = (group.isPublic ||
        group.creatorId == FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
      appBar: primaryAppbar(title: '${group.name} Members', elevation: 0.2),
      body: DefaultTabController(
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
                    value: DataProvider().singleGroup(group.id),
                    initialData: null,
                    catchError: (context, error) => null,
                    child: Consumer<GroupModel?>(
                      builder: (context, value, child) {
                        if (users == null || value == null) {
                          return centerLoader();
                        }
                        var filterList = users
                            .where((element) =>
                                value.memberIds.contains(element.id))
                            .toList();

                        return ListView.builder(
                          itemCount: filterList.length,
                          itemBuilder: (context, index) {
                            return GroupMemberTile(
                              user: filterList[index],
                              ontapToggleFollow: () {
                                if (isAdmin) {
                                  prov.removeGroupMembers(
                                      id: filterList[index].id,
                                      groupId: group.id);
                                }
                              },
                              isAdmin: group.creatorId == filterList[index].id,
                              btnName: isAdmin ? strRemove : '',
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isAdmin
          ? CommonButton(
              onTap: () => Get.to(() => AddGroupMembers(group: group)),
              text: strAddMembers,
              height: 58.w,
              verticalOutMargin: 10.w,
              horizontalOutMargin: 20.w,
            )
          : null,
    );
  }
}
