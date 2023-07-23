import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../screens/profile/AppUser/app_user_screen.dart';
import '../common_widgets.dart';
import '../text_widget.dart';

class FollowFollowingTile extends StatelessWidget {
  const FollowFollowingTile(
      {Key? key,
      required this.user,
      required this.ontapToggleFollow,
      required this.btnName})
      : super(key: key);
  final UserModel user;
  final VoidCallback ontapToggleFollow;
  final String btnName;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    // Get.to(
                    //   () => AppUserScreen(
                    //     appUserId: user.id,
                    //     appUserName: user.name,
                    //   ),
                    // );
                    navigateToAppUserScreen(user.id, context);
                  },
                  child: Container(
                    height: 50.h,
                    width: 50.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(user.imageStr),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                widthBox(12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        // Get.to(
                        //   () => AppUserScreen(
                        //     appUserId: user.id,
                        //     appUserName: user.name,
                        //   ),
                        // );
                        navigateToAppUserScreen(user.id, context);
                      },
                      child: Row(
                        children: [
                          TextWidget(
                              text: user.username,
                              fontSize: 14.sp,
                              color: const Color(0xff212121),
                              fontWeight: FontWeight.w600),
                          widthBox(4.w),
                          if (user.isVerified) SvgPicture.asset(icVerifyBadge),
                        ],
                      ),
                    ),
                    heightBox(2.h),
                    TextWidget(
                      text: user.name,
                      fontSize: 12.sp,
                      color: const Color(0xff5f5f5f),
                      fontWeight: FontWeight.w400,
                      textOverflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
              onTap: ontapToggleFollow,
              child: TextWidget(
                text: btnName,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: colorPrimaryA05,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
