import 'dart:io';

import 'package:casarancha/resources/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../text_widget.dart';

class CustomAdaptiveAlertDialog extends StatelessWidget {
  const CustomAdaptiveAlertDialog(
      {super.key,
      required this.alertMsg,
      required this.actiionBtnName,
      required this.onAction,
      this.actionBtnColor,
      this.title});
  final String alertMsg;
  final String actiionBtnName;
  final VoidCallback onAction;
  final Color? actionBtnColor;
  final String? title;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AlertDialog(
        title: Text(title ?? appText(context).strAlert),
        content: Text(alertMsg),
        actions: [
          TextButton(
            child: TextWidget(text: appText(context).strCancel),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            onPressed: onAction,
            child: TextWidget(
              text: actiionBtnName,
              color: actionBtnColor ?? colorPrimaryA05,
            ),
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
        title: Text(title ?? appText(context).strAlert),
        content: Text(alertMsg),
        actions: [
          TextButton(
            child: TextWidget(text: appText(context).strCancel),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            onPressed: onAction,
            child: TextWidget(
              text: actiionBtnName,
              color: actionBtnColor ?? colorPrimaryA05,
            ),
          ),
        ],
      );
    }
  }
}
