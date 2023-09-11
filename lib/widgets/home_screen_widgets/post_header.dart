import 'package:casarancha/resources/strings.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../common_widgets.dart';
import '../profile_pic.dart';
import '../text_widget.dart';

class CustomPostHeader extends StatelessWidget {
  final VoidCallback? ontap;
  final VoidCallback? headerOnTap;
  final PostModel postModel;
  final bool? isVideoPost;
  final VoidCallback? onVertItemClick;
  final UserModel postCreator;

  const CustomPostHeader(
      {Key? key,
      this.ontap,
      this.isVideoPost = false,
      this.headerOnTap,
      this.onVertItemClick,
      required this.postCreator,
      required this.postModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: headerOnTap,
        minVerticalPadding: 0,
        visualDensity: const VisualDensity(vertical: -2),
        horizontalTitleGap: 10,
        leading: InkWell(
          onTap: headerOnTap,
          child: ProfilePic(
            pic: postCreator.imageStr,
            heightAndWidth: 40.h,
          ),
        ),
        title: Row(
          children: [
            TextWidget(
              onTap: headerOnTap,
              text: postCreator.username,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isVideoPost! ? colorFF7 : color221,
            ),
            widthBox(5.w),
            Visibility(
              visible: !postCreator.isVerified,
              child: SvgPicture.asset(
                icVerifyBadge,
                width: 17.w,
                height: 17.h,
              ),
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: postCreator.work.isNotEmpty ||
                  postCreator.education.isNotEmpty,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: color55F,
                    fontFamily: strFontName,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: postCreator.work.isNotEmpty
                          ? "${postCreator.work} "
                          : '',
                    ),
                    WidgetSpan(
                        child: Visibility(
                            visible: postCreator.isWorkVerified,
                            child: SvgPicture.asset(icVerifyBadge))),
                    TextSpan(
                        text: postCreator.work.isNotEmpty &&
                                postCreator.education.isNotEmpty
                            ? ' | '
                            : ''),
                    TextSpan(
                      text: postCreator.education.isEmpty
                          ? ''
                          : "${postCreator.education} ",
                    ),
                    WidgetSpan(
                        child: Visibility(
                            visible: postCreator.isEducationVerified,
                            child: SvgPicture.asset(icVerifyBadge))),
                  ],
                ),
              ),
            ),
            Visibility(
              visible:
                  postModel.showPostTime || postModel.locationName.isNotEmpty,
              child: TextWidget(
                text:
                    "${postModel.showPostTime ? "${convertDateIntoTime(postModel.createdAt)} " : ""}${postModel.locationName.isEmpty ? "" : "at ${postModel.locationName}"}",
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: isVideoPost!
                    ? colorFF7.withOpacity(0.6)
                    : const Color(0xff5f5f5f),
              ),
            ),
          ],
        ),
        trailing: InkWell(
          onTap: onVertItemClick,
          child: Icon(
            Icons.more_vert,
            color: isVideoPost! ? colorFF7 : const Color(0xffafafaf),
          ),
        ),
      ),
    );
  }
}
