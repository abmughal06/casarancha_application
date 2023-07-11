import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  changePage(int page) {
    currentIndex = page;
    pageController.jumpToPage(currentIndex);
    notifyListeners();
  }
}
