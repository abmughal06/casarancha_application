import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  late PageController pageController;
  RxBool isShowStoryBtn = true.obs;
  RxBool isShowSocialLogin = true.obs;
  //Observables
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    pageController.addListener(() {
      currentIndex.value =
          pageController.hasClients ? pageController.page?.toInt() ?? 0 : 0;
    });
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();

    pageController.removeListener(() {
      currentIndex.value = 0;
    });
    pageController.dispose();
  }
}
