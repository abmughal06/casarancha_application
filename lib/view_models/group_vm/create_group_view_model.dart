import 'package:flutter/material.dart';

class CreateGroupViewModel with ChangeNotifier{
  bool isSelectPublicType = false;

  onChangePublicType(){
    isSelectPublicType = true;
    notifyListeners();
  }
  onChangePrivateType(){
    isSelectPublicType = false;
    notifyListeners();
  }
}