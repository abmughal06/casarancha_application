import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/groups/provider/new_group_prov.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_screen.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/profile_pic.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../shared/alert_dialog.dart';

class GroupMemberTile extends StatelessWidget {
  const GroupMemberTile({super.key, required this.user, required this.group});
  final UserModel user;
  // final bool isAdmin;
  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<NewGroupProvider>(context);

    return Card(
      elevation: 0.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    navigateToAppUserScreen(user.id, context);
                  },
                  child: ProfilePic(
                    pic: user.imageStr,
                    heightAndWidth: 50.h,
                  ),
                ),
                widthBox(12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        navigateToAppUserScreen(user.id, context);
                      },
                      child: Row(
                        children: [
                          TextWidget(
                              text: user.username,
                              fontSize: 14.sp,
                              color: const Color(0xff212121),
                              fontWeight: FontWeight.w600),
                          widthBox(4.w),
                          if (user.isVerified) SvgPicture.asset(icVerifyBadge),
                        ],
                      ),
                    ),
                    heightBox(2.h),
                    TextWidget(
                      text: user.name,
                      fontSize: 12.sp,
                      color: const Color(0xff5f5f5f),
                      fontWeight: FontWeight.w400,
                      textOverflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ],
            ),
            group.creatorId == user.id || group.adminIds.contains(user.id)
                ? Container(
                    margin: const EdgeInsets.only(right: 15),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: colorF03,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextWidget(
                      text: 'Admin',
                      color: color221,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    padding: EdgeInsets.zero,
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return CustomAdaptiveAlertDialog(
                                  title: 'Remove User?',
                                  alertMsg:
                                      '''Are you sure you want to remove this user from group?.''',
                                  actiionBtnName: 'Remove',
                                  onAction: () {
                                    prov.removeGroupMembers(
                                        id: user.id, groupId: group.id);
                                    Get.back();
                                  },
                                );
                              });
                        },
                        child: TextWidget(
                          text: 'Remove',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: colorPrimaryA05,
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          if (group.banUsersIds.contains(user.id)) {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return CustomAdaptiveAlertDialog(
                                      title: 'Unban User?',
                                      alertMsg:
                                          '''Are you sure you want to unban this user?.''',
                                      actiionBtnName: 'Unban',
                                      onAction: () {
                                        prov.unBanUserFromGroup(
                                            id: user.id, groupId: group.id);

                                        Get.back();
                                      });
                                });
                          } else {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return CustomAdaptiveAlertDialog(
                                    title: 'Ban User?',
                                    alertMsg:
                                        '''Are you sure you want to ban this user from group?.''',
                                    actiionBtnName: 'Ban',
                                    onAction: () {
                                      prov.banUserFromGroup(
                                          id: user.id, groupId: group.id);
                                      Get.back();
                                    },
                                  );
                                });
                          }
                        },
                        child: TextWidget(
                          text: group.banUsersIds.contains(user.id)
                              ? 'Unban User'
                              : 'Ban user',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: colorPrimaryA05,
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return CustomAdaptiveAlertDialog(
                                title: 'Make admin?',
                                alertMsg:
                                    '''Are you sure you want to make this user admin of group?.''',
                                actiionBtnName: 'Yes',
                                actionBtnColor: Colors.black,
                                onAction: () {
                                  Get.back();
                                  prov.addGroupAdmins(
                                      id: user.id, groupId: group.id);
                                },
                              );
                            },
                          );
                        },
                        enabled: !group.banUsersIds.contains(user.id),
                        child: TextWidget(
                          text: 'Make Admin',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: color221,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
