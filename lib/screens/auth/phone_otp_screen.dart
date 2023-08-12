import 'dart:async';

import 'package:casarancha/screens/auth/providers/auth_provider.dart';
import 'package:casarancha/screens/auth/providers/phone_provider.dart';
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
  const PhoneOTPScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);
  final String verificationId;

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
          child: Consumer<PhoneProvider>(builder: (context, prov, b) {
            return ListView(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
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
                            "Please Enter your phone\nnumber below to continue login",
                        fontSize: 16.sp,
                        color: color080,
                        fontWeight: FontWeight.w400,
                      ),
                      heightBox(42.h),
                      OtpFields(controller: prov.otpController),
                      heightBox(20.h),
                      CommonButton(
                        showLoading:
                            context.read<AuthenticationProvider>().isSigningIn,
                        onTap: () {
                          context
                              .read<AuthenticationProvider>()
                              .checkOtpVerification(
                                prov.otpController.text,
                                verificationId,
                              );
                        },
                        text: 'Continue',
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
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
    Key? key,
    this.height,
    this.width,
    required this.controller,
  }) : super(key: key);

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
          // fieldOuterPadding: const EdgeInsets.all(5),
          activeFillColor: colorFDF,
          activeColor: colorFDF,
          disabledColor: colorFDF,
          errorBorderColor: Colors.red,
          inactiveFillColor: colorFDF,
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
