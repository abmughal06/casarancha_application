import 'dart:convert';

import 'package:casarancha/models/post_creator_details.dart';

class NotificationModel {
  String? id;
  String? appUserId;
  CreatorDetails? createdDetails;
  String? msg;
  bool? isRead;
  String? createdAt;
  String? imageUrl;

  NotificationModel({
    this.id,
    this.createdDetails,
    this.isRead,
    this.appUserId,
    this.msg,
    this.imageUrl,
    this.createdAt,
  });

  NotificationModel copyWith({
    String? id,
    CreatorDetails? createdDetails,
    String? appUserId,
    dynamic msg,
    String? imageUrl,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      isRead: isRead ?? false,
      createdDetails: createdDetails ?? this.createdDetails,
      appUserId: appUserId ?? this.appUserId,
      imageUrl: imageUrl ?? this.imageUrl,
      msg: msg ?? this.msg,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'isRead': isRead,
      'imageUrl': imageUrl,
      'createdDetails': createdDetails!.toMap(),
      'appUserId': appUserId,
      'content': msg,
      'createdAt': createdAt
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      isRead: map['isRead'],
      imageUrl: map['imageUrl'],
      createdDetails: CreatorDetails.fromMap(map['createdDetails']),
      appUserId: map['appUserId'],
      msg: map['content'] as dynamic,
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id,imageUrl:$imageUrl, createdDetails: $createdDetails, appUserId: $appUserId, content: $msg, createdAt: $createdAt, isRead: $isRead)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.isRead == isRead &&
        other.imageUrl == imageUrl &&
        other.createdDetails == createdDetails &&
        other.appUserId == appUserId &&
        other.msg == msg &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        isRead.hashCode ^
        imageUrl.hashCode ^
        createdDetails.hashCode ^
        appUserId.hashCode ^
        msg.hashCode ^
        createdAt.hashCode;
  }
}
