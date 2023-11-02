import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/profile/block_account_screen.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: 'Profile Settings', elevation: 0.2),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 18.h),
        children: [
          settingTile(
            leadIcon: SvgPicture.asset(icBlockAccount, height: 26.h),
            title: 'Block Account',
            subtitle: 'Block/Unblock Account',
            ontap: () => Get.to(() => const BlockAccountsScreen()),
            trailing: widthBox(0),
          ),
          settingTile(
            leadIcon: SvgPicture.asset(icBlockAccount, height: 26.h),
            title: 'Report Account',
            subtitle: 'Reported Accounts',
            ontap: () {},
            trailing: widthBox(0),
          ),
        ],
      ),
    );
  }
}

Widget settingTile({leadIcon, title, subtitle, ontap, trailing}) {
  return Column(
    children: [
      heightBox(18.h),
      GestureDetector(
        onTap: ontap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            leadIcon,
            widthBox(20.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: title,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: color221,
                  onTap: ontap,
                ),
                heightBox(8.h),
                TextWidget(
                  text: subtitle,
                  onTap: ontap,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: colorAA3,
                ),
              ],
            ),
            trailing,
          ],
        ),
      ),
      heightBox(18.h),
      Divider(
        height: 0.7.h,
        color: colorDD3,
      ),
    ],
  );
}
