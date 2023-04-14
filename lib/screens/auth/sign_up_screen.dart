import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/auth/setup_profile_details.dart';
import 'package:casarancha/screens/dashboard/dashboard.dart';
import 'package:casarancha/screens/dashboard/dashboard_controller.dart';

import 'package:casarancha/utils/snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../resources/color_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../utils/app_constants.dart';

import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_editing_widget.dart';
import '../../widgets/text_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();

  bool passwordVisible = true;
  bool confirmPasswordVisible = true;
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPwdFocus = FocusNode();

  String? icUsernameSvg, icEmailSvg, icPasswordSvg, icConfirmPwdSvg;
  Color? usernameFillClr,
      emailFillClr,
      passwordFillClr,
      confirmPwdFillClr,
      usernameBorderClr,
      emailBorderClr,
      passwordBorderClr,
      confirmPwdBorderClr;

  setPwdVisibility() {
    passwordVisible = !passwordVisible;
    icPasswordSvg == icShowPassword
        ? icPasswordSvg = icHidePassword
        : icPasswordSvg = icShowPassword;
    setState(() {});
  }

  setConfirmPwdVisibility() {
    confirmPasswordVisible = !confirmPasswordVisible;
    icConfirmPwdSvg == icShowPassword
        ? icConfirmPwdSvg = icHidePassword
        : icConfirmPwdSvg = icShowPassword;
    setState(() {});
  }

  bool isRegistering = false;

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

  setPwdFocusChange() {
    if (passwordFocus.hasFocus) {
      // icPasswordSvg = icSelectLock;
      passwordFillClr = colorFDF;
      passwordBorderClr = colorF73;
    } else {
      // icPasswordSvg = icDeselectLock;
      passwordFillClr = colorFF3;
      passwordBorderClr = null;
    }
    setState(() {});
  }

  setConfirmPwdFocusChange() {
    if (confirmPwdFocus.hasFocus) {
      // icConfirmPwdSvg = icSelectLock;
      confirmPwdFillClr = colorFDF;
      confirmPwdBorderClr = colorF73;
    } else {
      // icConfirmPwdSvg = icDeselectLock;
      confirmPwdFillClr = colorFF3;
      confirmPwdBorderClr = null;
    }
    setState(() {});
  }

  void _emailFocusChange(BuildContext context) {
    setEmailFocusChange();
  }

  void _pwdFocusChange(BuildContext context) {
    setPwdFocusChange();
  }

  void _confirmPwdFocusChange(BuildContext context) {
    setConfirmPwdFocusChange();
  }

  bool _checkValidData() {
    if (_emailController.text.isEmpty) {
      GlobalSnackBar.show(
          context: context, message: 'Please enter $strEmailAddress');
      return false;
    } else if (!EmailValidator.validate(_emailController.text.trim())) {
      GlobalSnackBar.show(
          context: context, message: 'Please enter valid $strEmailAddress');
      return false;
    } else if (_passwordController.text.isEmpty) {
      GlobalSnackBar.show(
          context: context, message: 'Please enter $strPassword');
      return false;
    } else if (_passwordController.text.length < AppConstant.passwordMinText) {
      GlobalSnackBar.show(
          context: context,
          message:
              '$strPassword should be minimum ${AppConstant.passwordMinText} characters');
      return false;
    } else if (_confirmPwdController.text.isEmpty) {
      GlobalSnackBar.show(
          context: context, message: 'Please enter $strConfirmPassword');
      return false;
    } else if (_passwordController.text != _confirmPwdController.text) {
      GlobalSnackBar.show(
          context: context,
          message: '$strPassword & $strConfirmPassword must be same');
      return false;
    }
    return true;
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
                  focusNode: emailFocus,
                  onFocusChange: (hasFocus) {
                    _emailFocusChange(context);
                  },
                  child: TextEditingWidget(
                    controller: _emailController,
                    isShadowEnable: false,
                    hint: strEmailAddress,
                    // onChanged: (val) async {
                    //   // Future.delayed(const Duration(milliseconds: 300),
                    //   //     () async {
                    //   //   if (await AppConstant.checkNetwork()) {
                    //   //     isValidEmail = await CommonServices().checkAbility(
                    //   //         strValue: val,
                    //   //         abilityType: CheckAbilityTypeEnum.email);
                    //   //     signupScreenViewModel.onNotifyListeners();
                    //   //   }
                    //   // });
                    // },
                    color: emailFillClr ?? colorFF3,
                    fieldBorderClr: emailBorderClr,
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (val) =>
                        FocusScope.of(context).nextFocus(),
                    // onEditingComplete: () =>
                    //     FocusScope.of(context).nextFocus(),
                    suffixIconWidget: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SvgPicture.asset(icEmailSvg ?? icDeselectEmail),
                    ),
                  ),
                ),
                heightBox(10.w),
                Focus(
                  focusNode: passwordFocus,
                  onFocusChange: (hasFocus) {
                    _pwdFocusChange(context);
                  },
                  child: TextEditingWidget(
                    controller: _passwordController,
                    hint: strPassword,
                    isShadowEnable: false,
                    fieldBorderClr: passwordBorderClr,
                    passwordVisible: passwordVisible,
                    textInputType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    color: passwordFillClr ?? colorFF3,
                    onFieldSubmitted: (val) =>
                        FocusScope.of(context).nextFocus(),
                    // onEditingComplete: () =>
                    //     FocusScope.of(context).nextFocus(),
                    suffixIconWidget: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: GestureDetector(
                        onTap: () => setPwdVisibility(),
                        child:
                            SvgPicture.asset(icPasswordSvg ?? icHidePassword),
                      ),
                    ),
                  ),
                ),
                heightBox(10.w),
                Focus(
                  focusNode: confirmPwdFocus,
                  onFocusChange: (hasFocus) {
                    _confirmPwdFocusChange(context);
                  },
                  child: TextEditingWidget(
                    controller: _confirmPwdController,
                    hint: strConfirmPassword,
                    isShadowEnable: false,
                    fieldBorderClr: confirmPwdBorderClr,
                    passwordVisible: confirmPasswordVisible,
                    textInputType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    color: confirmPwdFillClr ?? colorFF3,
                    onFieldSubmitted: (val) => FocusScope.of(context).unfocus(),
                    // onEditingComplete: () =>
                    //     FocusScope.of(context).unfocus(),
                    suffixIconWidget: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: GestureDetector(
                        onTap: () => setConfirmPwdVisibility(),
                        child: SvgPicture.asset(
                          icConfirmPwdSvg ?? icHidePassword,
                        ),
                      ),
                    ),
                  ),
                ),
                heightBox(20.w),
                CommonButton(
                  text: strSignUpSp,
                  width: double.infinity,
                  showLoading: isRegistering,
                  onTap: () async {
                    if (_checkValidData()) {
                      setState(() {
                        isRegistering = true;
                      });
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                        await Future.delayed(
                          const Duration(
                            seconds: 1,
                          ),
                        );

                        Get.offAll(() => const SetupProfileScreen());
                      } catch (e) {
                        GlobalSnackBar.show(message: e.toString());
                      }
                      setState(() {
                        isRegistering = false;
                      });
                    }
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
