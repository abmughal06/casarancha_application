import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  String? currentLang;

  storeUserLang(String locale) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('currentLang', locale);
  }

  Future<void> getLang() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    currentLang = sharedPreferences.getString("currentLang");
    notifyListeners();
  }

  List<String> allLocales = [
    'en', // English
    'es', // Spanish
    'fr', // French
    'pt', // Portuguese
    'ar', // Arabic
  ];
}
