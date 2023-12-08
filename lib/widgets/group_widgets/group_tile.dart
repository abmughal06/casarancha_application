import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/groups/group_post_screen.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/profile_pic.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GroupTile extends StatelessWidget {
  const GroupTile(
      {super.key,
      required this.group,
      required this.ontapTrailing,
      this.isSearchScreen = false,
      this.btnText = ''});
  final GroupModel group;
  final VoidCallback ontapTrailing;
  final bool isSearchScreen;
  final String btnText;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      margin: EdgeInsets.only(bottom: 10.h, left: 20.w, right: 20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
      color: colorWhite,
      child: Container(
        padding: EdgeInsets.all(15.h),
        child: InkWell(
          onTap: () => Get.to(() => GroupPostScreen(group: group)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ProfilePic(
                    pic: group.imageUrl,
                    heightAndWidth: 50.w,
                  ),
                  widthBox(12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SelectableTextWidget(
                            text: group.name,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: color221,
                          ),
                          Visibility(
                            visible: group.isVerified,
                            child: SvgPicture.asset(icVerifyBadge),
                          )
                        ],
                      ),
                      heightBox(3.h),
                      Row(
                        children: [
                          SelectableTextWidget(
                            text:
                                "${group.memberIds.length.toString()} ${group.memberIds.length > 1 ? 'Members' : 'Member'}",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: colorAA3,
                          ),
                          widthBox(2.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                                color: colorF03,
                                borderRadius: BorderRadius.circular(6)),
                            child: TextWidget(
                              text: group.isPublic ? 'Public' : 'Private',
                              fontSize: 10.sp,
                              color: color221,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              isSearchScreen
                  ? TextWidget(
                      text: btnText,
                      color: colorPrimaryA05,
                      fontWeight: FontWeight.w500,
                      onTap: ontapTrailing,
                    )
                  : InkWell(
                      onTap: ontapTrailing,
                      child: const Icon(
                        Icons.more_vert,
                        color: colorAA3,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
