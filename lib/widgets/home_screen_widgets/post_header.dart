import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../common_widgets.dart';
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
              image: NetworkImage(postCreator.imageStr),
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
              text: postCreator.username,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isVideoPost! ? colorFF7 : color221,
            ),
            widthBox(5.w),
            Visibility(
              visible: postCreator.isVerified,
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
        visible: postModel.showPostTime || postModel.locationName.isNotEmpty,
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
