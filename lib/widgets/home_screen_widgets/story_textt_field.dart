import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';
import '../../widgets/common_widgets.dart';

class StoryTextField extends StatelessWidget {
  const StoryTextField(
      {super.key,
      required this.commentFocus,
      required this.onfocusChange,
      required this.textEditingController,
      required this.onchange,
      required this.onFieldSubmitted,
      required this.onEditCompleted,
      required this.ontapSend});
  final FocusNode commentFocus;
  final Function(bool) onfocusChange;
  final TextEditingController textEditingController;
  final Function(String) onchange;
  final Function(String) onFieldSubmitted;
  final VoidCallback onEditCompleted;
  final VoidCallback ontapSend;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Focus(
          focusNode: commentFocus,
          onFocusChange: onfocusChange,
          child: TextFormField(
            controller: textEditingController,
            onChanged: onchange,
            style: TextStyle(
              color: color887,
              fontSize: 16.sp,
              fontFamily: strFontName,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: strWriteCommentHere,
              hintStyle: TextStyle(
                color: color887,
                fontSize: 14.sp,
                fontFamily: strFontName,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: svgImgButton(
                  svgIcon: icStoryCmtSend,
                  onTap: ontapSend,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: const BorderSide(
                  color: color887,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: const BorderSide(
                  color: color887,
                  width: 1.0,
                ),
              ),
            ),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: onFieldSubmitted,
            onEditingComplete: onEditCompleted,
            // () {
            //   FocusScope.of(context).unfocus();
            //   commentController.text = "";
            //   controller!.play();
            // },
          ),
        ),
      ),
    );
  }
}
