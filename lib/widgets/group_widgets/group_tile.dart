import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/profile_pic.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({Key? key, required this.group, required this.ontap})
      : super(key: key);
  final GroupModel group;
  final VoidCallback ontap;

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
          onTap: ontap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ProfilePic(
                    pic: group.imageUrl,
                    heightAndWidth: 50.w,
                  ),
                  widthBox(15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableTextWidget(
                        text: group.name,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: color221,
                      ),
                      Row(
                        children: [
                          SelectableTextWidget(
                            text:
                                "${group.memberIds.length.toString()} ${group.memberIds.length > 1 ? 'Members' : 'Member'}",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: colorAA3,
                          ),
                          widthBox(5.h),
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
              InkWell(
                onTap: () {},
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
