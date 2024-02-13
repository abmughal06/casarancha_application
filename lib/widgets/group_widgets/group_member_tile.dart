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
                    Row(
                      children: [
                        TextWidget(
                          text: user.name,
                          fontSize: 12.sp,
                          color: const Color(0xff5f5f5f),
                          fontWeight: FontWeight.w400,
                          textOverflow: TextOverflow.visible,
                        ),
                        widthBox(5.w),
                        if ((group.creatorId == currentUserUID ||
                                group.adminIds.contains(currentUserUID)) &&
                            (group.banUsersIds.contains(user.id) ||
                                group.banFromCmntUsersIds.contains(user.id) ||
                                group.banFromPostUsersIds.contains(user.id)))
                          Container(
                            margin: const EdgeInsets.only(right: 15),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 3),
                            decoration: BoxDecoration(
                                color: colorPrimaryA05,
                                borderRadius: BorderRadius.circular(5)),
                            child: TextWidget(
                              text: appText(context).banned,
                              color: colorWhite,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                      ],
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
                      text: group.creatorId == user.id
                          ? appText(context).strOwner
                          : appText(context).strAdmin,
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
                                      title: appText(context).strRemoveUser,
                                      alertMsg: appText(context)
                                          .strRemoveUserFromGroup,
                                      actiionBtnName:
                                          appText(context).strRemove,
                                      onAction: () {
                                        prov.removeGroupMembers(
                                            id: user.id, groupId: group.id);
                                        Get.back();
                                      },
                                    );
                                  });
                            },
                            child: TextWidget(
                              text: appText(context).strRemove,
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
                                          title:
                                              appText(context).alertTitileUnban,
                                          alertMsg:
                                              appText(context).alertMsgUnban,
                                          actiionBtnName:
                                              appText(context).strUnban,
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
                                        title:
                                            appText(context).alertBanUserTitle,
                                        alertMsg:
                                            appText(context).alertBanUserMsg,
                                        actiionBtnName: appText(context).strBan,
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
                                  ? appText(context).strUnban
                                  : appText(context).strBan,
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
                                    title:
                                        appText(context).alertBanPostingTitle,
                                    alertMsg:
                                        appText(context).alertBanPostinMsg,
                                    actiionBtnName: appText(context).strYes,
                                    actionBtnColor: colorPrimaryA05,
                                    onAction: () {
                                      Get.back();
                                      if (group.banFromPostUsersIds
                                          .contains(user.id)) {
                                        prov.unBanUsersFromPostsGroup(
                                            id: user.id, groupId: group.id);
                                      } else {
                                        prov.banUsersFromPostsGroup(
                                            id: user.id, groupId: group.id);
                                      }
                                    },
                                  );
                                },
                              );
                            },
                            enabled: !group.banUsersIds.contains(user.id),
                            child: TextWidget(
                              text: !group.banFromPostUsersIds.contains(user.id)
                                  ? appText(context).strbanPosting
                                  : appText(context).strunbanPosting,
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
                                    title:
                                        appText(context).alertBanCommentsTile,
                                    alertMsg:
                                        appText(context).alertBanCommentsMsg,
                                    actiionBtnName: appText(context).strYes,
                                    actionBtnColor: colorPrimaryA05,
                                    onAction: () {
                                      Get.back();
                                      if (group.banFromCmntUsersIds
                                          .contains(user.id)) {
                                        prov.unBanUserFromComments(
                                            id: user.id, groupId: group.id);
                                      } else {
                                        prov.banUserFromComments(
                                            id: user.id, groupId: group.id);
                                      }
                                    },
                                  );
                                },
                              );
                            },
                            enabled: !group.banUsersIds.contains(user.id),
                            child: TextWidget(
                              text: group.banFromCmntUsersIds.contains(user.id)
                                  ? appText(context).strUnBanComment
                                  : appText(context).strBanFromComment,
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
                                    title: appText(context).strMakeAdmin,
                                    alertMsg:
                                        appText(context).strConfirmationAdmin,
                                    actiionBtnName: appText(context).strYes,
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
                              text: appText(context).strMakeAdminn,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: color221,
                            ),
                          ),
                        ],
                      )
                    : Container()
          ],
        ),
      ),
    );
  }
}

class GroupJoinRequestCard extends StatelessWidget {
  const GroupJoinRequestCard(
      {super.key, required this.user, required this.group});
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    heightBox(10.h),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => CustomAdaptiveAlertDialog(
                                alertMsg:
                                    appText(context).strConfirmationRequest,
                                actiionBtnName: appText(context).strYes,
                                onAction: () {
                                  Get.back();
                                  prov.acceptMembers(
                                      id: user.id, groupId: group.id);
                                },
                                actionBtnColor: color221,
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xffFBCA03),
                              borderRadius: BorderRadius.circular(7.sp),
                            ),
                            child: TextWidget(
                              text: appText(context).strAccept,
                              fontSize: 12.sp,
                              color: color13F,
                              fontWeight: FontWeight.w600,
                              textOverflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        widthBox(10.w),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => CustomAdaptiveAlertDialog(
                                alertMsg: appText(context).strDeclineRequest,
                                actiionBtnName: appText(context).strYes,
                                onAction: () {
                                  prov.removeRequestPrivateGroup(
                                      id: user.id, groupId: group.id);
                                },
                                actionBtnColor: colorPrimaryA05,
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: colorAA3,
                              borderRadius: BorderRadius.circular(7.sp),
                            ),
                            child: TextWidget(
                              text: appText(context).strDecline,
                              fontSize: 12.sp,
                              color: colorWhite,
                              fontWeight: FontWeight.w600,
                              textOverflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                text: appText(context).strUnban,
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
                      text: appText(context).strOwner,
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
                              title: appText(context).strRemoveAdmin,
                              alertMsg:
                                  appText(context).strConfirmationRemoveAdmin,
                              actiionBtnName: appText(context).strRemove,
                              onAction: onTapAction,
                            );
                          });
                    },
                    child: TextWidget(
                      text: appText(context).strRemove,
                      color: colorPrimaryA05,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
