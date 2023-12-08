import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/color_resources.dart';
import '../resources/image_resources.dart';

class ProfilePic extends StatelessWidget {
  final String? pic;
  final bool showBorder;
  final double? heightAndWidth;
  const ProfilePic(
      {super.key,
      required this.pic,
      this.showBorder = false,
      this.heightAndWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: showBorder ? colorPrimaryA05 : Colors.transparent,
              width: 1.5),
          shape: BoxShape.circle),
      height: heightAndWidth ?? 37.h,
      width: heightAndWidth ?? 37.h,
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: ClipOval(
          child: pic != "" && pic != null
              ? FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: const AssetImage(imgUserPlaceHolder),
                  image: CachedNetworkImageProvider(pic!),
                )
              : const FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: AssetImage(imgUserPlaceHolder),
                  image: AssetImage(imgUserPlaceHolder),
                ),
        ),
      ),
    );
  }
}
