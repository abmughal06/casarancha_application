import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';

import '../../utils/app_utils.dart';
import '../../utils/custom_date_picker.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_editing_widget.dart';
import 'ProfileScreen/provider/edit_profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late EditProfileProvider edit;

  // @override
  // void dispose() {
  //   edit.clearAll();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    edit = Provider.of<EditProfileProvider>(context);
    // final currentUser = context.watch<UserModel?>();
    return Scaffold(
      appBar: primaryAppbar(
        title: 'Setup Profile',
        showBackButton: true,
        elevation: 0,
      ),
      body: Consumer<UserModel?>(builder: (context, user, b) {
        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        edit.firstNameController =
            TextEditingController(text: user.name.split(" ").first);
        edit.lastNameController =
            TextEditingController(text: user.name.split(" ").last);
        edit.bioController = TextEditingController(text: user.bio);
        edit.userNameController = TextEditingController(text: user.username);
        edit.selectedDob = user.dob;
        edit.getDateTime = DateTime.parse(edit.selectedDob!);
        edit.bioTxtCount = user.bio.length.toString();
        edit.profileImage = user.imageStr;
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  GestureDetector(
                    onTap: () => edit.getFromGallery(),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 127.h,
                        width: 127.w,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.passthrough,
                          children: [
                            edit.imageFilePicked != null
                                ? Container(
                                    height: 150,
                                    width: 150,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: FileImage(
                                                edit.imageFilePicked!))),
                                  )
                                : edit.profileImage != null
                                    ? imgProVerified(
                                        imgRadius: 80,
                                        profileImg: edit.profileImage,
                                        idIsVerified: false)
                                    : CircleAvatar(
                                        radius: 20,
                                        backgroundImage:
                                            Image.asset(imgProfile).image,
                                      ),
                            Positioned(
                              bottom: 5.h,
                              left: 100.w,
                              child: SvgPicture.asset(
                                icProfileAdd,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  heightBox(20.w),
                  TextEditingWidget(
                    controller: edit.firstNameController,
                    hintColor: color080,
                    isShadowEnable: false,
                    hint: strFirstName,
                    color: colorFF4,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  heightBox(10.w),
                  TextEditingWidget(
                    controller: edit.lastNameController,
                    hintColor: color080,
                    isShadowEnable: false,
                    hint: strLastName,
                    color: colorFF4,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  heightBox(10.w),
                  TextEditingWidget(
                    controller: edit.userNameController,
                    hintColor: color080,
                    isShadowEnable: false,
                    hint: strUserName,
                    maxLength: 10,
                    color: colorFF4,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  heightBox(10.w),
                  TextEditingWidget(
                    controller: edit.bioController,
                    hintColor: color080,
                    maxLines: 5,
                    isShadowEnable: false,
                    hint: strBio,
                    maxLength: 300,
                    color: colorFF4,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  heightBox(10.w),
                  CustomDatePicker(
                    getDateTime: edit.getDateTime,
                    showSelected: edit.showSelectedDates,
                    userDateTime: user.dob,
                    dateChangedCallback: (DateTime value) {
                      // _getDateTime = value;
                      edit.selectedDob =
                          "${value.year}-${AppUtils.instance.convertSingleToTwoDigit(value.month.toString())}-${AppUtils.instance.convertSingleToTwoDigit(value.day.toString())}";
                      edit.getDateTime = DateTime.parse(edit.selectedDob!);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: CommonButton(
                height: 56.h,
                text: 'Continue',
                showLoading: edit.isLoading,
                onTap: () => edit.updateData(currentUser: user),
                width: double.infinity,
              ),
            ),
            heightBox(10.w)
          ],
        );
      }),
    );
  }
}
