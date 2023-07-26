import 'package:flutter/material.dart';

class ChatListController extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  TextEditingController ghostSearchController = TextEditingController();

  void searchText(value) {
    notifyListeners();
  }
}
