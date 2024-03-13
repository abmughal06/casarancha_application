import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../screens/dashboard/provider/dashboard_provider.dart';
import '../profile_pic.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.symmetric(vertical: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onDoubleTap: () {
                    provider.scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeIn,
                    );
                  },
                  onTap: () {
                    provider.changePage(0);
                  },
                  child: SvgPicture.asset(
                    provider.currentIndex == 0
                        ? icBottomSelHome
                        : icBottomDeSelHome,
                    color: provider.currentIndex == 0 ? null : Colors.white,
                  ),
                ),
                InkWell(
                  onDoubleTap: () {
                    provider.ghostPostScrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeIn,
                    );
                  },
                  onTap: () {
                    provider.changePage(1);
                  },
                  child: Image.asset(
                    imgGhostUserBg,
                    color: provider.currentIndex == 1
                        ? colorPrimaryA05
                        : Colors.white,
                    height: 27,
                  ),
                ),
                InkWell(
                  onTap: () {
                    provider.changePage(2);
                  },
                  child: SvgPicture.asset(
                    provider.currentIndex == 2
                        ? icBottomSelSearch
                        : icBottomDeSelSearch,
                    color: provider.currentIndex == 2 ? null : Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () {
                    provider.changePage(3);
                  },
                  child: StreamProvider.value(
                    value: DataProvider.grpNotificationLength(),
                    initialData: null,
                    catchError: (context, error) => null,
                    child: Consumer<int?>(
                      builder: (context, msgs, b) {
                        if (msgs == null) {
                          return SvgPicture.asset(
                            provider.currentIndex == 3
                                ? icBottomSelGrp
                                : icBottomDeSelGrp,
                            color: provider.currentIndex == 3
                                ? null
                                : Colors.white,
                          );
                        }

                        int count = msgs;

                        return Badge(
                          label: Text(count.toString()),
                          isLabelVisible: count > 0,
                          child: SvgPicture.asset(
                            provider.currentIndex == 3
                                ? icBottomSelGrp
                                : icBottomDeSelGrp,
                            color: provider.currentIndex == 3
                                ? null
                                : Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                InkWell(
                  onDoubleTap: () {
                    provider.forumScrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeIn,
                    );
                  },
                  onTap: () {
                    provider.changePage(4);
                  },
                  child: SvgPicture.asset(
                    provider.currentIndex == 4
                        ? icForumSelHome
                        : icForumDeSelHome,
                    color: provider.currentIndex == 4 ? null : Colors.white,
                    height: 22.h,
                  ),
                ),
                InkWell(
                  onTap: () {
                    provider.changePage(5);
                  },
                  child: StreamProvider.value(
                    value: DataProvider().totalUnReadMessages,
                    initialData: null,
                    catchError: (context, error) => null,
                    child: Consumer<int?>(builder: (context, msgs, b) {
                      if (msgs == null) {
                        return SvgPicture.asset(
                          provider.currentIndex == 5
                              ? icBottomSelChat
                              : icBottomDeSelChat,
                          color:
                              provider.currentIndex == 5 ? null : Colors.white,
                        );
                      }

                      return Badge(
                        label: Text(msgs.toString()),
                        isLabelVisible: msgs > 0,
                        child: SvgPicture.asset(
                          provider.currentIndex == 5
                              ? icBottomSelChat
                              : icBottomDeSelChat,
                          color:
                              provider.currentIndex == 5 ? null : Colors.white,
                        ),
                      );
                    }),
                  ),
                ),
                InkWell(
                  onTap: () {
                    provider.changePage(6);
                  },
                  child: Consumer<UserModel?>(
                    builder: (context, user, b) {
                      if (user == null) {
                        return const CircularProgressIndicator.adaptive();
                      }
                      return ProfilePic(
                        heightAndWidth: 30.h,
                        pic: user.imageStr,
                      );
                    },
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
