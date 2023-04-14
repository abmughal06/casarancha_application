import 'package:casarancha/resources/image_resources.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../resources/color_resources.dart';
import '../../resources/localization_text_strings.dart';

import '../../utils/app_constants.dart';
import '../../utils/snackbar.dart';

import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_editing_widget.dart';
import '../../widgets/text_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  String? icEmailSvg;
  Color? emailFillClr, emailBorderClr;

  var isLoading = false;
  setEmailFocusChange() {
    if (emailFocus.hasFocus) {
      icEmailSvg = icSelectEmail;
      emailFillClr = colorFDF;
      emailBorderClr = colorF73;
    } else {
      icEmailSvg = icDeselectEmail;
      emailFillClr = colorFF3;
      emailBorderClr = null;
    }
    setState(() {});
  }

  void _emailFocusChange(BuildContext context) {
    setEmailFocusChange();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget(
                        text: strForgotPassword,
                        fontSize: 26.sp,
                        color: color13F,
                        fontWeight: FontWeight.w800,
                      ),
                      heightBox(4.h),
                      TextWidget(
                        textAlign: TextAlign.center,
                        text: strEnterEmail,
                        fontSize: 16.sp,
                        color: color080,
                        fontWeight: FontWeight.w400,
                      ),
                      heightBox(42.h),
                      Focus(
                        focusNode: emailFocus,
                        onFocusChange: (hasFocus) {
                          _emailFocusChange(context);
                        },
                        child: TextEditingWidget(
                          controller: _emailController,
                          isShadowEnable: false,
                          hint: strEmailAddress,
                          color: emailFillClr ?? colorFF3,
                          fieldBorderClr: emailBorderClr,
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          // onFieldSubmitted: ,
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                          suffixIconWidget: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child:
                                SvgPicture.asset(icEmailSvg ?? icDeselectEmail),
                          ),
                        ),
                      ),
                      heightBox(20.h),
                      CommonButton(
                        showLoading: isLoading,
                        onTap: () async {
                          if (_emailController.text.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                email: _emailController.text.trim(),
                              );
                              GlobalSnackBar.show(
                                context: context,
                                message:
                                    'Please! check your email to reset your password',
                              );
                              Get.back();
                              setState(() {
                                isLoading = false;
                              });
                            } catch (e) {
                              GlobalSnackBar.show(
                                context: context,
                                message: e.toString(),
                              );
                            }
                          } else {
                            GlobalSnackBar.show(
                              context: context,
                              message: "Please Enter $strEmailAddress",
                            );
                          }
                        },
                        text: strSendNow,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
