import 'package:flutter/material.dart';

class GroupMembersViewModel with ChangeNotifier{
  bool showAddMember = true;

  onChangeTabBar(index){
    showAddMember = index == 1 ?  false : true;
    notifyListeners();
  }
}