// import 'package:casarancha/screens/home/HomeScreen/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../base/base_stateful_widget.dart';
// import '../../resources/color_resources.dart';
// import '../../resources/image_resources.dart';
// import '../../resources/localization_text_strings.dart';

// import '../../utils/app_constants.dart';
// import '../../utils/snackbar.dart';
// import '../../view_models/change_forgor_password_view_model.dart';
// import '../../widgets/common_appbar.dart';
// import '../../widgets/common_button.dart';
// import '../../widgets/text_editing_widget.dart';

// class ChangeForgotPasswordScreen extends StatefulWidget {
//   String? resetToken;

//   ChangeForgotPasswordScreen({Key? key, this.resetToken}) : super(key: key);

//   @override
//   State<ChangeForgotPasswordScreen> createState() =>
//       _ChangeForgotPasswordScreenState();
// }

// class _ChangeForgotPasswordScreenState
//     extends BaseStatefulWidgetState<ChangeForgotPasswordScreen> {
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPwdController = TextEditingController();

//   @override
//   PreferredSizeWidget? buildAppBar(BuildContext context) {
//     return iosBackIcAppBar(
//       title: strChangePassword,
//       onTapLead: () => goBack(),
//     );
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   bool _checkValidData() {
//     if (_newPasswordController.text.isEmpty) {
//       GlobalSnackBar.show(
//           context: context, message: 'Please enter $strNewPassword');
//       return false;
//     } else if (_newPasswordController.text.length <
//         AppConstant.passwordMinText) {
//       GlobalSnackBar.show(
//           context: context,
//           message:
//               '$strNewPassword should be minimum ${AppConstant.passwordMinText} characters');
//       return false;
//     } else if (_confirmPwdController.text.isEmpty) {
//       GlobalSnackBar.show(
//           context: context, message: 'Please enter $strConfirmPassword');
//       return false;
//     } else if (_newPasswordController.text != _confirmPwdController.text) {
//       GlobalSnackBar.show(
//           context: context,
//           message: '$strNewPassword & $strConfirmPassword must be same');
//       return false;
//     }
//     return true;
//   }

//   @override
//   Widget buildBody(BuildContext context) {
//     ChangeForgotPasswordViewModel changeForgotPasswordViewModel =
//         Provider.of<ChangeForgotPasswordViewModel>(context);
//     return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//       return ConstrainedBox(
//           constraints: BoxConstraints(minHeight: constraints.minHeight),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 Focus(
//                   focusNode: changeForgotPasswordViewModel.newPasswordFocus,
//                   onFocusChange: (hasFocus) {
//                     Provider.of<ChangeForgotPasswordViewModel>(context,
//                             listen: false)
//                         .setNewPwdFocusChange();
//                   },
//                   child: TextEditingWidget(
//                     controller: _newPasswordController,
//                     hint: strNewPassword,
//                     fieldBorderClr:
//                         changeForgotPasswordViewModel.newPasswordBorderClr,
//                     textInputType: TextInputType.visiblePassword,
//                     textInputAction: TextInputAction.next,
//                     onFieldSubmitted: (str) =>
//                         FocusScope.of(context).nextFocus(),
//                     passwordVisible:
//                         changeForgotPasswordViewModel.newPasswordVisible,
//                     color: changeForgotPasswordViewModel.newPasswordFillClr ??
//                         colorFF3,
//                     onEditingComplete: () => FocusScope.of(context).nextFocus(),
//                     suffixIconWidget: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10.w),
//                       child: GestureDetector(
//                         onTap: () {
//                           FocusScope.of(context).requestFocus(
//                               changeForgotPasswordViewModel.newPasswordFocus);
//                           changeForgotPasswordViewModel.setNewPwdVisibility();
//                         },
//                         child: SvgPicture.asset(
//                             changeForgotPasswordViewModel.icNewPasswordSvg ??
//                                 icHidePassword),
//                       ),
//                     ),
//                   ),
//                 ),
//                 heightBox(18.h),
//                 Focus(
//                   focusNode: changeForgotPasswordViewModel.confirmPasswordFocus,
//                   onFocusChange: (hasFocus) {
//                     Provider.of<ChangeForgotPasswordViewModel>(context,
//                             listen: false)
//                         .setConfirmPwdFocusChange();
//                   },
//                   child: TextEditingWidget(
//                     controller: _confirmPwdController,
//                     hint: strConfirmPassword,
//                     fieldBorderClr:
//                         changeForgotPasswordViewModel.confirmPwdBorderClr,
//                     textInputType: TextInputType.visiblePassword,
//                     textInputAction: TextInputAction.done,
//                     onFieldSubmitted: (str) => FocusScope.of(context).unfocus(),
//                     passwordVisible:
//                         changeForgotPasswordViewModel.confirmPasswordVisible,
//                     color: changeForgotPasswordViewModel.confirmPwdFillClr ??
//                         colorFF3,
//                     onEditingComplete: () => FocusScope.of(context).unfocus(),
//                     suffixIconWidget: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10.w),
//                       child: GestureDetector(
//                         onTap: () {
//                           FocusScope.of(context).requestFocus(
//                               changeForgotPasswordViewModel
//                                   .confirmPasswordFocus);
//                           changeForgotPasswordViewModel
//                               .setConfirmPwdVisibility();
//                         },
//                         child: SvgPicture.asset(
//                             changeForgotPasswordViewModel.icConfirmPwdSvg ??
//                                 icHidePassword),
//                       ),
//                     ),
//                   ),
//                 ),
//                 heightBox(42.h),
//                 CommonButton(
//                   showLoading: changeForgotPasswordViewModel.isLoading,
//                   text: strChangeNow,
//                   onTap: () async {
//                     if (await AppConstant.checkNetwork()) {
//                       if (_checkValidData()) {
//                         changeForgotPasswordViewModel.onStartLoader();
//                         Map<String, dynamic> map = {
//                           "reset_token": widget.resetToken,
//                           "new_password": _newPasswordController.text
//                         };
//                         if (await LoginService().changePassword(map)) {
//                           push(context, enterPage: HomeScreen());
//                         }
//                         changeForgotPasswordViewModel.onStopLoader();
//                       }
//                     }
//                   },
//                 )
//               ],
//             ),
//           ));
//     });
//   }
// }
