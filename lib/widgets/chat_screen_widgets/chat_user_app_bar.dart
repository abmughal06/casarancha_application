import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/post_creator_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/image_resources.dart';
import '../common_widgets.dart';

class ChatScreenUserAppBar extends StatelessWidget {
  const ChatScreenUserAppBar({Key? key, required this.creatorDetails})
      : super(key: key);
  final CreatorDetails creatorDetails;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
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
      leading: CircleAvatar(
        backgroundImage: creatorDetails.imageUrl.isNotEmpty
            ? CachedNetworkImageProvider(
                creatorDetails.imageUrl,
              )
            : null,
      ),
    );
  }
}
