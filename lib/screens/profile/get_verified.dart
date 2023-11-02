import 'package:casarancha/resources/localization_text_strings.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/common_button.dart';
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
      body: Center(
        child: CommonButton(
          horizontalOutMargin: 50.w,
          height: 47.h,
          text: "Applied for verified badge",
          onTap: () {
            GlobalSnackBar.show(
                message:
                    'Thanks for applying for verifying badge. we will notify you shortly.');
          },
        ),
      ),
    );
  }
}
