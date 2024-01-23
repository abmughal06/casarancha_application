import 'dart:async';

import 'package:casarancha/screens/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_widget.dart';

class PhoneOTPScreen extends StatelessWidget {
  PhoneOTPScreen({
    super.key,
    required this.verificationId,
  });
  final String verificationId;
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(
            imgOtpBackground,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget(
                      text: "Phone Login",
                      fontSize: 26.sp,
                      color: color13F,
                      fontWeight: FontWeight.w800,
                    ),
                    heightBox(4.h),
                    TextWidget(
                      textAlign: TextAlign.center,
                      text:
                          "Please Enter your verification\ncode below to continue login",
                      fontSize: 16.sp,
                      color: color080,
                      fontWeight: FontWeight.w400,
                    ),
                    heightBox(42.h),
                    Align(
                        alignment: Alignment.center,
                        child: OtpFields(controller: otpController)),
                    heightBox(20.h),
                    Consumer<AuthenticationProvider>(
                        builder: (context, auth, b) {
                      return CommonButton(
                        showLoading: auth.isSigningIn,
                        onTap: () {
                          auth.checkOtpVerification(
                            otpController.text,
                            verificationId,
                          );
                        },
                        text: 'Continue',
                        width: double.infinity,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

class OtpFields extends StatelessWidget {
  final TextEditingController controller;
  final errorController = StreamController<ErrorAnimationType>();
  final double? height;
  final double? width;
  OtpFields({
    super.key,
    this.height,
    this.width,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: PinCodeTextField(
        appContext: context,
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: color221,
        ),
        length: 6,
        cursorHeight: 18,
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
        onChanged: (v) {},
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(12),
          fieldHeight: height,
          fieldWidth: width,
          activeFillColor: colorF03,
          activeColor: colorFDF,
          disabledColor: colorF03,
          errorBorderColor: Colors.red,
          inactiveFillColor: colorF03,
          selectedFillColor: colorFDF,
          selectedColor: colorFDF,
          inactiveColor: colorFDF,
          borderWidth: 1,
        ),
        cursorColor: Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        errorAnimationController: errorController,
        controller: controller,
        keyboardType: TextInputType.number,
        boxShadows: const [
          BoxShadow(
            offset: Offset(0, 1),
            color: Colors.black12,
            blurRadius: 10,
          )
        ],
      ),
    );
  }
}
