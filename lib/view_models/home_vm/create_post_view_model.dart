import 'package:flutter/material.dart';

class CreatePostViewModel extends ChangeNotifier {
  bool isCurrentTabSel = true;
  int photoTab = 0, musicTab = 1, quoteTab = 2;
  int indexSelTab = 0;

  onTapTab({required int index}) {
    indexSelTab = index;
    // isCurrentTabSel = !isCurrentTabSel;
    notifyListeners();
  }
}
