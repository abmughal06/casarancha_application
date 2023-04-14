import 'package:casarancha/view_models/common_view_model.dart';
import 'package:flutter/material.dart';

import '../../resources/color_resources.dart';
import '../../resources/image_resources.dart';

class ChangeForgotPasswordViewModel extends CommonViewModel {
  FocusNode newPasswordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  String?  icNewPasswordSvg, icConfirmPwdSvg;
  Color?  newPasswordFillClr, confirmPwdFillClr;
  Color?  newPasswordBorderClr, confirmPwdBorderClr;

  bool  newPasswordVisible = true , confirmPasswordVisible = true;


  setNewPwdVisibility() {
    newPasswordVisible = !newPasswordVisible;
    icNewPasswordSvg == icShowPassword
        ? icNewPasswordSvg = icHidePassword
        : icNewPasswordSvg = icShowPassword;
    notifyListeners();
  }
  setConfirmPwdVisibility() {
    confirmPasswordVisible = !confirmPasswordVisible;
    icConfirmPwdSvg == icShowPassword
        ? icConfirmPwdSvg = icHidePassword
        : icConfirmPwdSvg = icShowPassword;
    notifyListeners();
  }

  setNewPwdFocusChange() {
    if (newPasswordFocus.hasFocus) {
      newPasswordFillClr = colorFDF;
      newPasswordBorderClr = colorF73;
    } else {
      newPasswordFillClr = colorFF3;
      newPasswordBorderClr = null;
    }

    notifyListeners();
  }

  setConfirmPwdFocusChange() {
    if (confirmPasswordFocus.hasFocus) {
      // icPasswordSvg = icSelectLock;
      confirmPwdFillClr = colorFDF;
      confirmPwdBorderClr = colorF73;
    } else {
      // icPasswordSvg = icDeselectLock;
      confirmPwdFillClr = colorFF3;
      confirmPwdBorderClr = null;
    }

    notifyListeners();
  }
}
