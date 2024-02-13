import 'dart:io';

import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/widgets/common_button.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/text_editing_widget.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../resources/image_resources.dart';
import '../../../utils/snackbar.dart';
import '../../../widgets/primary_appbar.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({
    super.key,
    this.isEducation = false,
    this.isUsername = false,
    this.isOrganization = false,
    this.isGroup = false,
    this.isForum = false,
    this.isWork = false,
  });

  final bool isEducation;
  final bool isUsername;
  final bool isOrganization;
  final bool isGroup;
  final bool isForum;
  final bool isWork;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  String get title {
    if (widget.isEducation) {
      return appText(context).strEducation;
    } else if (widget.isUsername) {
      return appText(context).strUserName;
    } else if (widget.isForum) {
      return appText(context).strForum;
    } else if (widget.isGroup) {
      return appText(context).strSrcGroup;
    } else if (widget.isOrganization) {
      return appText(context).strOrganization;
    } else {
      return appText(context).strWork;
    }
  }

  String get discription {
    if (widget.isEducation) {
      return '';
    } else if (widget.isUsername) {
      return appText(context).strUsernameStatus;
    } else if (widget.isForum) {
      return appText(context).strForumStatus;
    } else if (widget.isGroup) {
      return appText(context).strGroupStatus;
    } else if (widget.isOrganization) {
      return appText(context).strOrganizationStatus;
    } else {
      return appText(context).strWorkStatus;
    }
  }

  String get textFieldHint {
    if (widget.isEducation) {
      return appText(context).strSchoolName;
    } else if (widget.isUsername) {
      return appText(context).strUserName;
    } else if (widget.isForum) {
      return appText(context).strForumName;
    } else if (widget.isGroup) {
      return appText(context).strGroupName;
    } else if (widget.isOrganization) {
      return appText(context).strOrganizationName;
    } else {
      return appText(context).strWorkPlaceName;
    }
  }

  String get idName {
    if (widget.isEducation) {
      return appText(context).strSchoolID;
    } else if (widget.isUsername) {
      return appText(context).strID;
    } else if (widget.isForum) {
      return appText(context).strID;
    } else if (widget.isGroup) {
      return appText(context).strID;
    } else if (widget.isOrganization) {
      return appText(context).strID;
    } else {
      return appText(context).strWorkID;
    }
  }

  File? idFile;
  File? otherDocFile;
  final controller = TextEditingController();

  void pickIDPhoto(context) async {
    try {
      final pickedPhoto =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedPhoto != null) {
        CroppedFile? croppedImage = await ImageCropper().cropImage(
            sourcePath: pickedPhoto.path,
            aspectRatio: const CropAspectRatio(ratioX: 3.375, ratioY: 2.125));
        var image = File(croppedImage!.path);
        idFile = image;
        setState(() {});
      }
    } catch (e) {
      GlobalSnackBar.show(message: appText(context).gsbOperationCancelled);
    }
  }

  void pickDocPhoto(context) async {
    try {
      final pickedPhoto =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedPhoto != null) {
        CroppedFile? croppedImage = await ImageCropper().cropImage(
            sourcePath: pickedPhoto.path,
            aspectRatio: const CropAspectRatio(ratioX: 3.375, ratioY: 2.125));
        var image = File(croppedImage!.path);
        otherDocFile = image;
        setState(() {});
      }
    } catch (e) {
      GlobalSnackBar.show(message: appText(context).gsbOperationCancelled);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(title: '$title Verification', elevation: 0.2),
      body: ListView(
        padding: EdgeInsets.all(20.h),
        children: [
          TextWidget(
            text: discription,
            color: color55F,
          ),
          heightBox(12.h),
          TextEditingWidget(
            controller: controller,
            hint: textFieldHint,
            color: color887.withOpacity(0.1),
            isBorderEnable: true,
          ),
          heightBox(12.h),
          GestureDetector(
            onTap: () => pickIDPhoto(context),
            child: idFile == null
                ? DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      child: SizedBox(
                        height: 160.h,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file_sharp, size: 50.h),
                            heightBox(10.h),
                            TextWidget(text: "Upload $idName"),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 190.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: FileImage(idFile!),
                          fit: BoxFit.cover,
                        )),
                  ),
          ),
          heightBox(12.h),
          GestureDetector(
            onTap: () => pickDocPhoto(context),
            child: otherDocFile == null
                ? DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: SizedBox(
                        height: 160.h,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file_sharp, size: 50.h),
                            heightBox(10.h),
                            TextWidget(
                              text: appText(context).strUploadDocuments,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 190.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: FileImage(otherDocFile!),
                          fit: BoxFit.cover,
                        )),
                  ),
          ),
          heightBox(12.h),
          CommonButton(
            text: appText(context).strSendVerify,
            fontSize: 13.sp,
            height: 52.h,
            onTap: () {
              if (controller.text.isNotEmpty && idFile != null) {
                Get.bottomSheet(
                  Container(
                    // height: 350.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(icBottomSheetScroller),
                        heightBox(15.h),
                        SvgPicture.asset(icReportPostDone),
                        heightBox(15.h),
                        TextWidget(
                          text: appText(context).strApplicationSubmitted(title),
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          fontSize: 18.sp,
                          color: const Color(0xff212121),
                        ),
                        heightBox(12.h),
                        TextWidget(
                          text: appText(context).strContact,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: const Color(0xff5f5f5f),
                        ),
                        heightBox(40.h)
                      ],
                    ),
                  ),
                );
              } else {
                GlobalSnackBar.show(message: appText(context).strFillInfo);
              }
            },
          )
        ],
      ),
    );
  }
}
