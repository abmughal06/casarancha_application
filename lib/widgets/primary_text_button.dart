import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryTextButton extends StatelessWidget {
  const PrimaryTextButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.icon,
  });

  final GestureTapCallback onPressed;
  final String title;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const SizedBox(),
            widthBox(6.w),
            TextWidget(
              text: title,
              color: colorBlack,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
          ],
        ),
      ),
    );
  }
}
