import 'package:flutter/material.dart';

class ChatListController extends ChangeNotifier {
  late TextEditingController searchController;

  ChatListController() {
    searchController = TextEditingController();
  }

  void searchText(value) {
    if (value.isNotEmpty) {
      notifyListeners();
    }
  }
}
