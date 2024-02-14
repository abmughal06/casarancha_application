// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LocaleProvider extends ChangeNotifier {
//   String? currentLang;

//   storeUserLang(String locale) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     sharedPreferences.setString('currentLang', locale);
//   }

//   Future<void> getLang() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     currentLang = sharedPreferences.getString("currentLang");
//     notifyListeners();
//   }

//   List<String> allLocales = [
//     'en', // English
//     'es', // Spanish
//     'fr', // French
//     'pt', // Portuguese
//     'ar', // Arabic
//   ];
// }

import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();

  factory LocalizationService() {
    return _instance;
  }

  LocalizationService._internal();

  static final List<String> supportedLanguages = [
    'en',
    'es',
    'fr',
    'ar',
    'pt'
  ]; // Add more as needed
  static final List<String> supportedLanguagesName = [
    'English',
    'Espanol',
    'Francais',
    'Arabic',
    'Portuguese'
  ]; // Add more as needed
  static final List<String> supportedLanguagesFlags = [
    'https://upload.wikimedia.org/wikipedia/en/a/a4/Flag_of_the_United_States.svg',
    'https://upload.wikimedia.org/wikipedia/en/9/9a/Flag_of_Spain.svg',
    'https://upload.wikimedia.org/wikipedia/en/c/c3/Flag_of_France.svg',
    'https://upload.wikimedia.org/wikipedia/commons/0/0d/Flag_of_Saudi_Arabia.svg',
    'https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_Portugal.svg'
  ]; // Add more as needed

  static Future<Locale> getLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String languageCode = prefs.getString('languageCode') ?? 'en';
    return Locale(languageCode);
  }

  static Future<void> setLocale(String languageCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }
}
