import '../common_card_post_vm.dart';

class OtherProfileViewModel extends CommonCardPostVm{
  bool isFollow = true;
  onTapFollow(){
    isFollow = !isFollow;
    notifyListeners();
  }
}