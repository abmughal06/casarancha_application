import 'package:flutter/material.dart';
class ViewPostViewModel extends ChangeNotifier{
  bool isShowToolTip = false;
  final PageController pageController = PageController();
  int currentIndex = 0;
  onChangePage(pageIndex){
    currentIndex = pageIndex;
    notifyListeners();
  }
  onTapHideShowToolTip(){
    isShowToolTip = !isShowToolTip;
    notifyListeners();
  }

}