import 'package:flutter/material.dart';

abstract class CommonCardPostVm with ChangeNotifier{
  List<bool> isLikedPostList = [false,false,false,false,false,false,false,false,false,false,false,false];
  List<bool> isSavedPost = [false,false,false,false,false,false,false,false,false,false,false,false];
  bool isOnSoundVideo = true ;
  bool isLoading = false;
  onTapSavePost({  required int index}){
    isSavedPost[index] = !isSavedPost[index];
    notifyListeners();
  }
  onTapLikePost({  required int index}){
    isLikedPostList[index] = !isLikedPostList[index];
    notifyListeners();
  }
  onTapNotify(){
    notifyListeners();
  }


  onStartLoader() {
    isLoading = true;
    notifyListeners();
  }

  onStopLoader() {
    isLoading = false;
    notifyListeners();
  }

  onNotifyListeners() {
    notifyListeners();
  }
}