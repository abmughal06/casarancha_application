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

import 'package:casarancha/resources/image_resources.dart';
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
    icFlagUs,
    icFlagEquatorial,
    icFlagGabon,
    icFlagSaudia,
    icFlagCaboVerde
  ]; // Add more as needed

  static String getCurrentLanguageFlag(String locale) {
    switch (locale) {
      case 'en':
        return icFlagUs;
      case 'es':
        return icFlagEquatorial;
      case 'fr':
        return icFlagGabon;
      case 'ar':
        return icFlagSaudia;
      case 'pt':
        return icFlagCaboVerde;
      default:
        return icFlagUs;
    }
  }

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
