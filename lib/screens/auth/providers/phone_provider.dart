import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../resources/color_resources.dart';

class PhoneProvider extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  FocusNode phoneFocus = FocusNode();
  Color? phoneFillClr, phoneBorderClr;
  String phoneDialCode = '+1';

  var isLoading = false;
  setPhoneFocusChange() {
    if (phoneFocus.hasFocus) {
      phoneFillClr = colorFDF;
      phoneBorderClr = colorF73;
    } else {
      phoneFillClr = colorFF3;
      phoneBorderClr = null;
    }
    notifyListeners();
  }

  changeCode(v) {
    phoneDialCode = v;
    Get.back();
    notifyListeners();
  }

  void phoneFocusChange(BuildContext context) {
    setPhoneFocusChange();
  }
}
