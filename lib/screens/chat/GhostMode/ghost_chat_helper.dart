// import 'package:casarancha/screens/chat/GhostMode/ghost_message_controller.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class GhostChatHelper {
//   static final GhostChatHelper _singleton = GhostChatHelper._internal();
//   factory GhostChatHelper() => _singleton;
//   GhostChatHelper._internal();
//   static GhostChatHelper get shared => _singleton;

//   GhostMessageController get gMessageCtrl =>
//       Get.isRegistered<GhostMessageController>()
//           ? Get.find<GhostMessageController>()
//           : Get.put(GhostMessageController());
//   String filterUserId(String userId) {
//     if (userId.contains("ghost_")) {
//       return userId.replaceAll("ghost_", "");
//     } else {
//       return userId;
//     }
//   }

//   String usersCollectionName = "users";
//   String ghostChatRoomsColletionName = "ghostChatRooms";
//   String ghostConversationColletionName = "ghostConversation";
//   String ghostMessageCollectionName = "ghostMessages";

//   FirebaseFirestore get firestore => FirebaseFirestore.instance;
//   CollectionReference<Map<String, dynamic>> get userCollection =>
//       firestore.collection(usersCollectionName);
//   CollectionReference<Map<String, dynamic>> get ghostCharRoomsColletion =>
//       firestore.collection(ghostChatRoomsColletionName);
//   CollectionReference<Map<String, dynamic>> ghostConversationColletion(
//           String userId) =>
//       userCollection
//           .doc(filterUserId(userId))
//           .collection(ghostConversationColletionName);
//   CollectionReference<Map<String, dynamic>> ghostMessageColletion(
//           String chatId) =>
//       ghostCharRoomsColletion
//           .doc(chatId)
//           .collection(ghostMessageCollectionName);

//   DateTime convertTimeStampToDateTime(int timeStamp) {
//     var dateToTimeStamp = DateTime.fromMicrosecondsSinceEpoch(timeStamp);
//     return dateToTimeStamp;
//   }

//   String convertTimeStampToHumanDate(int timeStamp) {
//     var dateToTimeStamp = DateTime.fromMicrosecondsSinceEpoch(timeStamp);
//     return DateFormat('MMM dd, yy').format(dateToTimeStamp);
//   }

//   String convertTimeStampToHumanHour(int timeStamp) {
//     var dateToTimeStamp = DateTime.fromMicrosecondsSinceEpoch(timeStamp);
//     return DateFormat('h:mm a').format(dateToTimeStamp);
//   }
// }
