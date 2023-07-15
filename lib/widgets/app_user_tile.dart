import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_controller.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_screen.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AppUserTile extends StatelessWidget {
  const AppUserTile({
    Key? key,
    required this.appUser,
    this.trailingWidget,
    required this.currentUser,
  }) : super(key: key);

  final UserModel appUser;
  final UserModel currentUser;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        bottom: 10.w,
      ),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10.r,
        ),
      ),
      child: ListTile(
        // onTap: appUser.id == currentUser.id
        //     ? () => const GlobalSnackBar(message: 'Open from profile page')
        //     : () => Get.to(
        //           // () => AppUserScreen(
        //           //   appUserController: Get.put(
        //           //     AppUserController(
        //           //       appUser: appUser,
        //           //       appUserId: appUser.id,
        //           //       currentUserId: currentUser.id,
        //           //     ),
        //           //   ),
        //           // ),
        //         ),
        title: Row(
          children: [
            Text(appUser.name),
            widthBox(5.w),
            if (appUser.isVerified) SvgPicture.asset(icVerifyBadge),
          ],
        ),
        subtitle: TextWidget(
          text: appUser.username,
          color: color55F,
          fontSize: 11.sp,
          textOverflow: TextOverflow.ellipsis,
        ),
        leading: CachedNetworkImage(
          imageUrl: appUser.imageStr,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 25.r,
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => shimmerImg(
              child: CircleAvatar(
            radius: 25.r,
          )),
          errorWidget: (context, url, error) => CircleAvatar(
            radius: 25.r,
            backgroundColor: Colors.white,
            child: const Center(
              child: Icon(
                Icons.error,
              ),
            ),
          ),
        ),
        trailing: trailingWidget,
      ),
    );
  }
}
