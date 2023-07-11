import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/group_model.dart';
import 'package:casarancha/screens/groups/group_post_screen.dart';

import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/text_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../resources/color_resources.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({
    Key? key,
    required this.group,
    this.trailingWidget,
    required this.currentUserId,
  }) : super(key: key);

  final GroupModel group;
  final String currentUserId;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        10.r,
      ),
    );
    return Card(
      margin: EdgeInsets.only(
        bottom: 10.w,
      ),
      elevation: 3,
      shape: cardShape,
      child: ListTile(
        shape: cardShape,
        // onTap: () {
        //   Get.to(
        //     () => GroupPostScreen(
        //       group: group,
        //     ),
        //   );
        // },
        title: TextWidget(
          text: group.name,
          color: color221,
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
        subtitle: TextWidget(
          text: '${group.memberIds.length} Members',
          color: color55F,
          fontSize: 11.sp,
          textOverflow: TextOverflow.ellipsis,
        ),
        leading: CachedNetworkImage(
          imageUrl: group.imageUrl,
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
        trailing: Text(
          group.isPublic ? 'Public' : 'Private',
        ),
      ),
    );
  }
}
