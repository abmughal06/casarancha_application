import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/color_resources.dart';

class BaseContainerWidget extends StatelessWidget {
  final Widget childWidget;
  const BaseContainerWidget({Key? key, required this.childWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: colorPrimaryA05,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),
        ),
        margin: EdgeInsets.only(top: 90.h),
        child: childWidget,
      ),
    );
  }
}
