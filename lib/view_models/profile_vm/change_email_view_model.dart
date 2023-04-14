import 'package:casarancha/view_models/common_view_model.dart';
import 'package:flutter/material.dart';

import '../../resources/color_resources.dart';

class ChangeEmailViewModel extends CommonViewModel {
  FocusNode newEmailFocus = FocusNode();
  String? icNewEmailSvg;
  Color? newEmailFillClr,newEmailBorderClr;

  setEmailFocusChange() {
    if (newEmailFocus.hasFocus) {
      newEmailFillClr = colorFDF;
      newEmailBorderClr = colorF73;
    } else {
      newEmailFillClr = colorFF3;
      newEmailBorderClr = null;
    }

    notifyListeners();
  }
}