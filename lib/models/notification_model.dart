import 'dart:convert';

import 'package:casarancha/models/post_creator_details.dart';

class NotificationModel {
  String? id;
  String? appUserId;
  String? title;
  CreatorDetails? createdDetails;
  String? msg;
  String? createdAt;

  NotificationModel({
    this.id,
    this.createdDetails,
    this.appUserId,
    this.msg,
    this.title,
    this.createdAt,
  });

  NotificationModel copyWith({
    String? id,
    CreatorDetails? createdDetails,
    String? appUserId,
    dynamic msg,
    String? caption,
    String? title,
    String? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      createdDetails: createdDetails ?? this.createdDetails,
      appUserId: appUserId ?? this.appUserId,
      msg: msg ?? this.msg,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'createdDetails': createdDetails!.toMap(),
      'appUserId': appUserId,
      'content': msg,
      'createdAt': createdAt
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      title: map['title'] as String,
      createdDetails: CreatorDetails.fromMap(map['creatorDetails']),
      appUserId: map['appUserId'] as String,
      msg: map['content'] as dynamic,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, createdDetails: $createdDetails, appUserId: $appUserId, content: $msg, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.createdDetails == createdDetails &&
        other.appUserId == appUserId &&
        other.msg == msg &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdDetails.hashCode ^
        title.hashCode ^
        appUserId.hashCode ^
        msg.hashCode ^
        createdAt.hashCode;
  }
}
