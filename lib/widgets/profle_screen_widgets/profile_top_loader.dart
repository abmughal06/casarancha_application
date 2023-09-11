import 'package:casarancha/screens/dashboard/ghost_mode_btn.dart';
import 'package:casarancha/widgets/profile_pic.dart';
import 'package:casarancha/widgets/profle_screen_widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../screens/profile/follower_following_screen.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

Widget postFollowCount({required String count, required String strText}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      TextWidget(
        text: count,
        color: color13F,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
      ),
      heightBox(3.h),
      TextWidget(
        text: strText,
        color: colorAA3,
        fontWeight: FontWeight.w500,
        fontSize: 12.sp,
      ),
    ],
  );
}

Widget postStoriesBtn(
    {required String icon, required String text, required bool isSelected}) {
  return Expanded(
    child: SizedBox(
      height: 47.h,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon),
            widthBox(12.w),
            TextWidget(
              text: text,
              color: isSelected ? colorPrimaryA05 : colorAA3,
              fontSize: 14.sp,
            ),
          ],
        ),
      ),
    ),
  );
}

class ProfileTopLoader extends StatelessWidget {
  const ProfileTopLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  bottomSheetProfile(context);
                },
                icon: Image.asset(
                  imgProfileOption,
                  height: 35.h,
                  width: 35.w,
                ),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: colorPrimaryA05, width: 1.5),
              shape: BoxShape.circle),
          height: 90.h,
          width: 90.h,
          alignment: Alignment.center,
          child: const AspectRatio(
              aspectRatio: 1 / 1,
              child: CircleAvatar(
                backgroundColor: Colors.red,
              )),
        ),
        heightBox(15.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              text: "----",
              color: color13F,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
            widthBox(6.w),
          ],
        ),
        TextWidget(
          text: "-----",
          color: colorAA3,
          fontSize: 12.sp,
        ),
        heightBox(12.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            postFollowCount(count: "0", strText: strProfilePost),
            verticalLine(height: 24.h, horizontalMargin: 30.w),
            postFollowCount(count: '0', strText: strProfileFollowers),
            verticalLine(height: 24.h, horizontalMargin: 30.w),
            postFollowCount(count: '0', strText: strProfileFollowing),
          ],
        ),
        heightBox(14.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 27.w),
          child: TextWidget(
            text: "------",
            textAlign: TextAlign.center,
            color: color55F,
            fontSize: 12.sp,
          ),
        ),
        heightBox(20.h),
      ],
    );
  }
}

class ProfileTop extends StatelessWidget {
  const ProfileTop({Key? key, this.user, required this.postFollowCout})
      : super(key: key);

  final UserModel? user;
  final int postFollowCout;

  @override
  Widget build(BuildContext context) {
    final appUsers = context.watch<List<UserModel>?>();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: GhostModeBtn(),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  bottomSheetProfile(context);
                },
                icon: Image.asset(
                  imgProfileOption,
                  height: 35.h,
                  width: 35.w,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 45.w),
          child: Row(
            children: [
              ProfilePic(
                pic: user!.imageStr,
                showBorder: true,
              ),
              widthBox(13.w),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  visualDensity:
                      const VisualDensity(horizontal: 4, vertical: 4),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SelectableTextWidget(
                            text: user!.name,
                            color: color13F,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          Visibility(
                              visible: user!.isVerified,
                              child: SvgPicture.asset(icVerifyBadge))
                        ],
                      ),
                      SelectableTextWidget(
                        text: user!.username,
                        color: colorAA3,
                        fontSize: 12.sp,
                      ),
                      Visibility(
                        visible: user!.work.isNotEmpty,
                        child: Row(
                          children: [
                            SelectableTextWidget(
                              text: 'Works at ${user!.work}',
                              color: colorAA3,
                              fontSize: 12.sp,
                            ),
                            Visibility(
                              visible: user!.isWorkVerified,
                              child: SvgPicture.asset(icVerifyBadge),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: user!.education.isNotEmpty,
                        child: Row(
                          children: [
                            SelectableTextWidget(
                              text: "studied from ${user!.education}",
                              color: colorAA3,
                              fontSize: 12.sp,
                            ),
                            Visibility(
                              visible: user!.isEducationVerified,
                              child: SvgPicture.asset(icVerifyBadge),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        heightBox(20.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            postFollowCount(
                count: postFollowCout.toString(), strText: strProfilePost),
            verticalLine(height: 24.h, horizontalMargin: 30.w),
            GestureDetector(
              onTap: () =>
                  Get.to(() => const CurruentUserFollowerFollowingScreen(
                        follow: true,
                      )),
              child: postFollowCount(
                  count: appUsers == null
                      ? "0"
                      : appUsers
                          .where((element) =>
                              user!.followersIds.contains(element.id))
                          .length
                          .toString(),
                  strText: strProfileFollowers),
            ),
            verticalLine(height: 24.h, horizontalMargin: 30.w),
            GestureDetector(
              onTap: () =>
                  Get.to(() => const CurruentUserFollowerFollowingScreen()),
              child: postFollowCount(
                  count: appUsers == null
                      ? "0"
                      : appUsers
                          .where((element) =>
                              user!.followingsIds.contains(element.id))
                          .length
                          .toString(),
                  strText: strProfileFollowing),
            ),
          ],
        ),
        heightBox(20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 27.w),
          child: TextWidget(
            text: user!.bio,
            textAlign: TextAlign.center,
            color: color55F,
            fontSize: 12.sp,
          ),
        ),
        heightBox(20.h),
      ],
    );
  }
}
