import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/strings.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar primaryAppbar({
  required String title,
  bool showBackButton = true,
  PreferredSizeWidget? bottom,
  double? elevation,
  Widget? leading,
  List<Widget>? actions,
}) {
  return AppBar(
    backgroundColor: Colors.grey.shade50,
    centerTitle: true,
    leading: leading,
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    title: TextWidget(
      text: title,
      color: color13F,
      fontFamily: strFontName,
      fontWeight: FontWeight.w600,
      fontSize: 16.sp,
    ),
    elevation: elevation ?? 0.1,
    automaticallyImplyLeading: showBackButton,
    bottom: bottom,
    actions: actions,
  );
}
