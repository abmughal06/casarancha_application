import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../resources/image_resources.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget(
      {super.key,
      this.ontapBlock,
      this.onTapDownload,
      required this.blockText,
      this.groupId,
      this.ontapDeletePost});

  final VoidCallback? ontapBlock;
  final VoidCallback? onTapDownload;
  final String blockText;
  final String? groupId;
  final VoidCallback? ontapDeletePost;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(icBottomSheetScroller),
          ),
          heightBox(12.h),
          ReportPostorComment(btnName: 'Report Post'),
          heightBox(20.h),
          TextWidget(
            onTap: ontapBlock,
            text: blockText,
            fontWeight: FontWeight.w600,
          ),
          heightBox(20.h),
          TextWidget(
            onTap: onTapDownload,
            text: "Download",
            fontWeight: FontWeight.w600,
          ),
          heightBox(20.h),
          Visibility(
            visible: groupId != null,
            child: StreamProvider.value(
              value: DataProvider().singleGroup(groupId),
              initialData: null,
              catchError: (context, error) => null,
              child: Consumer<GroupModel?>(builder: (context, group, b) {
                if (group == null) {
                  return Container();
                }
                if (group.adminIds.contains(currentUserUID) ||
                    group.creatorId == currentUserUID) {
                  return TextWidget(
                    onTap: ontapDeletePost,
                    text: 'Delete Post',
                    color: colorPrimaryA05,
                    fontWeight: FontWeight.w600,
                  );
                }
                return Container();
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class ReportPostorComment extends StatelessWidget {
  ReportPostorComment({super.key, required this.btnName});

  final String btnName;
  final List reportList = [
    "It's a spam",
    "Nudity or sexual activity",
    "I just don't like it",
    "Scam or fraud",
    "False Information",
    "Hate speech or symbols",
  ];

  @override
  Widget build(BuildContext context) {
    return TextWidget(
      onTap: () {
        Get.back();
        Get.bottomSheet(Container(
          height: 425.h,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(icBottomSheetScroller),
              ),
              heightBox(12.h),
              TextWidget(
                  text:
                      """Are you sure you wanted to report this post if yes then choose the reason for the report which is the related to the post""",
                  textAlign: TextAlign.center,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.6)),
              ListView.builder(
                  itemCount: reportList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextWidget(
                        onTap: () {
                          Get.back();
                          Get.bottomSheet(
                            Container(
                              height: 350.h,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30)),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(icBottomSheetScroller),
                                  heightBox(15.h),
                                  SvgPicture.asset(icReportPostDone),
                                  heightBox(15.h),
                                  TextWidget(
                                    text: "Thank you for the Report Us",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.sp,
                                    color: const Color(0xff212121),
                                  ),
                                  heightBox(12.h),
                                  TextWidget(
                                    text: "We have sparm the report",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    color: const Color(0xff5f5f5f),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        textAlign: TextAlign.left,
                        text: reportList[index],
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
            ],
          ),
        ));
      },
      text: btnName,
      fontWeight: FontWeight.w600,
    );
  }
}
