import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/groups/provider/new_group_prov.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_screen.dart';
import 'package:casarancha/utils/app_constants.dart';
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
                        color: group.creatorId == user.id
                            ? colorPrimaryA05
                            : colorF03,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextWidget(
                      text: group.creatorId == user.id ? 'Owner' : 'Admin',
                      color: group.creatorId == user.id ? colorWhite : color221,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : group.creatorId == currentUserUID ||
                        group.adminIds.contains(currentUserUID)
                    ? PopupMenuButton(
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
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}

class GroupBannedMemberTile extends StatelessWidget {
  const GroupBannedMemberTile({
    super.key,
    required this.user,
    required this.group,
    required this.onTapAction,
  });
  final UserModel user;
  final GroupModel group;
  final VoidCallback onTapAction;

  @override
  Widget build(BuildContext context) {
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
            TextButton(
              onPressed: onTapAction,
              child: TextWidget(
                text: 'Unban',
                color: colorPrimaryA05,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GroupAdminMemberTile extends StatelessWidget {
  const GroupAdminMemberTile({
    super.key,
    required this.user,
    required this.group,
    required this.onTapAction,
    required this.isCreator,
  });
  final UserModel user;
  final GroupModel group;
  final VoidCallback onTapAction;
  final bool isCreator;

  @override
  Widget build(BuildContext context) {
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
            isCreator
                ? Container(
                    margin: const EdgeInsets.only(right: 15),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: colorPrimaryA05,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextWidget(
                      text: 'Owner',
                      color: colorWhite,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return CustomAdaptiveAlertDialog(
                              title: 'Remove Admin?',
                              alertMsg:
                                  '''Are you sure you want to remove this user from admins?.''',
                              actiionBtnName: 'Remove',
                              onAction: onTapAction,
                            );
                          });
                    },
                    child: const TextWidget(
                      text: 'Remove',
                      color: colorPrimaryA05,
                    )),
          ],
        ),
      ),
    );
  }
}
