// import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ChatListController extends GetxController {
//   final fbFireStore = FirebaseFirestore.instance;
//   final ProfileScreenController profileScreenController =
//       Get.find<ProfileScreenController>();

//   TextEditingController searchController = TextEditingController();
//   var encodeName = "";
//   var searchQuery = ''.obs;

//   List<String> get searchCharacters {
//     return [...searchController.text.toLowerCase().split('')];
//   }

//   Query<Map<String, dynamic>> get chatListQuery {
//     String currentuserId = profileScreenController.user.value.id;
//     return fbFireStore.collection('users');
//   }

//   Query<Map<String, dynamic>> get searchListQuery {
//     String currentuserId = profileScreenController.user.value.id;
//     return fbFireStore.collection('users').where("name",
//         isGreaterThanOrEqualTo: searchQuery.value,
//         isLessThan: "${searchQuery.value}'\uf8ff'");
//   }
// }
