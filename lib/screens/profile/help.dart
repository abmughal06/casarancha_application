import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/widgets/common_button.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/shared/alert_dialog.dart';
import 'package:casarancha/widgets/text_editing_widget.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  final helpTextController = TextEditingController();

  void sendHelpMail() {
    setState(() {
      helpTextController.clear();
    });
    // GlobalSnackBar.show(
    //     message: 'Your message is send to admin, he will respond to you soon');
    showDialog(
      context: context,
      builder: (_) => CustomAdaptiveAlertDialog(
        alertMsg: appText(context).strAdminContact,
        actiionBtnName: appText(context).strOk,
        onAction: () {
          Get.back();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: appText(context).strHelp),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextEditingWidget(
          controller: helpTextController,
          borderRadius: 12,
          isBorderEnable: true,
          fieldBorderClr: color221.withOpacity(0.2),
          color: colorFF7,
          maxLines: 7,
          maxLength: 300,
          hint: appText(context).strHelpInfo,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CommonButton(
        text: appText(context).strSend,
        horizontalOutMargin: 20,
        verticalOutMargin: 10,
        onTap: sendHelpMail,
        height: 52,
      ),
    );
  }
}
