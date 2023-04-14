// import 'package:casarancha/resources/color_resources.dart';
// import 'package:casarancha/resources/image_resources.dart';
// import 'package:casarancha/screens/profile/change_email_screen.dart';
// import 'package:casarancha/screens/profile/change_password_screen.dart';
// import 'package:casarancha/screens/profile/ProfileScreen/profile_screen.dart';

// import 'package:casarancha/widgets/common_widgets.dart';
// import 'package:casarancha/widgets/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../base/base_stateful_widget.dart';
// import '../../models/auth/signup_model.dart';
// import '../../resources/localization_text_strings.dart';

// import '../../utils/app_constants.dart';
// import '../../view_models/profile_vm/settings_screen_view_model.dart';
// import '../../widgets/common_appbar.dart';
// import 'block_account_screen.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({Key? key}) : super(key: key);

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends BaseStatefulWidgetState<SettingsScreen> {
//   @override
//   PreferredSizeWidget? buildAppBar(BuildContext context) {
//     return iosBackIcAppBar(
//       title: strSettings,
//       onTapLead: () => push(context, enterPage: ProfileScreen()),
//     );
//   }

//   Widget textItemSetting(
//       {required String assetName,
//       required String titleTxt,
//       required String subTxt,
//       GestureTapCallback? onTap}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 20.h),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SvgPicture.asset(assetName),
//             widthBox(17.w),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextWidget(
//                   text: titleTxt,
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w600,
//                   color: color221,
//                 ),
//                 TextWidget(
//                   text: subTxt,
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w400,
//                   color: colorAA3,
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     _getProfileData();
//     super.initState();
//   }

//   _getProfileData() async {
//     if (await AppConstant.checkNetwork()) {
//       Provider.of<SettingScreenViewModel>(context, listen: false)
//           .onStartLoader();
//       SignupResponseModel? _fullData =
//           await SetProfileService().getProfileData();
//       _fullData != null
//           ? Provider.of<SettingScreenViewModel>(context, listen: false)
//               .isSwitched = _fullData.notification == "0" ? false : true
//           : null;
//       Provider.of<SettingScreenViewModel>(context, listen: false)
//           .onStopLoader();
//     }
//   }

//   @override
//   Widget buildBody(BuildContext context) {
//     SettingScreenViewModel settingScreenViewModel =
//         Provider.of<SettingScreenViewModel>(context);
//     return WillPopScope(
//       onWillPop: () {
//         push(context, enterPage: ProfileScreen());
//         return Future.value(false);
//       },
//       child: LayoutBuilder(
//           builder: (BuildContext context, BoxConstraints constraints) {
//         return ConstrainedBox(
//             constraints: BoxConstraints(minHeight: constraints.minHeight),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       textItemSetting(
//                           assetName: icManageNotification,
//                           titleTxt: strNotification,
//                           subTxt: strManageNotifications),
//                       const Spacer(),
//                       settingScreenViewModel.isLoading
//                           ? centerLoader()
//                           : FlutterSwitch(
//                               value: settingScreenViewModel.isSwitched,
//                               activeColor: colorF03,
//                               height: 25.h,
//                               width: 46.w,
//                               toggleSize: 20.h,
//                               onToggle: (val) async {
//                                 if (await AppConstant.checkNetwork()) {
//                                   settingScreenViewModel.onStartLoader();
//                                   String? notificationData =
//                                       await SettingServices()
//                                           .updateNotificationStatus();
//                                   if (notificationData != null) {
//                                     settingScreenViewModel.onTapToggleSwitch(
//                                         isOn: notificationData == "0"
//                                             ? false
//                                             : true);
//                                   }
//                                   settingScreenViewModel.onStopLoader();
//                                 }
//                               },
//                             ),
//                     ],
//                   ),
//                   horizonLine(width: constraints.maxWidth, color: colorDD3),
//                   textItemSetting(
//                       assetName: icBlockAccount,
//                       titleTxt: strBlockAccounts,
//                       subTxt: strBlockUnblockUsers,
//                       onTap: () => push(context,
//                           enterPage: const BlockAccountsScreen())),
//                   horizonLine(width: constraints.maxWidth, color: colorDD3),
//                   textItemSetting(
//                       assetName: icChangePassword,
//                       titleTxt: strChangePassword,
//                       subTxt: strUseStrongPassword,
//                       onTap: () => push(context,
//                           enterPage: const ChangePasswordScreen())),
//                   horizonLine(width: constraints.maxWidth, color: colorDD3),
//                   textItemSetting(
//                       assetName: icChangeEmail,
//                       titleTxt: strChangeEmail,
//                       subTxt: strChangeYourPrimaryEmail,
//                       onTap: () =>
//                           push(context, enterPage: const ChangeEmailScreen())),
//                 ],
//               ),
//             ));
//       }),
//     );
//   }
// }
