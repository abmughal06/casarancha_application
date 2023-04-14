// import 'package:casarancha/resources/localization_text_strings.dart';

// import 'package:casarancha/widgets/common_button.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../base/base_stateful_widget.dart';
// import '../../models/auth/signup_model.dart';
// import '../../models/common/success_with_msg_model.dart';
// import '../../resources/color_resources.dart';
// import '../../resources/image_resources.dart';


// import '../../utils/app_constants.dart';
// import '../../utils/snackbar.dart';
// import '../../view_models/profile_vm/change_email_view_model.dart';
// import '../../widgets/common_appbar.dart';
// import '../../widgets/text_editing_widget.dart';
// import '../../widgets/text_widget.dart';

// class ChangeEmailScreen extends StatefulWidget {
//   const ChangeEmailScreen({Key? key}) : super(key: key);

//   @override
//   State<ChangeEmailScreen> createState() => _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState
//     extends BaseStatefulWidgetState<ChangeEmailScreen> {
//   @override
//   PreferredSizeWidget? buildAppBar(BuildContext context) {
//     return iosBackIcAppBar(
//       title: strChangeYourEmail,
//       onTapLead: () => goBack(),
//     );
//   }

//   TextEditingController emailController = TextEditingController();
//   SuccessWithMsg isValidEmail = SuccessWithMsg(isSuccess: false);

//   bool _checkValidData() {
//     if (emailController.text.isEmpty) {
//       GlobalSnackBar.show(
//           context: context, message: 'Please enter $strNewEmailAddress');
//       return false;
//     } else if (!isValidEmail.isSuccess) {
//       GlobalSnackBar.show(
//           context: context,
//           message: isValidEmail.msgText ?? "Invalid $strNewEmailAddress");
//       return false;
//     } else if (!EmailValidator.validate(emailController.text.trim())) {
//       GlobalSnackBar.show(
//           context: context, message: 'Please enter valid $strNewEmailAddress');
//       return false;
//     }
//     return true;
//   }

//   @override
//   Widget buildBody(BuildContext context) {
//     ChangeEmailViewModel changeEmailViewModel =
//         Provider.of<ChangeEmailViewModel>(context);
//     return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//       return ConstrainedBox(
//           constraints: BoxConstraints(minHeight: constraints.minHeight),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 heightBox(10.h),
//                 Focus(
//                   focusNode: changeEmailViewModel.newEmailFocus,
//                   onFocusChange: (hasFocus) {
//                     changeEmailViewModel.setEmailFocusChange();
//                   },
//                   child: TextEditingWidget(
//                     controller: emailController,
//                     hint: strNewEmailAddress,
//                     color: changeEmailViewModel.newEmailFillClr ?? colorFF3,
//                     onChanged: (val) async {
//                       Future.delayed(const Duration(milliseconds: 300),
//                           () async {
//                         if (await AppConstant.checkNetwork()) {
//                           isValidEmail = await CommonServices().checkAbility(
//                               userId: SharedPreferenceUtil.getInt(
//                                   AppConstant.profileIdPre),
//                               strValue: val,
//                               abilityType: CheckAbilityTypeEnum.email);
//                           changeEmailViewModel.onNotifyListeners();
//                         }
//                       });
//                     },
//                     fieldBorderClr: changeEmailViewModel.newEmailBorderClr,
//                     textInputType: TextInputType.emailAddress,
//                     textInputAction: TextInputAction.done,
//                     onFieldSubmitted: (val) => FocusScope.of(context).unfocus(),
//                     onEditingComplete: () => FocusScope.of(context).unfocus(),
//                     suffixIconWidget: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10.w),
//                       child: SvgPicture.asset(
//                           changeEmailViewModel.icNewEmailSvg ??
//                               icDeselectEmail),
//                     ),
//                   ),
//                 ),
//                 isValidEmail.msgText != null ? heightBox(8.h) : Container(),
//                 isValidEmail.msgText != null
//                     ? Align(
//                         alignment: Alignment.centerLeft,
//                         child: TextWidget(
//                           text: " *${isValidEmail.msgText}",
//                         ))
//                     : Container(),
//                 heightBox(32.h),
//                 CommonButton(
//                   text: strChangeNow,
//                   showLoading: changeEmailViewModel.isLoading,
//                   onTap: () async {
//                     if (await AppConstant.checkNetwork()) {
//                       if (_checkValidData()) {
//                         changeEmailViewModel.onStartLoader();
//                         if (await SignupService().sendOtpApiReq(
//                             signUpRequestModel: SignUpRequestModel(
//                                 email: emailController.text.toString()))) {
//                           // push(context, enterPage:
//                           // OtpVerifyScreen(
//                           //   emailForVerify: emailController.text
//                           //       .toString(),isFromSetting: true,));
//                         }
//                         changeEmailViewModel.onStopLoader();
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
