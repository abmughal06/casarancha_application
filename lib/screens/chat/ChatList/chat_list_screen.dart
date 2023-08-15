import 'package:casarancha/screens/dashboard/ghost_scaffold.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';

import '../../../resources/color_resources.dart';
import '../../../resources/image_resources.dart';
import '../../../widgets/chat_screen_widgets/frieds_chat_list.dart';
import '../../../widgets/chat_screen_widgets/ghost_chat_list.dart';
import '../../dashboard/ghost_mode_btn.dart';

String convertDateIntoTime(String date) {
  final twentyFourHours = DateTime.now().subtract(const Duration(hours: 24));
  final oneHourAgo = DateTime.now().subtract(const Duration(minutes: 59));
  final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
  var dateFormat = DateTime.parse(date);
  if (dateFormat.isAfter(oneHourAgo)) {
    return "${format(dateFormat, locale: 'en_short').split('~').last}  ${format(dateFormat, locale: 'en_short') == 'now' ? '' : 'ago'}";
  } else if (dateFormat.isAfter(twentyFourHours)) {
    return DateFormat('h:mm a').format(dateFormat);
  } else if (dateFormat.isAfter(oneWeekAgo)) {
    return "${format(dateFormat, locale: 'en_short').split('~').last} ago";
  } else {
    return DateFormat('d MMMM').format(DateTime.parse(date));
  }
}

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GhostScaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: primaryAppbar(
        title: 'Messages',
        elevation: 0,
        leading: const GhostModeBtn(),
        actions: [
          IconButton(
              onPressed: () => context.read<DashboardProvider>().changePage(1),
              icon: Image.asset(imgAddPost))
        ],
      ),
      body: Consumer<DashboardProvider>(builder: (context, ghost, b) {
        return DefaultTabController(
          length: 2,
          initialIndex: ghost.checkGhostMode ? 1 : 0,
          child: Column(
            children: [
              TabBar(
                onTap: (v) {},
                labelColor: colorPrimaryA05,
                unselectedLabelColor: colorAA3,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
                indicatorColor: Colors.yellow,
                dividerColor: Colors.transparent,
                indicatorPadding:
                    EdgeInsets.symmetric(vertical: 5.h, horizontal: 65.w),
                tabs: const [
                  Tab(
                    text: "Friends",
                  ),
                  Tab(
                    text: "Ghosts",
                  ),
                ],
              ),
              heightBox(15.h),
              const Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    MessageList(),
                    MessageListGhost(),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
