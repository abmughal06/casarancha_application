import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TabBar primaryTabBar({required List<Widget> tabs}) {
  return TabBar(
    indicatorWeight: 2.0,
    isScrollable: false,
    labelColor: colorPrimaryA05,
    indicatorColor: colorF03,
    unselectedLabelColor: colorAA3,
    labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
    labelStyle: TextStyle(
      fontSize: 14.sp,
      fontFamily: strFontName,
      fontWeight: FontWeight.w400,
    ),
    tabs: tabs,
  );
}
