import 'package:casarancha/models/ghost_message_details.dart';
import 'package:casarancha/models/message_details.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../screens/dashboard/provider/dashboard_provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserModel?>();
    final ghostMessage = context.watch<List<GhostMessageDetails>?>();

    return Consumer<DashboardProvider>(
      builder: (context, provider, b) {
        return Card(
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical:
                provider.checkGhostMode || Platform.isAndroid ? 10.w : 0.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              50,
            ),
          ),
          // elevation: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    provider.changePage(0);
                  },
                  icon: InkWell(
                    onTap: () => provider.changePage(0),
                    onDoubleTap: () {
                      provider.scrollController.animateTo(0,
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.easeIn);
                    },
                    child: SvgPicture.asset(
                      provider.currentIndex == 0
                          ? icBottomSelHome
                          : icBottomDeSelHome,
                      color: provider.currentIndex == 0 ? null : Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    provider.changePage(1);
                  },
                  icon: SvgPicture.asset(
                    provider.currentIndex == 1
                        ? icBottomSelSearch
                        : icBottomDeSelSearch,
                    color: provider.currentIndex == 1 ? null : Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    provider.changePage(2);
                  },
                  icon: SvgPicture.asset(
                    provider.currentIndex == 2
                        ? icBottomSelGrp
                        : icBottomDeSelGrp,
                    color: provider.currentIndex == 2 ? null : Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    provider.changePage(3);
                  },
                  icon: SvgPicture.asset(
                    provider.currentIndex == 3
                        ? icForumSelHome
                        : icForumDeSelHome,
                    color: provider.currentIndex == 3 ? null : Colors.white,
                    height: 24.h,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    provider.changePage(4);
                  },
                  icon: Consumer<List<MessageDetails>?>(
                      builder: (context, msg, b) {
                    if (msg == null || ghostMessage == null) {
                      return SvgPicture.asset(
                        provider.currentIndex == 4
                            ? icBottomSelChat
                            : icBottomDeSelChat,
                        color: provider.currentIndex == 4 ? null : Colors.white,
                      );
                    }
                    var filterList = msg
                        .where((element) => element.unreadMessageCount > 0)
                        .toList();
                    var ghostFilter = ghostMessage
                        .where((element) => element.unreadMessageCount > 0)
                        .toList();

                    int count = 0;
                    for (var i in filterList) {
                      count += i.unreadMessageCount;
                    }
                    for (var i in ghostFilter) {
                      count += i.unreadMessageCount;
                    }
                    return Badge(
                      label: Text(count.toString()),
                      isLabelVisible: count > 0,
                      child: SvgPicture.asset(
                        provider.currentIndex == 4
                            ? icBottomSelChat
                            : icBottomDeSelChat,
                        color: provider.currentIndex == 4 ? null : Colors.white,
                      ),
                    );
                  }),
                ),
                IconButton(
                  onPressed: () {
                    provider.changePage(5);
                  },
                  icon: CircleAvatar(
                    backgroundColor: Colors.red.withOpacity(
                      0.1,
                    ),
                    backgroundImage: currentUser == null
                        ? null
                        : CachedNetworkImageProvider(
                            currentUser.imageStr,
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
