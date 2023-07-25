import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/screens/auth/login_screen.dart';
import 'package:casarancha/screens/auth/providers/auth_provider.dart';
import 'package:casarancha/screens/dashboard/ghost_mode_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/profile/follower_following_screen.dart';
import '../../screens/profile/saved_post_screen.dart';
import '../../utils/app_constants.dart';
import '../../utils/snackbar.dart';
import '../common_widgets.dart';
import '../home_page_widgets.dart';
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

_bottomSheetProfile(context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r)),
      ),
      builder: (BuildContext context) {
        return Container(
            height: 550,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  heightBox(10.h),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 6.h,
                      width: 78.w,
                      decoration: BoxDecoration(
                        color: colorDD9,
                        borderRadius: BorderRadius.all(Radius.circular(30.r)),
                      ),
                    ),
                  ),
                  heightBox(10.h),
                  Expanded(
                    child: ListView.builder(
                        itemCount: AppConstant.profileBottomSheetList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: textMenuItem(
                                text: AppConstant.profileBottomSheetList[index],
                                color: index > 6 ? Colors.red : null,
                                onTap: () {
                                  _onTapSheetItem(index: index);
                                }),
                          );
                        }),
                  )
                ]));
      });
}

_onTapSheetItem({required int index}) async {
  switch (index) {
    case 0:
      Get.to(() => const EditProfileScreen());
      break;
    case 1:
      Get.to(() => const SavedPostScreen());
      break;
    case 2:
      //getVerify
      Get.back();
      GlobalSnackBar.show(message: 'Coming Soon');
      break;
    case 3:
      Get.back();
      GlobalSnackBar.show(message: 'Coming Soon');
      break;

    case 4:
      //about
      Get.back();
      launchUrls("https://casarancha.com/about/");
      break;

    case 5:
      //terms

      Get.back();
      launchUrls("https://casarancha.com/terms-conditions/");
      break;
    case 6:
      //privacy

      Get.back();
      launchUrls("https://casarancha.com/privacy-policy/");
      break;
    case 7:
      //logout
      // profileScreenController.logout();
      Get.back();
      AuthenticationProvider(FirebaseAuth.instance).signOut().whenComplete(() {
        User? user;
        if (user == null) {
          Get.offAll(() => const LoginScreen());
        }
      });

      break;
    case 8:
      //logout

      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return deleteAccountDialog(context);
      //     });

      break;
  }
}

void launchUrls(String url) async {
  Uri? uri = Uri.tryParse(url);
  if (uri != null) {
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      log("Can't launch url => $url");
    }
  } else {
    log("$url is not valid");
  }
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
                  _bottomSheetProfile(context);
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
                  _bottomSheetProfile(context);
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
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: ClipOval(
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: const AssetImage(imgUserPlaceHolder),
                image: CachedNetworkImageProvider(user!.imageStr),
              ),
            ),
          ),
        ),
        heightBox(15.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              text: user!.name,
              color: color13F,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
            widthBox(6.w),
            if (user!.isVerified)
              SvgPicture.asset(
                icVerifyBadge,
                width: 17.w,
                height: 17.h,
              )
          ],
        ),
        TextWidget(
          text: user!.username,
          color: colorAA3,
          fontSize: 12.sp,
        ),
        heightBox(12.h),
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
        heightBox(14.h),
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
