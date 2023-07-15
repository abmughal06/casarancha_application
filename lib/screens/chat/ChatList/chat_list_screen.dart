import 'package:casarancha/screens/dashboard/provider/ghost_porvider.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../resources/color_resources.dart';
import '../../../resources/image_resources.dart';
import '../../../widgets/chat_screen_widgets/frieds_chat_list.dart';
import '../../../widgets/chat_screen_widgets/ghost_chat_list.dart';
import '../../dashboard/ghost_mode_btn.dart';

String convertDateIntoTime(String date) {
  var time = DateFormat('MMMM d, h:mm a').format(DateTime.parse(date));
  return time;
}

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: primaryAppbar(
        title: 'Messages',
        elevation: 0,
        leading: const GhostModeBtn(),
        actions: [IconButton(onPressed: () {}, icon: Image.asset(imgAddPost))],
      ),
      body: Consumer<GhostProvider>(builder: (context, ghost, b) {
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
                indicatorPadding:
                    const EdgeInsets.symmetric(horizontal: 75, vertical: 5),
                tabs: const [
                  Tab(
                    text: "Friends",
                  ),
                  Tab(
                    text: "Ghosts",
                  ),
                ],
              ),
              const SizedBox(height: 5),
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
