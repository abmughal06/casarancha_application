import 'package:casarancha/view_models/common_view_model.dart';

class OtpVerifyViewModel extends CommonViewModel {
  bool isReceiveOtp = true;
  onChangeReceiveOtp(){
    isReceiveOtp = !isReceiveOtp;
    notifyListeners();
  }
}
