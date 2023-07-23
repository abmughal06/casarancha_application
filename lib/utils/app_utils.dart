import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';

import '../resources/color_resources.dart';

import '../widgets/text_widget.dart';
import 'app_constants.dart';
import 'page_transition_utils.dart';

class AppUtils {
  AppUtils._privateConstructor();

  static final AppUtils instance = AppUtils._privateConstructor();

  push({
    required Widget enterPage,
    bool shouldUseRootNavigator = false,
    Function? callback,
  }) {
    ScaffoldMessenger.of(rootNavigatorKey.currentContext!)
        .hideCurrentSnackBar();
    FocusScope.of(rootNavigatorKey.currentContext!).requestFocus(FocusNode());
    Navigator.of(rootNavigatorKey.currentContext!,
            rootNavigator: shouldUseRootNavigator)
        .push(
      SlideLeftRoute(page: enterPage),
    )
        .then((value) {
      callback?.call(value);
    });
  }

  void pushAndClearStack({
    required Widget enterPage,
    bool shouldUseRootNavigator = false,
  }) {
    ScaffoldMessenger.of(rootNavigatorKey.currentContext!)
        .hideCurrentSnackBar();
    Navigator.of(rootNavigatorKey.currentContext!,
            rootNavigator: shouldUseRootNavigator)
        .pushAndRemoveUntil(
            SlideLeftRoute(page: enterPage), (Route<dynamic> route) => false);
  }

  showMessageBlackBG({String? message}) {
    ScaffoldMessenger.of(rootNavigatorKey.currentContext!).showSnackBar(
      SnackBar(
        backgroundColor: colorPrimaryA05,
        duration: const Duration(seconds: 2),
        content: TextWidget(
          text: message,
          fontSize: 14.sp,
          color: colorWhite,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String generateRandomNumber() {
    Random random = Random();
    String result = '';

    for (int i = 0; i < 6; i++) {
      result += random.nextInt(10).toString();
    }

    return result;
  }

  String convertSingleToTwoDigit(String singleDigit) {
    return (int.parse(singleDigit) < 10 ? "0$singleDigit" : singleDigit);
  }

  String convertStringToDateFormat(String stringDate) {
    String subscriptionExpireDate = "";
    subscriptionExpireDate = stringDate;

    DateTime startDateTime =
        DateTime.tryParse(subscriptionExpireDate) ?? DateTime.now();

    subscriptionExpireDate =
        '${startDateTime.day}/${startDateTime.month}/${startDateTime.year} ';

    return subscriptionExpireDate;
  }

  //Date Format : yyyy-MM-dd
  String convertDateToDDMMYYYYFormat({String? dateString}) {
    DateTime dt = DateTime.parse(dateString!).toLocal();
    String date = DateFormat("yyyy-MM-dd hh:mm a").format(dt).toString();
    return date;
  }

  //Date Format : March 25,2020 - 10:30 PM
  String convertDateToMMMDDYYYYFormat({String? dateString}) {
    DateTime dt = DateTime.parse(dateString!).toLocal();
    String date = DateFormat("MMM dd,yyyy hh:mm a").format(dt).toString();
    return date;
  }

  String convertDateToTimeFormat({String? dateString}) {
    DateTime dt = DateTime.parse(dateString!).toLocal();
    String date = DateFormat("hh:mm a").format(dt).toString();
    return date;
  }
}

printLog(msg) {
  if (kDebugMode) {
    print(msg);
  }
}
