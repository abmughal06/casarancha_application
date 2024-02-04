import 'package:cached_network_image/cached_network_image.dart';
import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';

Widget storyViews({required List viwersIds}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: const BoxDecoration(color: Colors.white),
    child: StreamProvider.value(
      value: DataProvider().filterUserList(viwersIds),
      initialData: null,
      catchError: (context, error) => null,
      child: Consumer<List<UserModel>?>(
        builder: (context, users, b) {
          if (users == null) {
            return centerLoader();
          } else {
            if (users.isEmpty) {
              return const Center(
                child: TextWidget(
                  text: 'No Views',
                ),
              );
            }
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var userModel = users[index];
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
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: verifyBadge(userModel.isVerified)),
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
    ),
  );
}
