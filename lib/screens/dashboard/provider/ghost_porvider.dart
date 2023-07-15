import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GhostProvider extends ChangeNotifier {
  bool checkGhostMode = false;

  void getGhostValue() async {
    checkGhostMode = await ghostModeOn();
    notifyListeners();
  }

  Future<bool> ghostModeOn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('isGhostEnable') ?? false;
  }

  GhostProvider() {
    ghostModeOn();
    getGhostValue();
  }

  Future toggleGhostMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isOn = sharedPreferences.getBool('isGhostEnable') ?? false;
    sharedPreferences.setBool('isGhostEnable', !isOn);
    checkGhostMode = !isOn;
    notifyListeners();
  }
}
