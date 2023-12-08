import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertText extends StatelessWidget {
  const AlertText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: TextWidget(
          text: text,
          fontSize: 12.sp,
          color: color55F,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
