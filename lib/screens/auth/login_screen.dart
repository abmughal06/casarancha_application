import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:casarancha/screens/auth/setup_profile_details.dart';
import 'package:casarancha/screens/auth/sign_up_screen.dart';
import 'package:casarancha/screens/dashboard/dashboard.dart';
import 'package:casarancha/screens/dashboard/dashboard_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../utils/snackbar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_editing_widget.dart';
import '../../widgets/text_widget.dart';
import 'forgot_password_screen.dart' as pass;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isSigningIn = false;

  bool passwordVisible = true;
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  String? icEmailSvg, icPasswordSvg;
  Color? emailFillClr, passwordFillClr, emailBorderClr, passwordBorderClr;
  DashboardController dashboardController = Get.find<DashboardController>();
  setPwdVisibility() {
    passwordVisible = !passwordVisible;
    icPasswordSvg == icShowPassword
        ? icPasswordSvg = icHidePassword
        : icPasswordSvg = icShowPassword;
    setState(() {});
  }

  onFieldFocusChange() {
    setState(() {});
  }

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
    }
    return true;
  }

  void _emailFocusChange(BuildContext context) {
    setEmailFocusChange();
  }

  void _pwdFocusChange(BuildContext context) {
    setPwdFocusChange();
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
                    Focus(
                      focusNode: emailFocus,
                      onFocusChange: (hasFocus) {
                        _emailFocusChange(context);
                      },
                      child: TextEditingWidget(
                        controller: _emailController,
                        hint: strEmailAddress,
                        color: emailFillClr ?? colorFF3,
                        fieldBorderClr: emailBorderClr,
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (val) =>
                            FocusScope.of(context).nextFocus(),
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        suffixIconWidget: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child:
                              SvgPicture.asset(icEmailSvg ?? icDeselectEmail),
                        ),
                      ),
                    ),
                    heightBox(16.h),
                    Focus(
                      focusNode: passwordFocus,
                      onFocusChange: (hasFocus) {
                        _pwdFocusChange(context);
                      },
                      child: TextEditingWidget(
                        controller: _passwordController,
                        hint: strPassword,
                        fieldBorderClr: passwordBorderClr,
                        textInputType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        // onFieldSubmitted: (str) =>
                        //     push(context, enterPage: const SignUpScreen()),
                        passwordVisible: passwordVisible,
                        color: passwordFillClr ?? colorFF3,
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        suffixIconWidget: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: GestureDetector(
                            onTap: () => setPwdVisibility(),
                            child: SvgPicture.asset(
                              icPasswordSvg ?? icHidePassword,
                            ),
                          ),
                        ),
                      ),
                    ),
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
                      onTap: () async {
                        if (_checkValidData()) {
                          setState(() {
                            isSigningIn = true;
                          });

                          try {
                            final userData = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );

                            await isSetupProfile(userData.user?.uid);
                          } catch (e) {
                            GlobalSnackBar.show(
                              context: context,
                              message: e.toString(),
                            );
                            setState(() {
                              isSigningIn = false;
                            });
                          }
                        }
                      },
                      text: strSignInSp,
                      width: double.infinity,
                    ),
                    heightBox(26.h),
                    Obx(() => dashboardController.isShowSocialLogin.value
                        ? Row(
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
                          )
                        : Container()),
                    Obx(
                      () => dashboardController.isShowSocialLogin.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Platform.isIOS
                                    ? InkWell(
                                        onTap: () async {
                                          setState(() {
                                            isSigningIn = true;
                                          });
                                          try {
                                            UserCredential? cred =
                                                await callAppleSignIn();

                                            isSetupProfile(cred?.user?.uid);
                                          } catch (e) {
                                            print(e);
                                          }

                                          setState(() {
                                            isSigningIn = false;
                                          });
                                        },
                                        child: Container(
                                          height: 40.w,
                                          width: 40.w,
                                          padding:
                                              const EdgeInsets.only(bottom: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: const ImageIcon(
                                            AssetImage(imgAppleSignIn),
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w),
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isSigningIn = true;
                                      });
                                      UserCredential? credential =
                                          await callGoogleSignIn();
                                      print(credential);

                                      await isSetupProfile(
                                          credential?.user?.uid);
                                      setState(() {
                                        isSigningIn = false;
                                      });
                                    },
                                    child: Container(
                                        height: 40.w,
                                        width: 40.w,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7),
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
                                Padding(
                                  padding: EdgeInsets.only(right: 12.w),
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isSigningIn = true;
                                      });
                                      UserCredential? credential =
                                          await callTwitterSignIn();
                                      print(credential);

                                      await isSetupProfile(
                                          credential?.user?.uid);
                                      setState(() {
                                        isSigningIn = false;
                                      });
                                    },
                                    child: Container(
                                      height: 40.w,
                                      width: 40.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  imgTwitterSignIn))),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      isSigningIn = true;
                                    });
                                    UserCredential? credential =
                                        await callFaceBookSignIn();
                                    print(credential);

                                    await isSetupProfile(credential?.user?.uid);
                                    setState(() {
                                      isSigningIn = false;
                                    });
                                  },
                                  child: Container(
                                    height: 40.w,
                                    width: 40.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        image: const DecorationImage(
                                            image:
                                                AssetImage(imgFaceBookSignIn))),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                    const SizedBox(height: 10),
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
                          onTap: () => Get.to(() => const SignUpScreen()),
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
        if (isSigningIn)
          const Center(
              child: CircularProgressIndicator(
            color: colorPrimaryA05,
          ))
      ],
    );
  }

  isSetupProfile(String? userId) async {
    if (userId != null) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      if (document.exists) {
        Get.offAll(() => const DashBoard());
      } else {
        Get.offAll(() => const SetupProfileScreen());
      }
    }
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
Future<UserCredential?> callGoogleSignIn() async {
  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? signInAccount = await googleSignIn.signIn();
  if (signInAccount != null) {
    try {
      GoogleSignInAuthentication googleSignInAuthentication =
          await signInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Error in callGoogleSignIn => $e");
    }
  }
  return null;
}

