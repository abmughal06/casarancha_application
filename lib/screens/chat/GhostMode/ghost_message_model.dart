import 'package:casarancha/screens/chat/GhostMode/ghost_chat_helper.dart';

class GhostMessageModel {
  String? message;
  String? senderId;
  int? createdAt;
  String? objectId;
  DateTime? date;
  GhostMessageModel(
      {this.message, this.senderId, this.createdAt, this.objectId});

  GhostMessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    senderId = json['senderId'];
    createdAt = json['createdAt'];
    objectId = json['objId'];
    date = json['createdAt'] != null
        ? GhostChatHelper.shared.convertTimeStampToDateTime(json['createdAt'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message?.replaceFirst(
        (message ?? "")[0], (message ?? "")[0].toUpperCase());
    data['senderId'] = senderId;
    data['createdAt'] = createdAt;
    data['objId'] = objectId;
    return data;
  }
}
