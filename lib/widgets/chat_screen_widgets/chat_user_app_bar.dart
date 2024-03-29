import 'package:casarancha/models/providers/user_data_provider.dart';
import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/profile/AppUser/app_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../common_widgets.dart';
import '../profile_pic.dart';

class ChatScreenUserAppBar extends StatelessWidget {
  const ChatScreenUserAppBar({super.key, this.appUserId});
  final String? appUserId;

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: DataProvider().getSingleUser(appUserId),
      initialData: null,
      child: Consumer<UserModel?>(builder: (context, appUser, b) {
        if (appUser == null) {
          return Container();
        }
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
                            appUser.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        WidgetSpan(child: widthBox(5.w)),
                        WidgetSpan(
                          child: verifyBadge(appUser.isVerified),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          leading: Badge(
            padding: EdgeInsets.zero,
            smallSize: 12,
            backgroundColor:
                appUser.isOnline ? Colors.green.shade600 : color080,
            alignment: Alignment.bottomRight,
            child: ProfilePic(
              pic: appUser.imageStr,
              heightAndWidth: 40.h,
            ),
          ),
        );
      }),
    );
  }
}
