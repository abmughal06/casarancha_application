import 'package:flutter/material.dart';

import 'app_constants.dart';

class GlobalSnackBar {
  final String message;

  const GlobalSnackBar({
    required this.message,
  });

  static show({BuildContext? context, String? message}) {
    ScaffoldMessenger.of(context ?? rootNavigatorKey.currentContext!)
        .showSnackBar(
      SnackBar(
        elevation: 0.0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.black,
        content: Text(message!),
        duration: const Duration(milliseconds: 2750),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0))),
      ),
    );
  }
}
