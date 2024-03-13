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
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AccountRecovery extends StatelessWidget {
  const AccountRecovery({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserModel?>();
    final prov = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      appBar: primaryAppbar(title: appText(context).accountRecovery),
      body: Stack(
        children: [
          currentUser == null
              ? centerLoader()
              : currentUser.email.isEmpty
                  ? const RegisterAndLinkEmail()
                  : ShowRegisteredEmail(email: currentUser.email),
          Align(
            alignment: Alignment.center,
            child: prov.isSigningIn
                ? const CircularProgressIndicator.adaptive()
                : widthBox(0),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          (FirebaseAuth.instance.currentUser!.providerData[0].providerId ==
                          GoogleAuthProvider.PROVIDER_ID ||
                      FirebaseAuth.instance.currentUser!.providerData[0]
                              .providerId ==
                          GoogleAuthProvider.PROVIDER_ID) ||
                  currentUser!.email.isEmpty
              ? widthBox(0)
              : CommonButton(
                  height: 52.h,
                  text: appText(context).updateEmail,
                  verticalOutMargin: 10.h,
                  horizontalOutMargin: 20.w,
                  onTap: () {
                    showDialog(
                        context: context, builder: (_) => const UpdateEmail());
                  },
                ),
    );
  }
}

class RegisterAndLinkEmail extends StatefulWidget {
  const RegisterAndLinkEmail({super.key});

  @override
  State<RegisterAndLinkEmail> createState() => _RegisterAndLinkEmailState();
}

class _RegisterAndLinkEmailState extends State<RegisterAndLinkEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isUpdatemail = false;

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
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        TextWidget(
          text: appText(context).alertAccRecovery,
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
            fieldBorderClr: _emailFocus.hasFocus ? colorF73 : color080,
            isBorderEnable: true,
            textInputType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (val) => FocusScope.of(context).nextFocus(),
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            suffixIconWidget: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: SvgPicture.asset(
                  _emailFocus.hasFocus ? icSelectEmail : icDeselectEmail),
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
            hint: "Confirm ${appText(context).strPassword}",
            fieldBorderClr: _confirmPasswordFocus.hasFocus ? colorF73 : null,
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
                  isConfirmPasswordVisible ? icShowPassword : icHidePassword,
                ),
              ),
            ),
          ),
        ),
        heightBox(20),
        CommonButton(
          text: appText(context).strSave,
          showLoading: context.watch<AuthenticationProvider>().isSigningIn,
          horizontalOutMargin: 0,
          onTap: () {
            context.read<AuthenticationProvider>().linkPhoneWithEmailAccount(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
          },
        )
      ],
    );
  }
}

class UpdateEmail extends StatefulWidget {
  const UpdateEmail({super.key});

  @override
  State<UpdateEmail> createState() => _UpdateEmailState();
}

class _UpdateEmailState extends State<UpdateEmail> {
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _oldEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isPasswordVisible = false;

  final FocusNode _oldEmailFocus = FocusNode();
  final FocusNode _newEmailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _newEmailController.dispose();
    _oldEmailController.dispose();
    _passwordController.dispose();
    _oldEmailFocus.dispose();
    _newEmailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .9,
          decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget(
                text: appText(context).alertAccRecoveryEnterEmail,
                textAlign: TextAlign.center,
                color: color887,
                fontSize: 14,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Focus(
                  focusNode: _oldEmailFocus,
                  onFocusChange: (hasFocus) {
                    setState(() {});
                  },
                  child: TextEditingWidget(
                    controller: _oldEmailController,
                    hint: "Old ${appText(context).strEmailAddress}",
                    color: _oldEmailFocus.hasFocus ? colorFDF : colorFF3,
                    fieldBorderClr:
                        _oldEmailFocus.hasFocus ? colorF73 : color080,
                    isBorderEnable: true,
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (val) =>
                        FocusScope.of(context).nextFocus(),
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    suffixIconWidget: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SvgPicture.asset(_oldEmailFocus.hasFocus
                          ? icSelectEmail
                          : icDeselectEmail),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Focus(
                  focusNode: _newEmailFocus,
                  onFocusChange: (hasFocus) {
                    setState(() {});
                  },
                  child: TextEditingWidget(
                    controller: _newEmailController,
                    hint: "New ${appText(context).strEmailAddress}",
                    color: _newEmailFocus.hasFocus ? colorFDF : colorFF3,
                    fieldBorderClr:
                        _newEmailFocus.hasFocus ? colorF73 : color080,
                    isBorderEnable: true,
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (val) =>
                        FocusScope.of(context).nextFocus(),
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    suffixIconWidget: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SvgPicture.asset(_newEmailFocus.hasFocus
                          ? icSelectEmail
                          : icDeselectEmail),
                    ),
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
              heightBox(12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: color887,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextWidget(
                      text: appText(context).strCancel,
                      color: colorWhite,
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ),
                  widthBox(10.w),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: colorF03,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextWidget(
                      text: appText(context).strUpdate,
                      color: colorBlack,
                      onTap: () {
                        context.read<AuthenticationProvider>().updateEmail(
                              oldEmail: _oldEmailController.text,
                              newEmail: _newEmailController.text,
                              password: _passwordController.text,
                            );
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowRegisteredEmail extends StatelessWidget {
  const ShowRegisteredEmail({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextWidget(
              text: appText(context).alertAccRecoveryEmailLinked,
              textAlign: TextAlign.center,
              color: color887,
              fontSize: 12,
            ),
            SelectableTextWidget(
              text: email,
              color: Colors.blueAccent,
            ),
            heightBox(12.h),
          ],
        ),
      ),
    );
  }
}
