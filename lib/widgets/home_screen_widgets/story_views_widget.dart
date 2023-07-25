import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../models/story_model.dart';
import '../../models/user_model.dart';
import '../../resources/image_resources.dart';

Widget storyViews({required Story story}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: const BoxDecoration(color: Colors.white),
    child: Consumer<List<UserModel>?>(
      // stream: storyItems[provider.currentIndex].storyViews!.isEmpty
      //     ? FirebaseFirestore.instance
      //         .collection("users")
      //         .where("id", arrayContains: widget.story.storyViews)
      //         .snapshots()
      //     : FirebaseFirestore.instance
      //         .collection("users")
      //         .where("id",
      //             whereIn: storyItems[provider.currentIndex].storyViews)
      //         .snapshots(),
      builder: (context, user, b) {
        if (user == null) {
          return const CircularProgressIndicator.adaptive();
        } else {
          var viewers = user
              .where((element) => story.storyViews.contains(element.id))
              .toList();
          return ListView.builder(
            itemCount: viewers.length,
            itemBuilder: (context, index) {
              var userModel = viewers[index];
              return ListTile(
                leading: Container(
                  height: 46.h,
                  width: 46.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(userModel.imageStr),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: RichText(
                  text: TextSpan(
                    text: "",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: const Color(0xff5F5F5F)),
                    children: [
                      TextSpan(
                        text: userModel.isVerified
                            ? userModel.name
                            : "${userModel.name} ",
                        style: TextStyle(
                          color: const Color(0xff121F3F),
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      WidgetSpan(
                        child: Visibility(
                          visible: userModel.isVerified,
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: SvgPicture.asset(icVerifyBadge)),
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    userModel.username,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: const Color(0xff5F5F5F)),
                  ),
                ),
              );
            },
          );
        }
      },
    ),
  );
}
