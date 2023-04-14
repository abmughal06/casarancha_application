import 'package:flutter/material.dart';

import '../../utils/app_utils.dart';
import '../common_card_post_vm.dart';

class SearchScreenViewModel extends CommonCardPostVm{

  TextEditingController searchController = TextEditingController();
  onChangeTabBar(){
    printLog("Clear Text");
    searchController.text = "";
    notifyListeners();
  }

}