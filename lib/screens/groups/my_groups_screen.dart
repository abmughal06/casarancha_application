import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/screens/groups/create_group_screen.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../widgets/group_widgets/group_tile.dart';
import '../../widgets/primary_appbar.dart';
import '../dashboard/ghost_mode_btn.dart';
import '../dashboard/ghost_scaffold.dart';
import 'group_post_screen.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserModel>();
    return GhostScaffold(
      appBar: primaryAppbar(
        title: 'My Groups',
        elevation: 0.1,
        leading: const GhostModeBtn(),
      ),
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
                  text: 'My Groups',
                ),
                Tab(
                  text: 'My Created Groups',
                ),
              ],
            ),
            heightBox(15.h),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Consumer<List<GroupModel>?>(
                    builder: (context, groups, b) {
                      if (groups == null) {
                        return centerLoader();
                      }
                      final filterList = groups
                          .where((element) =>
                              element.creatorId !=
                              FirebaseAuth.instance.currentUser!.uid)
                          .toList();
                      return ListView.builder(
                        itemCount: filterList.length,
                        itemBuilder: (context, index) {
                          if (filterList.isEmpty) {
                            return const Center(
                              child: TextWidget(
                                text: "You didn't join any groups yet",
                              ),
                            );
                          }
                          return GroupTile(
                            ontap: () => Get.to(() =>
                                GroupPostScreen(group: filterList[index])),
                            group: filterList[index],
                          );
                        },
                      );
                    },
                  ),
                  Stack(
                    children: [
                      Consumer<List<GroupModel>?>(
                        builder: (context, groups, b) {
                          if (groups == null) {
                            return centerLoader();
                          }
                          final filterList = groups
                              .where((element) =>
                                  element.creatorId ==
                                  FirebaseAuth.instance.currentUser!.uid)
                              .toList();
                          return ListView.builder(
                            itemCount: filterList.length,
                            itemBuilder: (context, index) {
                              if (filterList.isEmpty) {
                                return const Center(
                                  child: TextWidget(
                                    text: "You didn't create any groups yet",
                                  ),
                                );
                              }
                              return GroupTile(
                                group: filterList[index],
                                ontap: () => Get.to(() =>
                                    GroupPostScreen(group: filterList[index])),
                              );
                            },
                          );
                        },
                      ),
                      Positioned(
                        right: 20.w,
                        bottom: 90.h,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() =>
                                CreateGroupScreen(currentUser: currentUser));
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.h),
                            decoration: const BoxDecoration(
                                color: colorPrimaryA05, shape: BoxShape.circle),
                            child: Icon(
                              Icons.add,
                              size: 27.sp,
                              color: colorWhite,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
