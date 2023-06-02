import 'dart:async';
import 'dart:developer';

import 'package:casarancha/screens/chat/GhostMode/ghost_chat_helper.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_conversation_model.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class GhostMessageController extends GetxController {
  static final List<GhostConversationModel> _arrFriends = [];
  static final List<GhostConversationModel> _searchFriends = [];

  List<GhostConversationModel> get arrFriends =>
      searchQuery.isEmpty ? _arrFriends : _searchFriends;
  static String? _currentChatId;
  static String _searchQuery = "";
  bool _isChatLoading = false;

  bool get isChatLoading => _isChatLoading;

  String get searchQuery => _searchQuery.trim();
  static final List<String> _totalUserCount = [];

  List<String> get totalUserCount => _totalUserCount;

  String? get currentChatId => _currentChatId;

  void setChatId(String chatId) {
    _currentChatId = chatId;
    update();
  }

  void changeSearchQuery(String? query) async {
    if (query != null && query.trim().isNotEmpty) {
      _searchQuery = query
          .toLowerCase()
          .trim()
          .replaceAll(" ", "")
          .replaceAll("ghost-", "");
      _searchFriends.clear();
      createConversationStreamSubscription(
          FirebaseAuth.instance.currentUser?.uid ?? "");
    } else {
      _searchQuery = "";
      createConversationStreamSubscription(
          FirebaseAuth.instance.currentUser?.uid ?? "");
    }
    update();
  }

  void totalUSerCountinc(String userId) {
    if (!_totalUserCount.contains(userId)) {
      _totalUserCount.add(userId);
    }
    update();
  }

  void totalUserCountremove(String userId) {
    _totalUserCount.remove(userId);
    update();
  }

  void resetTotalUserNotificationCount() {
    _totalUserCount.clear();
    update();
  }

  //ConversationModel List Functions
  void addInfriendArr(GhostConversationModel conversationModel) {
    if (!_arrFriends
        .any((element) => element.objectId == conversationModel.objectId)) {
      _arrFriends.add(conversationModel);
    }
    if (!_searchFriends
        .any((element) => element.objectId == conversationModel.objectId)) {
      if (searchQuery.trim() == conversationModel.receiverHashId ||
          (conversationModel.name?.contains(searchQuery.toLowerCase().trim()) ??
              false)) {
        _searchFriends.add(conversationModel);
      }
    }
    update();
  }

  void replaceInfriendArr(int index, GhostConversationModel conversationModel) {
    int searchIndex = _searchFriends.indexWhere(
        (element) => element.objectId == conversationModel.objectId);
    if (_arrFriends.isEmpty) {
      addInfriendArr(conversationModel);
    } else {
      _arrFriends[index] = conversationModel;
    }
    if (searchQuery.isNotEmpty) {
      if (_searchFriends.isEmpty) {
        addInfriendArr(conversationModel);
      } else {
        _searchFriends[searchIndex] = conversationModel;
      }
    }
    update();
  }

  void shortFriendArray() {
    _arrFriends
        .sort((a, b) => b.messageCreatedAt!.compareTo(a.messageCreatedAt!));
    _searchFriends
        .sort((a, b) => b.messageCreatedAt!.compareTo(a.messageCreatedAt!));
    update();
  }

  void resetFriendArr() async {
    if (searchQuery.isEmpty) {
      _arrFriends.clear();
    }
    _searchFriends.clear();
    update();
  }

  Stream? conversationStream;
  StreamSubscription? conversationListner;

  void disposeStream() {
    conversationListner?.pause();
    conversationListner?.cancel();
    conversationListner = null;
    conversationStream?.drain();
    conversationStream = null;
    _arrFriends.clear();
    _searchFriends.clear();
    update();
  }

  Future<GhostConversationModel> addConversation({
    required String senderId,
    required String receiverId,
    required String chatId,
    int? messageCount,
    String? lastMessage,
    int? lastMessageDate,
  }) async {
    String? receiverName;
    DocumentSnapshot<Map<String, dynamic>> user =
        await GhostChatHelper.shared.userCollection.doc(receiverId).get();
    receiverName = user.data()?['name'];
    Map<String, dynamic> map = {};
    DocumentReference<Object> doc = GhostChatHelper.shared
        .ghostConversationColletion(senderId.toString())
        .doc();
    await doc.set(map);
    GhostConversationModel conversationModel = GhostConversationModel(
        chatId: chatId,
        messageCount: 1,
        senderId: senderId,
        receiverId: receiverId,
        lastMessage: lastMessage,
        name: (receiverName ?? "").toLowerCase().trim(),
        messageCreatedAt: lastMessageDate,
        objectId: doc.id);
    await doc.set(conversationModel.toJson());
    return conversationModel;
  }

  Future<void> updateConversation({
    required String senderID,
    required String receiverId,
    required int time,
    required String? message,
  }) async {
    try {
      QuerySnapshot<Map<String, dynamic>> senderSnapshot = await GhostChatHelper
          .shared
          .ghostConversationColletion(senderID.toString())
          .where("receiverId", isEqualTo: receiverId)
          .get();
      QuerySnapshot<Map<String, dynamic>> receiverSnapshot =
          await GhostChatHelper.shared
              .ghostConversationColletion(receiverId.toString())
              .where("receiverId", isEqualTo: senderID)
              .get();
      DocumentReference<Map<String, dynamic>> senderConversationDoc =
          senderSnapshot.docs.first.reference;
      DocumentReference receiverSnapshotDoc =
          receiverSnapshot.docs.first.reference;
      await senderConversationDoc.update({
        "lastMessage": message,
        "messageCreatedAt": time,
      });
      await receiverSnapshotDoc.update({
        "lastMessage": message,
        "messageCreatedAt": time,
        "messageCount":
            receiverSnapshot.docs.first.data()['messageCount'] == null
                ? 1
                : receiverSnapshot.docs.first.data()['messageCount'] + 1
      });
    } catch (e) {
      log("Error in updateConversation=>$e");
    }
  }

  Future<String> createChat() async {
    DocumentReference<Map<String, dynamic>> doc =
        GhostChatHelper.shared.ghostCharRoomsColletion.doc();
    await doc.set({"objId": doc.id});
    return doc.id;
  }

  Future<GhostMessageModel> addMessages({
    required String chatId,
    required String senderId,
    required int time,
    required String? message,
  }) async {
    Map<String, dynamic> map = {};
    DocumentReference<Object> doc =
        await GhostChatHelper.shared.ghostMessageColletion(chatId).add(map);

    GhostMessageModel messageModel = GhostMessageModel(
        objectId: doc.id,
        createdAt: time,
        message: message,
        senderId: senderId);
    await doc.set(messageModel.toJson());

    return messageModel;
  }

  Future<void> initConverSationStream(String senderId) async {
    if (conversationStream == null || searchQuery.isEmpty) {
      conversationStream = GhostChatHelper.shared
          .ghostConversationColletion(senderId)
          .snapshots();
    } else {
      Stream<QuerySnapshot<Map<String, dynamic>>>? snapshots1 = GhostChatHelper
          .shared
          .ghostConversationColletion(senderId)
          .where("receiverHashId", isEqualTo: searchQuery)
          .snapshots();
      Stream<QuerySnapshot<Map<String, dynamic>>>? snapshots2 = GhostChatHelper
          .shared
          .ghostConversationColletion(senderId)
          .where("receiverName",
              isGreaterThanOrEqualTo: searchQuery,
              isLessThan: "${searchQuery.toLowerCase()}'\uf8ff'")
          .snapshots();
      conversationStream = CombineLatestStream.combine2(snapshots1, snapshots2,
          (QuerySnapshot<Map<String, dynamic>> s1,
              QuerySnapshot<Map<String, dynamic>> s2) {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> list = [];
        for (var element in s1.docs) {
          if (list.where((e) => e.id == element.id).isEmpty) {
            list.add(element);
          }
        }
        for (var element in s2.docs) {
          if (list.where((e) => e.id == element.id).isEmpty) {
            list.add(element);
          }
        }

        return list;
      });
    }

    update();
  }

  void createConversationStreamSubscription(String senderId) {
    initConverSationStream(senderId);

    conversationListner = conversationStream?.listen((snapshot) async {
      if (snapshot is QuerySnapshot<Map<String, dynamic>>) {
        if (snapshot.docs.isEmpty) {
          resetFriendArr();
        } else {
          try {
            for (int i = 0; i < snapshot.docs.length; i++) {
              await getFriendInfo(
                conversationModel:
                    GhostConversationModel.fromJson(snapshot.docs[i].data()),
              );
            }
          } catch (e) {
            log("Error in createConversationStreamSubscription => $e");
          }
        }
      } else if (snapshot
          is List<QueryDocumentSnapshot<Map<String, dynamic>>>) {
        for (var e in snapshot) {
          await getFriendInfo(
            conversationModel: GhostConversationModel.fromJson(e.data()),
          );
        }
      }
    });
  }

  Future resetMessageUnreadCount({
    required String senderID,
    required String receiverId,
  }) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await GhostChatHelper
        .shared
        .ghostConversationColletion(senderID)
        .where("receiverId", isEqualTo: receiverId)
        .get();
    DocumentReference userConversationDoc = querySnapshot.docs.first.reference;
    await userConversationDoc.update({
      "messageCount": 0,
    });
  }

  Future<Map<String, dynamic>> getUserById(String id) async {
    QuerySnapshot<Map<String, dynamic>> doc = await GhostChatHelper
        .shared.userCollection
        .where("id", isEqualTo: id.split("_").last)
        .get();
    if (doc.docs.isNotEmpty) {
      return doc.docs.first.data();
    } else {
      return {};
    }
  }

  Future<void> getFriendInfo({
    required GhostConversationModel conversationModel,
  }) async {
    Map<String, dynamic> friend =
        await getUserById(conversationModel.receiverId ?? "");

    int index = 0;
    index = arrFriends
        .indexWhere((element) => element.receiverId == "${friend['id']}");
    print(index);

    if (friend.isNotEmpty) {
      if (index != -1) {
        /*  conversationModel.userName = friend["name"].toString().toCapitalized();
        conversationModel.userImageUrl = friend["imageUrl"];
        conversationModel.email = friend["email"];
        conversationModel.type = friend["type"];
 */
        replaceInfriendArr(index, conversationModel);
      } else {
        /*    conversationModel.userName = friend["name"].toString().toCapitalized();
        conversationModel.userImageUrl = friend["imageUrl"];
        conversationModel.email = friend["email"];
        conversationModel.type = friend["type"]; */

        addInfriendArr(conversationModel);
      }
      if ((conversationModel.messageCount ?? 0) > 0) {
        totalUSerCountinc(conversationModel.receiverId ?? "");
      } else {
        totalUserCountremove(conversationModel.receiverId ?? "");
      }
    }
    shortFriendArray();
/*   print(chatController.arrFriends.length); */
  }

  void changeChatLoading(bool state) {
    _isChatLoading = state;
    update();
  }

  Future<void> onSendMessage(
    context, {
    required String senderId,
    required String? message,
    required String receiverId,
  }) async {
    var time = DateTime.now().microsecondsSinceEpoch;
    if (currentChatId == null) {
      changeChatLoading(true);
      QuerySnapshot<Map<String, dynamic>> doc = await GhostChatHelper.shared
          .ghostConversationColletion(senderId)
          .where("receiverId", isEqualTo: receiverId)
          .get();
      if (doc.docs.isEmpty) {
        String chatId = await createChat();
        setChatId(chatId);
        await createNewConversation(context,
            message: message,
            receiverId: receiverId,
            senderId: senderId,
            time: time);
      }
      changeChatLoading(false);
    }
    if (currentChatId != null) {
      await sendMessage(message: message, senderId: senderId, time: time);
      updateConversation(
          senderID: senderId,
          receiverId: receiverId,
          time: time,
          message: message);
    }
  }

  Future<void> createNewConversation(context,
      {required String? message,
      required int time,
      required String receiverId,
      required String senderId}) async {
    await addConversation(
        senderId: senderId,
        receiverId: receiverId,
        lastMessage: message,
        chatId: currentChatId!,
        lastMessageDate: time);
    await addConversation(
      senderId: receiverId,
      receiverId: senderId,
      lastMessage: message,
      chatId: currentChatId!,
      lastMessageDate: time,
    );
    var index =
        arrFriends.indexWhere((element) => element.receiverId == receiverId);
    print(index);
  }

  Future<void> sendMessage({
    required String? message,
    required String senderId,
    required int time,
  }) async {
    await addMessages(
      chatId: currentChatId!,
      time: time,
      senderId: senderId,
      message: message,
    );
  }

  Future<DocumentSnapshot<Object?>> getDocumentsnapShot(obj) async {
    QuerySnapshot<Map<String, dynamic>> doc = await GhostChatHelper.shared
        .ghostMessageColletion(currentChatId!)
        .where("objId", isEqualTo: obj)
        .get();
    DocumentSnapshot documentSnapshot = doc.docs.first;
    return documentSnapshot;
  }

  void disposeChatScreen(/* context */) {
    _currentChatId = null;
    /* FocusScope.of(context).requestFocus(FocusNode()); */
  }
}
