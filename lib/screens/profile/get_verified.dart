import 'package:casarancha/resources/localization_text_strings.dart';
import 'package:casarancha/widgets/common_button.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          CommonButton(
            text: 'Get account verified',
            horizontalOutMargin: 40.w,
          ),
          heightBox(12.h),
          CommonButton(
            text: 'Get education verified',
            horizontalOutMargin: 40.w,
          ),
          heightBox(12.h),
          CommonButton(
            text: 'Get work verified',
            horizontalOutMargin: 40.w,
          ),
        ],
      ),
    );
  }
}
