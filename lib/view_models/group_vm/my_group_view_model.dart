import 'package:flutter/material.dart';

class MyGroupViewModel with ChangeNotifier{
  bool isCreateGrpTab = false;

  onChangeTabBar(index){
   isCreateGrpTab = index == 1 ?  true : false;
    notifyListeners();
  }
}