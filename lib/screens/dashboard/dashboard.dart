import 'package:casarancha/resources/firebase_cloud_messaging.dart';
import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/screens/ghost_posts/ghost_post.dart';
import 'package:casarancha/screens/home/HomeScreen/home_screen.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen.dart';
import 'package:casarancha/screens/profile/ProfileScreen/provider/profile_provider.dart';
import 'package:casarancha/screens/search/search_screen.dart';
import 'package:casarancha/widgets/profle_screen_widgets/dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/dashboard_widget/custom_bottom_nav.dart';
import '../forum/forum.dart';
import '../groups/my_groups_screen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with WidgetsBindingObserver {
  final _dhelper = DynamicLinkHelper();
  final _fcmServices = FirebaseMessagingService();

  @override
  void initState() {
    super.initState();
    _fcmServices.init(context);
    _dhelper.initDynamicLinks(context);
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(milliseconds: 1200), () {
      ProfileProvider().toggleUserOnlineStatus(true);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 1200), () {
        ProfileProvider().toggleUserOnlineStatus(true);
      });
    } else {
      ProfileProvider().toggleUserOnlineStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    return Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          pageSnapping: false,
          controller: dashboardProvider.pageController,
          onPageChanged: (value) {
            dashboardProvider.changePage(value);
          },
          children: [
            HomeScreen(),
            const GhostPosts(),
            SearchScreen(),
            const GroupScreen(),
            const ForumsScreen(),
            const ChatListScreen(),
            const ProfileScreen(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const CustomBottomNavigationBar());
  }
}
