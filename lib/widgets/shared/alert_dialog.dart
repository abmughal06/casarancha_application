import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../text_widget.dart';

class CustomAdaptiveAlertDialog extends StatelessWidget {
  const CustomAdaptiveAlertDialog(
      {Key? key,
      required this.alertMsg,
      required this.actiionBtnName,
      required this.onAction,
      this.actionBtnColor,
      this.title})
      : super(key: key);
  final String alertMsg;
  final String actiionBtnName;
  final VoidCallback onAction;
  final Color? actionBtnColor;
  final String? title;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AlertDialog(
        title: Text(title ?? 'Alert'),
        content: Text(alertMsg),
        actions: [
          TextButton(
            child: const TextWidget(text: 'Cancel'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            onPressed: onAction,
            child: TextWidget(
              text: actiionBtnName,
              color: actionBtnColor ?? Colors.red,
            ),
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
        title: Text(title ?? 'Alert'),
        content: Text(alertMsg),
        actions: [
          TextButton(
            child: const TextWidget(text: 'Cancel'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            onPressed: onAction,
            child: TextWidget(
              text: actiionBtnName,
              color: actionBtnColor ?? Colors.red,
            ),
          ),
        ],
      );
    }
  }
}
