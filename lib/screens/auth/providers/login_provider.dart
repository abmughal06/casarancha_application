import 'package:flutter/cupertino.dart';

import '../../../resources/color_resources.dart';
import '../../../resources/image_resources.dart';

class LoginProvider extends ChangeNotifier {
  bool isSigningIn = false;

  bool passwordVisible = true;
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  String? icEmailSvg, icPasswordSvg;
  Color? emailFillClr, passwordFillClr, emailBorderClr, passwordBorderClr;
  // DashboardController dashboardController = Get.find<DashboardController>();
  setPwdVisibility() {
    passwordVisible = !passwordVisible;
    icPasswordSvg == icShowPassword
        ? icPasswordSvg = icHidePassword
        : icPasswordSvg = icShowPassword;
    notifyListeners();
  }

  onFieldFocusChange() {
    notifyListeners();
  }

  setEmailFocusChange() {
    if (emailFocus.hasFocus) {
      icEmailSvg = icSelectEmail;
      emailFillClr = colorFDF;
      emailBorderClr = colorF73;
    } else {
      icEmailSvg = icDeselectEmail;
      emailFillClr = colorFF3;
      emailBorderClr = null;
    }
    notifyListeners();
  }

  setPwdFocusChange() {
    if (passwordFocus.hasFocus) {
      // icPasswordSvg = icSelectLock;
      passwordFillClr = colorFDF;
      passwordBorderClr = colorF73;
    } else {
      // icPasswordSvg = icDeselectLock;
      passwordFillClr = colorFF3;
      passwordBorderClr = null;
    }

    notifyListeners();
  }

  void emailFocusChange() {
    setEmailFocusChange();
  }

  void pwdFocusChange() {
    setPwdFocusChange();
  }
}
