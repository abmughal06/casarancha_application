import 'dart:io';
import 'package:casarancha/screens/auth/phone_login_screen.dart';
import 'package:casarancha/screens/auth/providers/auth_provider.dart';
import 'package:casarancha/screens/auth/providers/login_provider.dart';
import 'package:casarancha/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_editing_widget.dart';
import '../../widgets/text_widget.dart';
import 'forgot_password_screen.dart' as pass;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: 170,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  imgSignBack,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(
                      top: 5, left: 20.w, bottom: 20.w, right: 20.w),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextWidget(
                        text: strWelcome,
                        fontSize: 20.sp,
                        color: color13F,
                        textHeight: 1.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    heightBox(8.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextWidget(
                        text: strPleaseSignInYouAccount,
                        fontSize: 16.sp,
                        color: color080,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    heightBox(15.h),
                    Consumer<LoginProvider>(
                        builder: (context, emailProvider, b) {
                      return Focus(
                        focusNode: emailProvider.emailFocus,
                        onFocusChange: (hasFocus) {
                          emailProvider.emailFocusChange();
                        },
                        child: TextEditingWidget(
                          controller: _emailController,
                          hint: strEmailAddress,
                          color: emailProvider.emailFillClr ?? colorFF3,
                          fieldBorderClr: emailProvider.emailBorderClr,
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (val) =>
                              FocusScope.of(context).nextFocus(),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          suffixIconWidget: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: SvgPicture.asset(
                                emailProvider.icEmailSvg ?? icDeselectEmail),
                          ),
                        ),
                      );
                    }),
                    heightBox(16.h),
                    Consumer<LoginProvider>(
                        builder: (context, passwordProvider, b) {
                      return Focus(
                        focusNode: passwordProvider.passwordFocus,
                        onFocusChange: (hasFocus) {
                          passwordProvider.pwdFocusChange();
                        },
                        child: TextEditingWidget(
                          controller: _passwordController,
                          hint: strPassword,
                          fieldBorderClr: passwordProvider.passwordBorderClr,
                          textInputType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          // onFieldSubmitted: (str) =>
                          //     push(context, enterPage: const SignUpScreen()),
                          passwordVisible: passwordProvider.passwordVisible,
                          color: passwordProvider.passwordFillClr ?? colorFF3,
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                          suffixIconWidget: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: GestureDetector(
                              onTap: () => passwordProvider.setPwdVisibility(),
                              child: SvgPicture.asset(
                                passwordProvider.icPasswordSvg ??
                                    icHidePassword,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    heightBox(24.h),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () => Get.to(
                          () => const pass.ForgotPasswordScreen(),
                        ),
                        child: TextWidget(
                          text: strForgotPassword,
                          fontSize: 14.sp,
                          color: color080,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    heightBox(24.h),
                    CommonButton(
                      onTap: () {
                        context.read<AuthenticationProvider>().signIn(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                      },
                      text: strSignInSp,
                      width: double.infinity,
                    ),
                    heightBox(26.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        horizonLine(width: 80.w, horizontalMargin: 18.w),
                        TextWidget(
                          text: strWith,
                          fontSize: 14.sp,
                          color: color080,
                          fontWeight: FontWeight.w500,
                        ),
                        horizonLine(
                          width: 80.w,
                          horizontalMargin: 18.w,
                        ),
                      ],
                    ),
                    heightBox(24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => PhoneLoginScreen());
                          },
                          child: Container(
                            height: 40.w,
                            width: 40.w,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Icon(Icons.phone_iphone,
                                color: Colors.white, size: 26.sp),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: InkWell(
                            onTap: () {
                              context
                                  .read<AuthenticationProvider>()
                                  .callGoogleSignIn();
                            },
                            child: Container(
                                height: 40.w,
                                width: 40.w,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 0),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          color: Colors.grey.shade300)
                                    ]),
                                child: Image.asset(imgGoogleSignIn)),
                          ),
                        ),
                        Platform.isIOS
                            ? Padding(
                                padding: EdgeInsets.only(right: 12.w),
                                child: InkWell(
                                  onTap: () {
                                    context
                                        .read<AuthenticationProvider>()
                                        .callAppleSignIn();
                                  },
                                  child: Container(
                                    height: 40.w,
                                    width: 40.w,
                                    padding: const EdgeInsets.only(bottom: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: const ImageIcon(
                                      AssetImage(imgAppleSignIn),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        // Padding(
                        //   padding: EdgeInsets.only(right: 12.w),
                        //   child: InkWell(
                        //     onTap: () {
                        //       context
                        //           .read<AuthenticationProvider>()
                        //           .callTwitterSignIn();
                        //     },
                        //     child: Container(
                        //       height: 40.w,
                        //       width: 40.w,
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(7),
                        //           image: const DecorationImage(
                        //               image: AssetImage(imgTwitterSignIn))),
                        //     ),
                        //   ),
                        // ),
                        InkWell(
                          onTap: () {
                            context
                                .read<AuthenticationProvider>()
                                .callFaceBookSignIn();
                          },
                          child: Container(
                            height: 40.w,
                            width: 40.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                image: const DecorationImage(
                                    image: AssetImage(imgFaceBookSignIn))),
                          ),
                        ),
                      ],
                    ),
                    heightBox(24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: strYouDontHaveAccount,
                          fontSize: 12.sp,
                          color: color080,
                          fontWeight: FontWeight.w500,
                        ),
                        widthBox(4.w),
                        TextWidget(
                          onTap: () => Get.to(() => SignUpScreen()),
                          text: strSignUp,
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
                        fontFamily: "PrometoTrial",
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
        ),
        Consumer<AuthenticationProvider>(
          builder: (context, prov, b) {
            if (prov.isSigningIn) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}

/* 
twitter 
API KEY : HaPI0dQRItR56omPwCGmNBoVi
API KEY SECRET : Y3oaX4cUFdMldsr3ZefKxOjC8WVoqVhHFUloOTTZ4y1p5mCf3P
API KEY TOKEN : AAAAAAAAAAAAAAAAAAAAAG89lQEAAAAADtMQgZYB9lE4Ur5VF0PHX6EJqvs%3DJpZlttWUWJyYGg8uhQhRFCaFGVRUcmdulDQjQ42Ns6u7lTVMwV
 */ /* 
 SU7uog+SDftgfrZmG+QqL+BWDas=
 VzSiQcXRmi2kyjzcA+mYLEtbGVs=

 */




