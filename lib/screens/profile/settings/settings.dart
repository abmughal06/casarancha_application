// ignore_for_file: library_private_types_in_public_api
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

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(
          title: appText(context).strProfileSetting, elevation: 0.2),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 18.h),
        children: [
          settingTile(
            leadIcon: SvgPicture.asset(icBlockAccount, height: 26.h),
            title: appText(context).strBlockAccount,
            subtitle: appText(context).strBlockUnblock,
            ontap: () => Get.to(() => const BlockAccountsScreen()),
            trailing: widthBox(0),
          ),
          settingTile(
            leadIcon: SvgPicture.asset(icBlockAccount, height: 26.h),
            title: appText(context).strReportAccount,
            subtitle: appText(context).strReported,
            ontap: () {},
            trailing: widthBox(0),
          ),
          // settingTile(
          //   leadIcon: Icon(
          //     Icons.language,
          //     size: 26.h,
          //   ),
          //   title: appText(context).language,
          //   ontap: () => Get.to(() => const LannguageSelectionPage()),
          //   trailing: const Icon(Icons.navigate_next),
          // ),
        ],
      ),
    );
  }
}

class HotRestartController extends StatefulWidget {
  final Widget child;

  const HotRestartController({super.key, required this.child});

  static performHotRestart(BuildContext context) {
    final _HotRestartControllerState? state =
        context.findAncestorStateOfType<_HotRestartControllerState>();
    state?.performHotRestart();
  }

  @override
  _HotRestartControllerState createState() => _HotRestartControllerState();
}

class _HotRestartControllerState extends State<HotRestartController> {
  Key key = UniqueKey();

  void performHotRestart() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}

Widget settingTile({leadIcon, title, String? subtitle, ontap, trailing}) {
  return Column(
    children: [
      heightBox(18.h),
      GestureDetector(
        onTap: ontap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
                    // heightBox(6.h),
                    if (subtitle != null && subtitle.isNotEmpty)
                      TextWidget(
                        text: subtitle,
                        onTap: ontap,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: colorAA3,
                      ),
                  ],
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
