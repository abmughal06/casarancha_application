import 'dart:convert';

import 'package:casarancha/models/post_creator_details.dart';

class Comment {
  final String id;
  final String postId;
  final String creatorId;
  final CreatorDetails creatorDetails;
  final String createdAt;
  final String message;
  Comment({
    required this.postId,
    required this.id,
    required this.creatorId,
    required this.creatorDetails,
    required this.createdAt,
    required this.message,
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? creatorId,
    CreatorDetails? creatorDetails,
    String? createdAt,
    String? message,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      creatorId: creatorId ?? this.creatorId,
      creatorDetails: creatorDetails ?? this.creatorDetails,
      createdAt: createdAt ?? this.createdAt,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creatorId': creatorId,
      'postId': postId,
      'creatorDetails': creatorDetails.toMap(),
      'createdAt': createdAt,
      'message': message,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      postId: map['postId'] ?? '',
      creatorId: map['creatorId'] ?? '',
      creatorDetails: CreatorDetails.fromMap(map['creatorDetails']),
      createdAt: map['createdAt'] ?? '',
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Comment(id: $id, postId:$postId,creatorId: $creatorId, creatorDetails: $creatorDetails, createdAt: $createdAt, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.postId == postId &&
        other.id == id &&
        other.creatorId == creatorId &&
        other.creatorDetails == creatorDetails &&
        other.createdAt == createdAt &&
        other.message == message;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        postId.hashCode ^
        creatorId.hashCode ^
        creatorDetails.hashCode ^
        createdAt.hashCode ^
        message.hashCode;
  }
}
