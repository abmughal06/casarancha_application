import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future deleteBottomSheet({text, ontap}) {
  return Get.bottomSheet(
    Container(
      decoration: const BoxDecoration(color: Colors.red),
      height: 80,
      child: InkWell(
        onTap: ontap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(
              text: text,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            )
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
