// import 'package:casarancha/resources/localization_text_strings.dart';
// import 'package:casarancha/screens/profile/settings_screen.dart';

// import 'package:casarancha/widgets/common_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../base/base_stateful_widget.dart';
// import '../../resources/color_resources.dart';
// import '../../resources/image_resources.dart';
// import '../../utils/app_constants.dart';
// import '../../utils/snackbar.dart';
// import '../../view_models/profile_vm/change_password_view_model.dart';
// import '../../widgets/common_appbar.dart';
// import '../../widgets/text_editing_widget.dart';

// class ChangePasswordScreen extends StatefulWidget {
//   const ChangePasswordScreen({Key? key}) : super(key: key);

//   @override
//   State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState
//     extends BaseStatefulWidgetState<ChangePasswordScreen> {
//   @override
//   PreferredSizeWidget? buildAppBar(BuildContext context) {
//     return iosBackIcAppBar(
//       title: strChangePassword,
//       onTapLead: () => goBack(),
//     );
//   }

//   TextEditingController currentPwdController = TextEditingController();
//   TextEditingController newPasswordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();

//   bool _checkValidData() {
//     if (currentPwdController.text.isEmpty) {
//       GlobalSnackBar.show(
//           context: context, message: 'Please enter $strCurrentPassword');
//       return false;
//     } else if (newPasswordController.text.isEmpty) {
//       GlobalSnackBar.show(
//           context: context, message: 'Please enter $strNewPassword');
//       return false;
//     } else if (newPasswordController.text.length <
//         AppConstant.passwordMinText) {
//       GlobalSnackBar.show(
//           context: context,
//           message:
//               '$strNewPassword should be minimum ${AppConstant.passwordMinText} characters');
//       return false;
//     } else if (confirmPasswordController.text.isEmpty) {
//       GlobalSnackBar.show(
//           context: context, message: 'Please enter $strConfirmPassword');
//       return false;
//     } else if (newPasswordController.text != confirmPasswordController.text) {
//       GlobalSnackBar.show(
//           context: context,
//           message: '$strPassword & $strConfirmPassword must be same');
//       return false;
//     }
//     return true;
//   }

//   @override
//   Widget buildBody(BuildContext context) {
//     ChangePasswordViewModel changePasswordViewModel =
//         Provider.of<ChangePasswordViewModel>(context);
//     return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//       return ConstrainedBox(
//           constraints: BoxConstraints(minHeight: constraints.minHeight),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 Focus(
//                   focusNode: changePasswordViewModel.currentPasswordFocus,
//                   onFocusChange: (hasFocus) {
//                     Provider.of<ChangePasswordViewModel>(context, listen: false)
//                         .setCurrentPwdFocusChange();
//                   },
//                   child: TextEditingWidget(
//                     controller: currentPwdController,
//                     hint: strCurrentPassword,
//                     fieldBorderClr: changePasswordViewModel.currentPwdBorderClr,
//                     textInputType: TextInputType.visiblePassword,
//                     textInputAction: TextInputAction.next,
//                     onFieldSubmitted: (str) =>
//                         FocusScope.of(context).nextFocus(),
//                     passwordVisible:
//                         changePasswordViewModel.currentPasswordVisible,
//                     color:
//                         changePasswordViewModel.currentPwdFillClr ?? colorFF3,
//                     suffixIconWidget: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10.w),
//                       child: GestureDetector(
//                         onTap: () {
//                           FocusScope.of(context).requestFocus(
//                               changePasswordViewModel.currentPasswordFocus);
//                           changePasswordViewModel.setCurrentPwdVisibility();
//                         },
//                         child: SvgPicture.asset(
//                             changePasswordViewModel.icCurrentPwdSvg ??
//                                 icHidePassword),
//                       ),
//                     ),
//                   ),
//                 ),
//                 heightBox(18.h),
//                 Focus(
//                   focusNode: changePasswordViewModel.newPasswordFocus,
//                   onFocusChange: (hasFocus) {
//                     Provider.of<ChangePasswordViewModel>(context, listen: false)
//                         .setNewPwdFocusChange();
//                   },
//                   child: TextEditingWidget(
//                     controller: newPasswordController,
//                     hint: strNewPassword,
//                     fieldBorderClr:
//                         changePasswordViewModel.newPasswordBorderClr,
//                     textInputType: TextInputType.visiblePassword,
//                     textInputAction: TextInputAction.next,
//                     onFieldSubmitted: (str) =>
//                         FocusScope.of(context).nextFocus(),
//                     passwordVisible: changePasswordViewModel.newPasswordVisible,
//                     color:
//                         changePasswordViewModel.newPasswordFillClr ?? colorFF3,
//                     suffixIconWidget: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10.w),
//                       child: GestureDetector(
//                         onTap: () {
//                           FocusScope.of(context).requestFocus(
//                               changePasswordViewModel.newPasswordFocus);
//                           changePasswordViewModel.setNewPwdVisibility();
//                         },
//                         child: SvgPicture.asset(
//                             changePasswordViewModel.icNewPasswordSvg ??
//                                 icHidePassword),
//                       ),
//                     ),
//                   ),
//                 ),
//                 heightBox(18.h),
//                 Focus(
//                   focusNode: changePasswordViewModel.confirmPasswordFocus,
//                   onFocusChange: (hasFocus) {
//                     Provider.of<ChangePasswordViewModel>(context, listen: false)
//                         .setConfirmPwdFocusChange();
//                   },
//                   child: TextEditingWidget(
//                     controller: confirmPasswordController,
//                     hint: strConfirmPassword,
//                     fieldBorderClr: changePasswordViewModel.confirmPwdBorderClr,
//                     textInputType: TextInputType.visiblePassword,
//                     textInputAction: TextInputAction.done,
//                     onFieldSubmitted: (str) => FocusScope.of(context).unfocus(),
//                     passwordVisible:
//                         changePasswordViewModel.confirmPasswordVisible,
//                     color:
//                         changePasswordViewModel.confirmPwdFillClr ?? colorFF3,
//                     suffixIconWidget: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10.w),
//                       child: GestureDetector(
//                         onTap: () {
//                           FocusScope.of(context).requestFocus(
//                               changePasswordViewModel.confirmPasswordFocus);
//                           changePasswordViewModel.setConfirmPwdVisibility();
//                         },
//                         child: SvgPicture.asset(
//                             changePasswordViewModel.icConfirmPwdSvg ??
//                                 icHidePassword),
//                       ),
//                     ),
//                   ),
//                 ),
//                 heightBox(42.h),
//                 CommonButton(
//                   text: strChangeNow,
//                   showLoading: changePasswordViewModel.isLoading,
//                   onTap: () async {
//                     if (await AppConstant.checkNetwork()) {
//                       if (_checkValidData()) {
//                         changePasswordViewModel.onStartLoader();
//                         Map<String, dynamic> mapUpdatePwd = {
//                           "old_password": currentPwdController.text,
//                           "new_password": newPasswordController.text,
//                           "confirm_password": confirmPasswordController.text
//                         };
//                         if (await SettingServices()
//                             .updatePassword(mapUpdatePwd)) {
//                           push(context, enterPage: const SettingsScreen());
//                         }
//                         changePasswordViewModel.onStopLoader();
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
