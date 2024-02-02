import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/image_resources.dart';
import 'package:casarancha/screens/auth/providers/auth_provider.dart';
import 'package:casarancha/widgets/common_button.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_editing_widget.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AccountRecovery extends StatefulWidget {
  const AccountRecovery({super.key});

  @override
  State<AccountRecovery> createState() => _AccountRecoveryState();
}

class _AccountRecoveryState extends State<AccountRecovery> {
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
    final currentUser = context.watch<UserModel?>();
    return Scaffold(
      appBar: primaryAppbar(title: 'Account Recovery'),
      body: currentUser == null
          ? centerLoader()
          : currentUser.email.isEmpty
              ? ListView(
                  padding: const EdgeInsets.all(15),
                  children: [
                    TextWidget(
                      text:
                          'Register your email and password for your second login method. in case you lost your phone number',
                      color: color887,
                      fontSize: 12.sp,
                    ),
                    heightBox(15.h),
                    Focus(
                      focusNode: _emailFocus,
                      onFocusChange: (hasFocus) {
                        setState(() {});
                      },
                      child: TextEditingWidget(
                        controller: _emailController,
                        hint: appText(context).strEmailAddress,
                        color: _emailFocus.hasFocus ? colorFDF : colorFF3,
                        fieldBorderClr:
                            _emailFocus.hasFocus ? colorF73 : color080,
                        isBorderEnable: true,
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (val) =>
                            FocusScope.of(context).nextFocus(),
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
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
                        hint: appText(context).strPassword,
                        fieldBorderClr:
                            _passwordFocus.hasFocus ? colorF73 : null,
                        textInputType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        passwordVisible: !isPasswordVisible,
                        color: _passwordFocus.hasFocus ? colorFDF : colorFF3,
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        suffixIconWidget: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: GestureDetector(
                            onTap: () {
                              isPasswordVisible = !isPasswordVisible;
                              setState(() {});
                            },
                            child: SvgPicture.asset(
                              isPasswordVisible
                                  ? icShowPassword
                                  : icHidePassword,
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
                        hint: "Confirm ${appText(context).strPassword}",
                        fieldBorderClr:
                            _confirmPasswordFocus.hasFocus ? colorF73 : null,
                        textInputType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        passwordVisible: !isConfirmPasswordVisible,
                        color: _confirmPasswordFocus.hasFocus
                            ? colorFDF
                            : colorFF3,
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        suffixIconWidget: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: GestureDetector(
                            onTap: () {
                              isConfirmPasswordVisible =
                                  !isConfirmPasswordVisible;
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
                    heightBox(20),
                    CommonButton(
                      text: appText(context).strSave,
                      horizontalOutMargin: 0,
                      onTap: () {
                        context
                            .read<AuthenticationProvider>()
                            .linkPhoneWithEmailAccount(
                                email: _emailController.text,
                                password: _passwordController.text);
                      },
                    )
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const TextWidget(
                          text: 'you have linked your account with this email',
                          textAlign: TextAlign.center,
                          color: color887,
                          fontSize: 12,
                        ),
                        TextWidget(
                          text: FirebaseAuth.instance.currentUser!.email,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
