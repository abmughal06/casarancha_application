import 'package:casarancha/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatShimmerList extends StatelessWidget {
  const ChatShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: shimmerImg(
            borderRadius: 1000,
            height: 40.h,
            width: 40.h,
          ),
          title: shimmerImg(height: 10.h, width: 50.w),
          subtitle: shimmerImg(height: 10.h, width: 200.w),
        );
      },
      separatorBuilder: (context, index) => heightBox(10.h),
      itemCount: 10,
    );
  }
}
