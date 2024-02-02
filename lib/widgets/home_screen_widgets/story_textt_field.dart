import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/strings.dart';
import '../../widgets/common_widgets.dart';

class StoryTextField extends StatelessWidget {
  const StoryTextField({
    super.key,
    required this.commentFocus,
    required this.onfocusChange,
    required this.textEditingController,
    required this.onchange,
    required this.onFieldSubmitted,
    required this.onEditCompleted,
    required this.ontapSend,
  });
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
            maxLength: 2000,
            maxLines: 3,
            minLines: 1,
            style: TextStyle(
              color: colorWhite,
              fontSize: 16.sp,
              fontFamily: strFontName,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: appText(context).strWriteCommentHere,
              hintStyle: TextStyle(
                color: colorWhite,
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
                borderSide: BorderSide(
                  color: colorWhite,
                  width: 1.h,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.r),
                borderSide: BorderSide(
                  color: colorWhite,
                  width: 1.h,
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
