import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/profile/AppUser/app_user_screen.dart';
import '../common_widgets.dart';
import '../profile_pic.dart';
import '../text_widget.dart';

class FollowFollowingTile extends StatelessWidget {
  const FollowFollowingTile(
      {super.key,
      required this.user,
      required this.ontapToggleFollow,
      required this.btnName});
  final UserModel user;
  final VoidCallback ontapToggleFollow;
  final String btnName;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(15),
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
            TextWidget(
              onTap: ontapToggleFollow,
              text: btnName,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: colorPrimaryA05,
            ),
          ],
        ),
      ),
    );
  }
}

class GroupMemberTile extends StatelessWidget {
  const GroupMemberTile(
      {super.key,
      required this.user,
      required this.ontapToggleFollow,
      required this.btnName,
      required this.isAdmin});
  final UserModel user;
  final VoidCallback ontapToggleFollow;
  final String btnName;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(15),
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
            isAdmin
                ? Container(
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
                : TextWidget(
                    onTap: ontapToggleFollow,
                    text: btnName,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: colorPrimaryA05,
                  ),
          ],
        ),
      ),
    );
  }
}
