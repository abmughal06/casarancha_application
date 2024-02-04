import 'package:casarancha/resources/strings.dart';
import 'package:casarancha/widgets/profile_pic.dart';
import 'package:casarancha/widgets/profle_screen_widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';
import '../../models/providers/user_data_provider.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/profile/follower_following_screen.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

Widget profileCounter(
    {required String count, required String strText, required ontap}) {
  return GestureDetector(
    onTap: ontap,
    child: Column(
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
    ),
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
  const ProfileTopLoader({super.key});

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
            profileCounter(
                ontap: null,
                count: "0",
                strText: appText(context).strProfilePost),
            verticalLine(height: 24.h, horizontalMargin: 30.w),
            profileCounter(
                ontap: null,
                count: '0',
                strText: appText(context).strProfileFollowers),
            verticalLine(height: 24.h, horizontalMargin: 30.w),
            profileCounter(
                ontap: null,
                count: '0',
                strText: appText(context).strProfileFollowing),
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
  const ProfileTop({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    // final appUsers = context.watch<List<UserModel>?>();

    return Column(
      children: [
        Card(
          color: colorWhite,
          shape:
              const CircleBorder(side: BorderSide(color: colorWhite, width: 3)),
          elevation: 3,
          child: ProfilePic(
            pic: user.imageStr,
            showBorder: false,
            heightAndWidth: 105.h,
          ),
        ),
        heightBox(15.w),
        SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "${user.name} ",
                style: TextStyle(
                  color: color13F,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              WidgetSpan(child: verifyBadge(user.isVerified, size: 17)),
            ],
          ),
        ),
        SelectableTextWidget(
          text: user.username,
          color: colorAA3,
          fontWeight: FontWeight.w400,
          fontSize: 13.sp,
        ),
        heightBox(8.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamProvider.value(
                initialData: null,
                catchError: (context, error) => null,
                value: DataProvider().posts(),
                child: Consumer<List<PostModel>?>(builder: (context, post, b) {
                  if (post == null) {
                    return profileCounter(
                        ontap: null,
                        count: '0',
                        strText: appText(context).strProfilePost);
                  }
                  return profileCounter(
                      ontap: null,
                      count: post
                          .where((element) => element.creatorId == user.id)
                          .toList()
                          .length
                          .toString(),
                      strText: appText(context).strProfilePost);
                })),
            verticalLine(height: 24.h, horizontalMargin: 30.w),
            profileCounter(
                ontap: () =>
                    Get.to(() => const CurruentUserFollowerFollowingScreen(
                          follow: true,
                        )),
                count: user.followersIds.length.toString(),
                strText: appText(context).strProfileFollowers),
            verticalLine(height: 24.h, horizontalMargin: 30.w),
            profileCounter(
                ontap: () =>
                    Get.to(() => const CurruentUserFollowerFollowingScreen()),
                count: user.followingsIds.length.toString(),
                strText: appText(context).strProfileFollowing),
          ],
        ),
        heightBox(20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user.education.isNotEmpty)
                SelectableText.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.school,
                          size: 16.sp,
                          color: color55F,
                        ),
                      ),
                      TextSpan(
                        text: ' ${user.education} ',
                        style: TextStyle(
                          color: color55F,
                          fontSize: 12.sp,
                          fontFamily: strFontName,
                        ),
                      ),
                      WidgetSpan(
                          child:
                              verifyBadge(user.isEducationVerified, size: 15)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              if (user.work.isNotEmpty)
                SelectableText.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.work,
                          size: 15.sp,
                          color: color55F,
                        ),
                      ),
                      TextSpan(
                        text: ' ${user.work} ',
                        style: TextStyle(
                          color: color55F,
                          fontFamily: strFontName,
                          fontSize: 12.sp,
                        ),
                      ),
                      WidgetSpan(
                          child: verifyBadge(user.isWorkVerified, size: 15)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              if (user.bio.isNotEmpty)
                SelectableTextWidget(
                  text: user.bio,
                  textAlign: TextAlign.center,
                  color: color55F,
                  fontSize: 12.sp,
                ),
            ],
          ),
        ),
        heightBox(20.h),
      ],
    );
  }
}
