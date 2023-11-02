import 'package:casarancha/screens/auth/providers/auth_provider.dart';
import 'package:casarancha/screens/auth/providers/phone_provider.dart';
import 'package:casarancha/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';
import '../../resources/localization_text_strings.dart';
import '../../resources/strings.dart';
import '../../utils/country_list.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/text_editing_widget.dart';
import '../../widgets/text_widget.dart';

class PhoneLoginScreen extends StatelessWidget {
  PhoneLoginScreen({Key? key}) : super(key: key);

  final maskFormatter = MaskTextInputFormatter(
      mask: '### ### ####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  final TextEditingController phoneController = TextEditingController();

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
              child: Consumer<PhoneProvider>(builder: (context, prov, b) {
                return ListView(
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
                            text: "Phone Login",
                            fontSize: 26.sp,
                            color: color13F,
                            fontWeight: FontWeight.w800,
                          ),
                          heightBox(4.h),
                          TextWidget(
                            textAlign: TextAlign.center,
                            text:
                                "Please Enter your phone\nnumber below to continue login",
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
                                    prov.isLoading = true;
                                    Get.bottomSheet(PhoneCountryCodeList());
                                  } finally {
                                    prov.isLoading = false;
                                  }
                                },
                                icon: const Icon(Icons.keyboard_arrow_down),
                                label: TextWidget(
                                  text: prov.phoneDialCode,
                                  color: color239,
                                  fontSize: 16.sp,
                                  fontFamily: strFontName,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Expanded(
                                child: Focus(
                                  focusNode: prov.phoneFocus,
                                  onFocusChange: (hasFocus) {
                                    prov.phoneFocusChange(context);
                                  },
                                  child: TextEditingWidget(
                                    controller: phoneController,
                                    isShadowEnable: false,
                                    hint: 'Phone Number',
                                    color: prov.phoneFillClr ?? colorFF3,
                                    fieldBorderClr: prov.phoneBorderClr,
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
                                    '${prov.phoneDialCode} ${phoneController.text.trim()}');
                              },
                              text: strSendNow,
                              width: double.infinity,
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ],
    ));
  }
}

class PhoneCountryCodeList extends StatelessWidget {
  PhoneCountryCodeList({Key? key}) : super(key: key);
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final phone = Provider.of<PhoneProvider>(context);
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
                          phone.changeCode(country.dialCode);
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
                        phone.changeCode(country.dialCode);
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
