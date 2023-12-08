import 'package:casarancha/models/post_creator_details.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/image_resources.dart';
import '../common_widgets.dart';
import '../profile_pic.dart';

class ChatScreenUserAppBar extends StatelessWidget {
  const ChatScreenUserAppBar(
      {super.key, required this.creatorDetails, this.appUserId});
  final CreatorDetails creatorDetails;
  final String? appUserId;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => navigateToAppUserScreen(appUserId, context),
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Expanded(
            child: SizedBox(
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Text(
                        creatorDetails.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    WidgetSpan(child: widthBox(5.w)),
                    WidgetSpan(
                      child: Visibility(
                          visible: creatorDetails.isVerified,
                          child: SvgPicture.asset(icVerifyBadge)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      subtitle: const Text('Live'),
      leading: ProfilePic(
        pic: creatorDetails.imageUrl,
        heightAndWidth: 40.h,
      ),
    );
  }
}
