import 'package:casarancha/screens/auth/providers/auth_provider.dart';
import 'package:casarancha/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/strings.dart';
import '../../utils/country_list.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_editing_widget.dart';
import '../../widgets/text_widget.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final maskFormatter = MaskTextInputFormatter(
      mask: '### ### ####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;
  String phoneDialCode = '+1';
  FocusNode phoneFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                imgOtpBackground,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWidget(
                          text: appText(context).strPhoneLogin,
                          fontSize: 26.sp,
                          color: color13F,
                          fontWeight: FontWeight.w800,
                        ),
                        heightBox(4.h),
                        TextWidget(
                          textAlign: TextAlign.center,
                          text: appText(context).strPhoneSlogan,
                          fontSize: 16.sp,
                          color: color080,
                          fontWeight: FontWeight.w400,
                        ),
                        heightBox(42.h),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                try {
                                  isLoading = true;
                                  Get.bottomSheet(PhoneCountryCodeList(
                                    onSelect: (c) {
                                      phoneDialCode = c;
                                      setState(() {});
                                    },
                                  ));
                                } finally {
                                  isLoading = false;
                                }
                              },
                              icon: const Icon(Icons.keyboard_arrow_down),
                              label: TextWidget(
                                text: phoneDialCode,
                                color: color239,
                                fontSize: 16.sp,
                                fontFamily: strFontName,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Expanded(
                              child: Focus(
                                focusNode: phoneFocus,
                                onFocusChange: (hasFocus) {
                                  setState(() {});
                                },
                                child: TextEditingWidget(
                                  controller: phoneController,
                                  isShadowEnable: false,
                                  hint: appText(context).strPhoneNumber,
                                  color:
                                      phoneFocus.hasFocus ? colorFDF : colorFF3,
                                  fieldBorderClr:
                                      phoneFocus.hasFocus ? colorF73 : null,
                                  textInputType: TextInputType.phone,
                                  textInputAction: TextInputAction.done,
                                  onEditingComplete: () =>
                                      FocusScope.of(context).unfocus(),
                                  inputFormatters: [maskFormatter],
                                ),
                              ),
                            ),
                          ],
                        ),
                        heightBox(20.h),
                        Consumer<AuthenticationProvider>(
                          builder: (context, auth, b) {
                            return CommonButton(
                              showLoading: auth.isSigningIn,
                              onTap: () async {
                                auth.verifyPhoneNumber(
                                    '$phoneDialCode ${phoneController.text.trim()}');
                              },
                              text: appText(context).strSendNow,
                              width: double.infinity,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 50,
          left: 0,
          child: IconButton(
            onPressed: () => Get.back(),
            icon: SvgPicture.asset(icIosBackArrow),
          ),
        )
      ],
    ));
  }
}

class PhoneCountryCodeList extends StatelessWidget {
  PhoneCountryCodeList({super.key, required this.onSelect});
  final searchController = TextEditingController();
  final Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    final search = Provider.of<SearchProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.sp), topRight: Radius.circular(12.sp)),
      ),
      child: Column(
        children: [
          TextEditingWidget(
            controller: searchController,
            isShadowEnable: false,
            hint: 'Write here to search country code',
            color: colorFF3,
            onChanged: (v) {
              search.searchText(v);
            },
          ),
          heightBox(12.h),
          Consumer<SearchProvider>(
            builder: (context, prov, b) {
              if (searchController.text.isEmpty) {
                return Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var country = cntryCodes[index];
                      return ListTile(
                        onTap: () {
                          // phone.changeCode(country.dialCode);
                          onSelect(country.dialCode ?? '');
                          Get.back();
                        },
                        leading: TextWidget(
                          text: country.dialCode,
                        ),
                        title: TextWidget(
                          text: country.name,
                        ),
                        trailing: TextWidget(
                          text: country.code,
                        ),
                      );
                    },
                    itemCount: cntryCodes.length,
                  ),
                );
              }

              var filterList = cntryCodes
                  .where((element) =>
                      element.code!
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()) ||
                      element.name!
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()) ||
                      element.dialCode!
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()))
                  .toList();

              return Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var country = filterList[index];
                    return ListTile(
                      onTap: () {
                        // phone.changeCode(country.dialCode);
                        onSelect(country.dialCode ?? '');
                        Get.back();
                      },
                      leading: TextWidget(
                        text: country.dialCode,
                      ),
                      title: TextWidget(
                        text: country.name,
                      ),
                      trailing: TextWidget(
                        text: country.code,
                      ),
                    );
                  },
                  itemCount: filterList.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

List<CountryCodeModel> get cntryCodes {
  return countryCodes
      .map((event) => CountryCodeModel.fromJson(event!))
      .toList();
}
