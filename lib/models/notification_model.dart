import 'dart:convert';

class NotificationModel {
  String id;
  String type;
  String createdDetails;
  String sentById;
  String content;
  String createdAt;

  NotificationModel({
    required this.id,
    required this.createdDetails,
    required this.sentById,
    required this.content,
    required this.type,
    required this.createdAt,
  });

  NotificationModel copyWith({
    String? id,
    String? createdDetails,
    String? sentById,
    dynamic content,
    String? caption,
    String? type,
    String? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      createdDetails: createdDetails ?? this.createdDetails,
      sentById: sentById ?? this.sentById,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdDetails': createdDetails,
      'sentById': sentById,
      'content': content,
      'type': type,
      'createdAt': createdAt
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      createdDetails: map['createdDetails'] as String,
      sentById: map['sentById'] as String,
      content: map['content'] as dynamic,
      type: map['type'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id, createdDetails: $createdDetails, sentById: $sentById, content: $content, type: $type, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdDetails == createdDetails &&
        other.sentById == sentById &&
        other.content == content &&
        other.type == type &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdDetails.hashCode ^
        sentById.hashCode ^
        content.hashCode ^
        type.hashCode ^
        createdAt.hashCode;
  }
}
