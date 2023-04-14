import 'package:flutter/material.dart';

class CommonViewModel with ChangeNotifier {
  bool isLoading = false;

  onStartLoader() {
    isLoading = true;
    notifyListeners();
  }

  onStopLoader() {
    isLoading = false;
    notifyListeners();
  }

  onNotifyListeners() {
    notifyListeners();
  }
}
