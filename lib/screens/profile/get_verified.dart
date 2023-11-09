import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/localization_text_strings.dart';
import 'package:casarancha/screens/profile/get_verified_screens/verify_screen.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GetVerifiedScreen extends StatelessWidget {
  const GetVerifiedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(
        title: strGetVerified,
        elevation: 0.2,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomExpansionTile(
            title: 'Get Name Verify',
            children: [
              ExpansionChildrenListTile(
                  text: 'Userename',
                  ontap: () =>
                      Get.to(() => const VerifyScreen(isUsername: true))),
              ExpansionChildrenListTile(
                  text: 'Organisation',
                  ontap: () =>
                      Get.to(() => const VerifyScreen(isOrganization: true))),
              ExpansionChildrenListTile(
                  text: 'Group',
                  ontap: () => Get.to(() => const VerifyScreen(isGroup: true))),
              ExpansionChildrenListTile(
                  text: 'Forum',
                  ontap: () => Get.to(() => const VerifyScreen(isForum: true))),
            ],
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
            title: const TextWidget(text: 'Get Education Verify'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () => Get.to(() => const VerifyScreen(
                  isEducation: true,
                )),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
            title: const TextWidget(text: 'Get Work Verify'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () => Get.to(() => const VerifyScreen(isWork: true)),
          ),
        ],
      ),
    );
  }
}

class CustomExpansionTile extends StatelessWidget {
  const CustomExpansionTile({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      child: ExpansionTile(
        title: TextWidget(text: title),
        textColor: colorPrimaryA05,
        childrenPadding: const EdgeInsets.only(left: 20),
        children: children,
      ),
    );
  }
}

class ExpansionChildrenListTile extends StatelessWidget {
  const ExpansionChildrenListTile(
      {Key? key, required this.text, required this.ontap})
      : super(key: key);
  final String text;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ontap,
      title: TextWidget(
        text: text,
        fontSize: 13.sp,
        color: color55F,
      ),
      trailing: const Icon(Icons.navigate_next),
    );
  }
}
