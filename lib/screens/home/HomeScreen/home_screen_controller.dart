// import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeScreenController extends GetxController {
//   late ProfileScreenController profileScreenController;

//   String currentUserId = '';

//   final postQuerry = FirebaseFirestore.instance
//       .collection('posts')
//       .orderBy('createdAt', descending: true);

//   DocumentReference<Map<String, dynamic>> userDataQuerry(String id) {
//     return FirebaseFirestore.instance.collection('users').doc(id);
//   }

//   //OverRides
//   @override
//   void onInit() {
//     profileScreenController = Get.isRegistered<ProfileScreenController>()
//         ? Get.find<ProfileScreenController>()
//         : Get.put(ProfileScreenController());
//     currentUserId = profileScreenController.user.value.id;

//     super.onInit();
//   }

//   // setPrefData() async {
//   //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   //   await sharedPreferences.setBool(
//   //       'isGhostEnabled', profileScreenController.isGhostModeOn.value);
//   // }
// }
