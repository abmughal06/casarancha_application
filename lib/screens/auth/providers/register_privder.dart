import 'package:flutter/material.dart';

import '../../../resources/color_resources.dart';
import '../../../resources/image_resources.dart';

class RegisterProvider extends ChangeNotifier {
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPwdFocus = FocusNode();

  String? icUsernameSvg, icEmailSvg, icPasswordSvg, icConfirmPwdSvg;
  Color? usernameFillClr,
      emailFillClr,
      passwordFillClr,
      confirmPwdFillClr,
      usernameBorderClr,
      emailBorderClr,
      passwordBorderClr,
      confirmPwdBorderClr;

  setPwdVisibility() {
    passwordVisible = !passwordVisible;
    icPasswordSvg == icShowPassword
        ? icPasswordSvg = icHidePassword
        : icPasswordSvg = icShowPassword;
    notifyListeners();
  }

  setConfirmPwdVisibility() {
    confirmPasswordVisible = !confirmPasswordVisible;
    icConfirmPwdSvg == icShowPassword
        ? icConfirmPwdSvg = icHidePassword
        : icConfirmPwdSvg = icShowPassword;
    notifyListeners();
  }

  bool isRegistering = false;

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

  setConfirmPwdFocusChange() {
    if (confirmPwdFocus.hasFocus) {
      // icConfirmPwdSvg = icSelectLock;
      confirmPwdFillClr = colorFDF;
      confirmPwdBorderClr = colorF73;
    } else {
      // icConfirmPwdSvg = icDeselectLock;
      confirmPwdFillClr = colorFF3;
      confirmPwdBorderClr = null;
    }
    notifyListeners();
  }

  void emailFocusChange() {
    setEmailFocusChange();
  }

  void pwdFocusChange() {
    setPwdFocusChange();
  }

  void confirmPwdFocusChange() {
    setConfirmPwdFocusChange();
  }
}
