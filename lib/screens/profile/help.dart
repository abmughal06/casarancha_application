import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/widgets/common_button.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_editing_widget.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: appText(context).strHelp),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextEditingWidget(
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
        height: 52,
      ),
    );
  }
}
