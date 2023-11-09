import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/common_button.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_Appbar.dart';
import 'package:casarancha/widgets/text_editing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({Key? key}) : super(key: key);

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  int optionLength = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppbar(
        title: 'Create Poll',
        elevation: 0.2,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          TextEditingWidget(
            color: color887.withOpacity(0.1),
            isBorderEnable: true,
            hint: 'Enter Question',
          ),
          heightBox(12.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: optionLength,
            separatorBuilder: (context, index) => heightBox(12.h),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    child: TextEditingWidget(
                      color: color887.withOpacity(0.1),
                      isBorderEnable: true,
                      hint: 'Option ${index + 1}',
                    ),
                  ),
                  widthBox(12.w),
                  GestureDetector(
                    onTap: () {
                      if (optionLength > 2) {
                        if (mounted) {
                          setState(() {
                            optionLength--;
                          });
                        }
                      } else {
                        // GlobalSnackBar(messag)
                      }
                    },
                    child: const Icon(
                      Icons.cancel,
                      color: colorPrimaryA05,
                    ),
                  )
                ],
              );
            },
          ),
          heightBox(12.h),
          CommonButton(
            text: 'Add more options',
            height: 50.h,
            backgroundColor: colorF03.withOpacity(0.6),
            textColor: color221,
            fontSize: 12.sp,
            isShadowEnable: false,
            onTap: () {
              if (mounted) {
                setState(() {
                  optionLength++;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
