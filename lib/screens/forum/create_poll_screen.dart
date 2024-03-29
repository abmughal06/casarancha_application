import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/screens/home/CreatePost/create_post_controller.dart';
import 'package:casarancha/screens/home/CreatePost/new_post_share.dart';
import 'package:casarancha/utils/snackbar.dart';
import 'package:casarancha/widgets/common_button.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:casarancha/widgets/primary_appbar.dart';
import 'package:casarancha/widgets/text_editing_widget.dart';
import 'package:casarancha/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key});

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  // int optionLength = 2;
  final questionController = TextEditingController();
  TextEditingController optionController = TextEditingController();

  List<PollOptions> options = [];

  late CreatePostMethods prov;

  @override
  void dispose() {
    prov.question = '';
    prov.options = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    prov = Provider.of<CreatePostMethods>(context, listen: false);
    return Scaffold(
      appBar: primaryAppbar(
        title: appText(context).createPoll,
        elevation: 0.2,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          TextEditingWidget(
            controller: questionController,
            color: color887.withOpacity(0.1),
            isBorderEnable: true,
            hint: appText(context).strPollQuestion,
          ),
          heightBox(12.h),
          Row(
            children: [
              Expanded(
                child: TextEditingWidget(
                  controller: optionController,
                  color: color887.withOpacity(0.1),
                  isBorderEnable: true,
                  hint: appText(context).strPollOption,
                ),
              ),
              widthBox(12.h),
              CommonButton(
                text: appText(context).strAdd,
                height: 45.h,
                width: 70.w,
                backgroundColor: colorF03.withOpacity(0.6),
                textColor: color221,
                fontSize: 13.sp,
                isShadowEnable: false,
                onTap: () {
                  if (optionController.text.trim().isNotEmpty) {
                    if (mounted) {
                      setState(() {
                        options.add(PollOptions(
                            option: optionController.text.trim(), votes: 0));
                        optionController.clear();
                      });
                    }
                  } else {
                    GlobalSnackBar.show(
                        message: appText(context).strEnterSomething);
                  }
                },
              ),
            ],
          ),
          heightBox(12.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: options.length,
            separatorBuilder: (context, index) => heightBox(12.h),
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: TextWidget(
                        text: '${index + 1}. ${options[index].option}'),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              optionController.text = options[index].option;
                              options.removeAt(index);
                            });
                          }
                        },
                        child: const Icon(
                          Icons.edit,
                          color: color221,
                        ),
                      ),
                      widthBox(12.w),
                      GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              options.removeAt(index);
                            });
                          }
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: colorPrimaryA05,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButton: CommonButton(
        text: appText(context).createPoll,
        height: 52.h,
        horizontalOutMargin: 20.w,
        onTap: () {
          if (options.length >= 2) {
            prov.question = questionController.text.trim();
            prov.options = options;
            Get.to(() => const NewPostShareScreen(
                  isPoll: true,
                  isForum: true,
                ));
          } else {
            GlobalSnackBar.show(message: appText(context).gsbMoreText);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
