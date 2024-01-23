import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/auth/providers/auth_provider.dart';
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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _confirmPasswordController.dispose();
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
                Focus(
                  focusNode: _emailFocus,
                  onFocusChange: (hasFocus) {
                    setState(() {});
                  },
                  child: TextEditingWidget(
                    controller: _emailController,
                    hint: strEmailAddress,
                    color: _emailFocus.hasFocus ? colorFDF : colorFF3,
                    fieldBorderClr: _emailFocus.hasFocus ? colorF73 : color080,
                    isBorderEnable: true,
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (val) =>
                        FocusScope.of(context).nextFocus(),
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    suffixIconWidget: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SvgPicture.asset(_emailFocus.hasFocus
                          ? icSelectEmail
                          : icDeselectEmail),
                    ),
                  ),
                ),
                heightBox(10.h),
                Focus(
                  focusNode: _passwordFocus,
                  onFocusChange: (hasFocus) {
                    setState(() {});
                  },
                  child: TextEditingWidget(
                    controller: _passwordController,
                    hint: strPassword,
                    fieldBorderClr: _passwordFocus.hasFocus ? colorF73 : null,
                    textInputType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    passwordVisible: !isPasswordVisible,
                    color: _passwordFocus.hasFocus ? colorFDF : colorFF3,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    suffixIconWidget: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          isPasswordVisible = !isPasswordVisible;
                          setState(() {});
                        },
                        child: SvgPicture.asset(
                          isPasswordVisible ? icShowPassword : icHidePassword,
                        ),
                      ),
                    ),
                  ),
                ),
                heightBox(10.h),
                Focus(
                  focusNode: _confirmPasswordFocus,
                  onFocusChange: (hasFocus) {
                    setState(() {});
                  },
                  child: TextEditingWidget(
                    controller: _confirmPasswordController,
                    hint: "Confirm $strPassword",
                    fieldBorderClr:
                        _confirmPasswordFocus.hasFocus ? colorF73 : null,
                    textInputType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    passwordVisible: !isConfirmPasswordVisible,
                    color: _confirmPasswordFocus.hasFocus ? colorFDF : colorFF3,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    suffixIconWidget: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                          setState(() {});
                        },
                        child: SvgPicture.asset(
                          isConfirmPasswordVisible
                              ? icShowPassword
                              : icHidePassword,
                        ),
                      ),
                    ),
                  ),
                ),
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
                            confirmPassword: _confirmPasswordController.text);
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
