import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardProvider extends ChangeNotifier {
  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  ScrollController scrollController = ScrollController();
  ScrollController forumScrollController = ScrollController();
  ScrollController ghostPostScrollController = ScrollController();

  changePage(int page) {
    currentIndex = page;
    pageController.jumpToPage(currentIndex);
    notifyListeners();
  }

  bool checkGhostMode = false;

  void getGhostValue() async {
    checkGhostMode = await ghostModeOn();
    notifyListeners();
  }

  Future<bool> ghostModeOn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('isGhostEnable') ?? false;
  }

  DashboardProvider() {
    ghostModeOn();
    getGhostValue();
  }

  Future toggleGhostMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isOn = sharedPreferences.getBool('isGhostEnable') ?? false;
    sharedPreferences.setBool('isGhostEnable', !isOn);
    checkGhostMode = !isOn;
    changePage(0);
    notifyListeners();
  }
}
