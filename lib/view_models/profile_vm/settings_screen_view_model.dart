import 'package:casarancha/view_models/common_view_model.dart';

class SettingScreenViewModel extends CommonViewModel{
  bool isSwitched = true;
  onTapToggleSwitch({required bool isOn}){
    isSwitched = isOn;
    notifyListeners();
  }
}