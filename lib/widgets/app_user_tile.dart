import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppUserTile extends StatelessWidget {
  const AppUserTile({
    super.key,
    required this.appUser,
    this.trailingWidget,
    required this.currentUser,
  });

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
        title: Row(
          children: [
            Text(appUser.name),
            widthBox(5.w),
            verifyBadge(appUser.isVerified),
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
