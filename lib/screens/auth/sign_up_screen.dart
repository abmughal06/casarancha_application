import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/auth/providers/auth_provider.dart';
import 'package:casarancha/screens/auth/providers/register_privder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../resources/color_resources.dart';
import '../../resources/localization_text_strings.dart';

import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_editing_widget.dart';
import '../../widgets/text_widget.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              imgSignBack,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(
                20.w,
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextWidget(
                    text: strSignUpSp,
                    fontSize: 26.sp,
                    color: color13F,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                heightBox(10.w),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextWidget(
                    text: strCreateYourNewAccount,
                    fontSize: 16.sp,
                    color: color080,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                heightBox(20.w),
                Consumer<RegisterProvider>(
                    builder: (context, registerProvider, b) {
                  return Focus(
                    focusNode: registerProvider.emailFocus,
                    onFocusChange: (hasFocus) {
                      registerProvider.emailFocusChange();
                    },
                    child: TextEditingWidget(
                      controller: _emailController,
                      isShadowEnable: false,
                      hint: strEmailAddress,
                      color: registerProvider.emailFillClr ?? colorFF3,
                      fieldBorderClr: registerProvider.emailBorderClr,
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (val) =>
                          FocusScope.of(context).nextFocus(),
                      suffixIconWidget: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: SvgPicture.asset(
                            registerProvider.icEmailSvg ?? icDeselectEmail),
                      ),
                    ),
                  );
                }),
                heightBox(10.w),
                Consumer<RegisterProvider>(
                    builder: (context, registerProvider, b) {
                  return Focus(
                    focusNode: registerProvider.passwordFocus,
                    onFocusChange: (hasFocus) {
                      registerProvider.pwdFocusChange();
                    },
                    child: TextEditingWidget(
                      controller: _passwordController,
                      hint: strPassword,
                      isShadowEnable: false,
                      fieldBorderClr: registerProvider.passwordBorderClr,
                      passwordVisible: registerProvider.passwordVisible,
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      color: registerProvider.passwordFillClr ?? colorFF3,
                      onFieldSubmitted: (val) =>
                          FocusScope.of(context).nextFocus(),
                      suffixIconWidget: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: GestureDetector(
                          onTap: () => registerProvider.setPwdVisibility(),
                          child: SvgPicture.asset(
                              registerProvider.icPasswordSvg ?? icHidePassword),
                        ),
                      ),
                    ),
                  );
                }),
                heightBox(10.w),
                Consumer<RegisterProvider>(
                    builder: (context, registerProvider, b) {
                  return Focus(
                    focusNode: registerProvider.confirmPwdFocus,
                    onFocusChange: (hasFocus) {
                      registerProvider.confirmPwdFocusChange();
                    },
                    child: TextEditingWidget(
                      controller: _confirmPwdController,
                      hint: strConfirmPassword,
                      isShadowEnable: false,
                      fieldBorderClr: registerProvider.confirmPwdBorderClr,
                      passwordVisible: registerProvider.confirmPasswordVisible,
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      color: registerProvider.confirmPwdFillClr ?? colorFF3,
                      onFieldSubmitted: (val) =>
                          FocusScope.of(context).unfocus(),
                      suffixIconWidget: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: GestureDetector(
                          onTap: () =>
                              registerProvider.setConfirmPwdVisibility(),
                          child: SvgPicture.asset(
                            registerProvider.icConfirmPwdSvg ?? icHidePassword,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                heightBox(20.w),
                Consumer<AuthenticationProvider>(
                  builder: (context, registerProvider, b) {
                    return CommonButton(
                      text: strSignUpSp,
                      width: double.infinity,
                      showLoading: registerProvider.isSigningIn,
                      onTap: () {
                        context.read<AuthenticationProvider>().signUp(
                            email: _emailController.text,
                            password: _passwordController.text,
                            confirmPassword: _confirmPwdController.text);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: strHaveAnAccount,
                      fontSize: 12.sp,
                      color: color080,
                      fontWeight: FontWeight.w500,
                    ),
                    widthBox(4.w),
                    TextWidget(
                      onTap: () => Get.back(),
                      text: strLogin,
                      fontSize: 16.sp,
                      color: color13F,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextWidget(
                    onTap: () {},
                    text: strRexFamily,
                    fontSize: 15.sp,
                    color: colorPrimaryA05,
                    fontWeight: FontWeight.w400,
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
