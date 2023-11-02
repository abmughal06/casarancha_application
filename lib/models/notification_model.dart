import 'package:casarancha/models/post_creator_details.dart';

class NotificationModel {
  String? sentToId;
  String? sentById;
  dynamic content;
  String? notificationType;
  String? groupId;
  CreatorDetails? createdDetails;
  String? msg;
  bool? isRead;
  String? createdAt;

  NotificationModel({
    this.sentToId,
    this.sentById,
    this.content,
    this.notificationType,
    this.groupId,
    this.createdDetails,
    this.isRead,
    this.msg,
    this.createdAt,
  });

  NotificationModel copyWith({
    String? sentToId,
    String? sentById,
    dynamic content,
    String? notificationType,
    String? groupId,
    CreatorDetails? createdDetails,
    dynamic msg,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationModel(
      sentById: sentById ?? this.sentById,
      sentToId: sentToId ?? this.sentToId,
      content: content ?? this.content,
      notificationType: notificationType ?? this.notificationType,
      groupId: groupId ?? this.groupId,
      isRead: isRead ?? false,
      createdDetails: createdDetails ?? this.createdDetails,
      msg: msg ?? this.msg,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sentToId': sentToId,
      'sentById': sentById,
      'content': content,
      'notificationType': notificationType,
      'groupId': groupId,
      'isRead': isRead,
      'createdDetails': createdDetails!.toMap(),
      'msg': msg,
      'createdAt': createdAt
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      groupId: map['groupId'],
      notificationType: map['notificationType'],
      sentById: map['sentById'],
      sentToId: map['sentToId'],
      content: map['content'] as dynamic,
      isRead: map['isRead'],
      createdDetails: CreatorDetails.fromMap(map['createdDetails']),
      msg: map['msg'],
      createdAt: map['createdAt'],
    );
  }
}