Future<UserCredential?> callFaceBookSignIn() async {
  try {
    LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: const ['email', 'public_profile']);

    if (loginResult.status == LoginStatus.success) {
      AuthCredential credential =
          FacebookAuthProvider.credential(loginResult.accessToken?.token ?? "");
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  } catch (e) {
    print("Error in callFaceBookSignIn => $e");
  }
  return null;
}

Future<UserCredential?> callAppleSignIn() async {
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  final rawNonce = generateNonce();
  final nonce = sha256ofString(rawNonce);
  try {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    if (appleCredential.identityToken != null) {
      Map<String, dynamic> userInfo =
          JwtDecoder.decode(appleCredential.identityToken!);
      print(userInfo);
    }
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    print(appleCredential.givenName ?? "");
    print(appleCredential.familyName ?? "");
    if (appleCredential.givenName != null &&
        appleCredential.familyName != null) {
      await userCredential.user?.updateDisplayName(
          "${appleCredential.givenName} ${appleCredential.familyName}");
    }

    return userCredential;
  } catch (e) {
    print("Error in callAppleSignIn => $e");
  }
  return null;
}

Future<UserCredential?> callTwitterSignIn() async {
  try {
    TwitterLogin login = TwitterLogin(
        apiKey: "HaPI0dQRItR56omPwCGmNBoVi",
        apiSecretKey: "Y3oaX4cUFdMldsr3ZefKxOjC8WVoqVhHFUloOTTZ4y1p5mCf3P",
        redirectURI: "https://casa-rancha.firebaseapp.com/__/auth/handler");
    AuthResult authResult = await login.loginV2();
    if (authResult.authToken != null && authResult.authTokenSecret != null) {
      AuthCredential credential = TwitterAuthProvider.credential(
          accessToken: authResult.authToken!,
          secret: authResult.authTokenSecret!);
      return FirebaseAuth.instance.signInWithCredential(credential);
    }
  } catch (e) {
    print("Error in callTwitterSignIn => $e");
  }
  return null;
}
