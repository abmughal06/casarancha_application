import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

class CustomPostHeader extends StatelessWidget {
  final String? name;
  final String? image;
  final VoidCallback? ontap;
  final VoidCallback? headerOnTap;
  final bool? isVerified;
  final String? time;
  final bool? isVideoPost;
  final VoidCallback? onVertItemClick;
  final bool? showPostTime;

  const CustomPostHeader(
      {Key? key,
      this.name,
      this.image,
      this.ontap,
      this.isVideoPost = false,
      this.headerOnTap,
      this.isVerified = false,
      this.onVertItemClick,
      this.time,
      this.showPostTime = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      visualDensity: const VisualDensity(vertical: -2),
      horizontalTitleGap: 10,
      leading: InkWell(
        onTap: headerOnTap,
        child: Container(
          height: 40.h,
          width: 40.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber,
            image: DecorationImage(
              image: NetworkImage("$image"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: InkWell(
        onTap: headerOnTap,
        child: Row(
          children: [
            TextWidget(
              text: "$name",
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isVideoPost! ? colorFF7 : color221,
            ),
            widthBox(5.w),
            Visibility(
              visible: isVerified!,
              child: SvgPicture.asset(
                icVerifyBadge,
                width: 17.w,
                height: 17.h,
              ),
            )
          ],
        ),
      ),
      subtitle: Visibility(
        visible: showPostTime!,
        child: TextWidget(
          text: time,
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
          color: isVideoPost!
              ? colorFF7.withOpacity(0.6)
              : const Color(0xff5f5f5f),
        ),
      ),
      trailing: InkWell(
        onTap: onVertItemClick,
        child: Icon(
          Icons.more_vert,
          color: isVideoPost! ? colorFF7 : const Color(0xffafafaf),
        ),
      ),
    );
  }
}
