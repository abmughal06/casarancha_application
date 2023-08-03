import 'package:casarancha/screens/chat/ChatList/chat_list_screen.dart';
import 'package:casarancha/screens/dashboard/provider/dashboard_provider.dart';
import 'package:casarancha/screens/home/HomeScreen/home_screen.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen.dart';
import 'package:casarancha/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/dashboard_widget/custom_bottom_nav.dart';
import '../forum/forum.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    return Scaffold(
        body: PageView(
          controller: dashboardProvider.pageController,
          onPageChanged: (value) {},
          children: const [
            HomeScreen(),
            SearchScreen(),
            GroupScreen(),
            ForumsScreen(),
            ChatListScreen(),
            ProfileScreen(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const CustomBottomNavigationBar());
  }
}
