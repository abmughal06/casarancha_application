import 'package:casarancha/models/user_model.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_chat_helper.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_message_controller.dart';
import 'package:casarancha/screens/chat/GhostMode/ghost_message_model.dart';
import 'package:casarancha/screens/profile/ProfileScreen/profile_screen_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../resources/color_resources.dart';

class GhostChatScreen extends StatefulWidget {
  GhostChatScreen({
    Key? key,
    this.chatId,
    this.receiverUserId,
    this.name,
  }) : super(key: key);
  String? chatId;
  String? receiverUserId;
  String? name;
  @override
  State<GhostChatScreen> createState() => _GhostChatScreenState();
}

UserModel? get user => Get.put(ProfileScreenController()).user.value;

class _GhostChatScreenState extends State<GhostChatScreen> {
  GhostMessageController chatCtrl = GhostChatHelper.shared.gMessageCtrl;
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (widget.chatId != null) {
        chatCtrl.setChatId(widget.chatId!);

        setState(() {});
        getMessages(null);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _arrMsg = [];

    super.dispose();
    messageStream?.drain();
    chatCtrl.disposeChatScreen(/* context */);
  }

  final TextEditingController _messageCtrl = TextEditingController();
  bool isWaiting = false;
  bool isLoading = false;
  List<GhostMessageModel> _arrMsg = [];

  Stream<QuerySnapshot<Map<String, dynamic>>>? messageStream;
  void getMessages(var documentSnapshot) async {
    var lastsnapshot = await documentSnapshot;
    if (documentSnapshot == null) {
      isLoading = true;
      messageStream = GhostChatHelper.shared
          .ghostMessageColletion(widget.chatId!)
          .orderBy("createdAt", descending: true)
          .limit(25)
          .snapshots();
    } else {
      setState(() {
        isWaiting = true;
      });

      messageStream = GhostChatHelper.shared
          .ghostMessageColletion(widget.chatId!)
          .orderBy("createdAt", descending: true)
          .startAfterDocument(lastsnapshot)
          .limit(25)
          .snapshots();
    }
    messageStream?.listen((event) {
      for (int i = 0; i < event.docs.length; i++) {
        setState(() {
          if (_arrMsg
              .where((element) =>
                  element.createdAt == event.docs[i].data()["createdAt"])
              .isEmpty) {
            _arrMsg.add(GhostMessageModel.fromJson(event.docs[i].data()));
          }
        });
      }
      setState(() {
        isWaiting = false;
        isLoading = false;
      });

      _arrMsg.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.name ?? "Ghost-${(widget.receiverUserId ?? "Person").hashCode}")),
      body: SafeArea(
        child: GetBuilder<GhostMessageController>(
            init: GhostChatHelper.shared.gMessageCtrl,
            builder: (gmCtrl) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent &&
                                !isWaiting &&
                                _arrMsg.isNotEmpty) {
                              getMessages(chatCtrl
                                  .getDocumentsnapShot(_arrMsg.first.objectId));
                            }
                            return true;
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _mainView(),
                          ),
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade400,
                                    spreadRadius: 2,
                                    blurRadius: 5)
                              ]),
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextFormField(
                              controller: _messageCtrl,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type something",
                                  suffixIcon: SizedBox(
                                    width: 50,
                                    height: 40,
                                    child: IconButton(
                                      visualDensity:
                                          const VisualDensity(horizontal: -3),
                                      onPressed: () async {
                                        await sendMessage();
                                      },
                                      icon: Icon(
                                        Icons.send,
                                        size: 25,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  )),
                            ),
                          ))
                    ],
                  ),
                  Visibility(
                      visible: (isLoading || gmCtrl.isChatLoading),
                      child: Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ))
                ],
              );
            }),
      ),
    );
  }

  Future<void> sendMessage() async {
    if (_messageCtrl.text.trim() != "") {
      String messageHolder = _messageCtrl.text;
      _messageCtrl.clear();

      await chatCtrl.onSendMessage(
        context,
        message: messageHolder,
        senderId: "${user?.id}",
        receiverId: widget.receiverUserId!,
      );
      if (messageStream == null) {
        setState(() {
          widget.chatId = chatCtrl.currentChatId;
        });
        getMessages(null);
      }
    }
  }

  Widget _mainView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Column(
        children: [
          Visibility(
              visible: isWaiting,
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: const CircularProgressIndicator(
                  color: Colors.green,
                ),
              )),
          Expanded(
            child: GroupedListView<GhostMessageModel, DateTime>(
              elements: _arrMsg,
              order: GroupedListOrder.DESC,
              reverse: true,
              floatingHeader: true,
              useStickyGroupSeparators: true,
              groupBy: (GhostMessageModel element) => DateTime(
                element.date?.year ?? 1970,
                element.date?.month ?? 1,
                element.date?.day ?? 1,
              ),
              groupHeaderBuilder: (GhostMessageModel element) => Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(3),
                      ),
                      padding: const EdgeInsets.all(9),
                      child: Text(
                        GhostChatHelper().convertTimeStampToHumanDate(
                                    element.createdAt!) ==
                                GhostChatHelper().convertTimeStampToHumanDate(
                                    DateTime.now().microsecondsSinceEpoch)
                            ? "Today"
                            : GhostChatHelper().convertTimeStampToHumanDate(
                                        element.createdAt!) ==
                                    GhostChatHelper()
                                        .convertTimeStampToHumanDate(
                                            DateTime.now()
                                                .subtract(
                                                    const Duration(days: 1))
                                                .microsecondsSinceEpoch)
                                ? "Yesterday"
                                : GhostChatHelper().convertTimeStampToHumanDate(
                                    element.createdAt!),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              itemBuilder: (_, GhostMessageModel? element) {
                return element?.senderId != "${user?.id}"
                    ? ReciverMessage(
                        message: element,

                        /*  message: element!.message!,
                        time: GhostChatHelper()
                            .convertTimeStampToHumanHour(element.messageDate!),
                        imageUrl: widget.receiverUserImageUrl ?? "", */
                      )
                    : SenderMessage(
                        message: element,
                        /*    message: element!.message!,
                        imageUrl: ModelManager.shared.authUser!.imageUrl ?? "",
                        time: GhostChatHelper()
                            .convertTimeStampToHumanHour(element.messageDate!) */
                      );
              },
              itemComparator: (GhostMessageModel a, GhostMessageModel b) =>
                  a.date!.compareTo(b.date!),
            ),
          ),
        ],
      ),
    );
  }
}

class ReciverMessage extends StatelessWidget {
  ReciverMessage({Key? key, this.message}) : super(key: key);
  GhostMessageModel? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                    child: Text(
                      message?.message ?? "N/A",
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      GhostChatHelper.shared.convertTimeStampToHumanHour(
                          message?.createdAt ?? 00),
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
            Container(width: MediaQuery.of(context).size.width / 6.5),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

class SenderMessage extends StatelessWidget {
  SenderMessage({Key? key, this.message}) : super(key: key);
  GhostMessageModel? message;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: MediaQuery.of(context).size.width / 6.5),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: colorF03,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                    child: Text(
                      message?.message ?? "N/A",
                      style: const TextStyle(color: color13F, fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      GhostChatHelper.shared.convertTimeStampToHumanHour(
                          message?.createdAt ?? 00),
                      style: const TextStyle(color: colorAA3, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
