// ignore_for_file: prefer_null_aware_operators

class GhostConversationModel {
  String? lastMessage;
  int? messageCreatedAt;
  String? senderId;
  String? receiverId;
  int? messageCount;
  String? chatId;
  String? objectId;
  String? receiverHashId;
  String? name;

  GhostConversationModel(
      {this.lastMessage,
      this.messageCreatedAt,
      this.senderId,
      this.receiverId,
      this.chatId,
      this.messageCount,
      this.name,
      this.objectId});

  GhostConversationModel.fromJson(Map<String, dynamic> json) {
    lastMessage = json['lastMessage'] != null
        ? json['lastMessage']?.replaceFirst((json['lastMessage'] ?? "")[0],
            (json['lastMessage'] ?? "")[0].toUpperCase())
        : null;
    messageCreatedAt = json['messageCreatedAt'];
    senderId = json['senderId'];
    chatId = json['chatId'];
    receiverId = json['receiverId'];
    messageCount = json['messageCount'];
    objectId = json['objId'];
    name = json['receiverName'];
    receiverHashId = json['receiverHashId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lastMessage'] = lastMessage?.replaceFirst(
        (lastMessage ?? "")[0], (lastMessage ?? "")[0].toUpperCase());
    data['messageCreatedAt'] = messageCreatedAt;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['messageCount'] = messageCount;
    data['objId'] = objectId;
    data['chatId'] = chatId;
    data['receiverName'] = name;
    data['receiverHashId'] = receiverId.hashCode.toString();
    return data;
  }
}
