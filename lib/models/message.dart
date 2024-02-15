import 'dart:convert';

class Message {
  String id;
  String sentToId;
  String sentById;
  dynamic content;
  String caption;
  String type;
  bool isReply;
  String createdAt;
  bool isSeen;
  Message({
    required this.id,
    required this.sentToId,
    required this.sentById,
    required this.content,
    required this.caption,
    required this.type,
    required this.createdAt,
    required this.isReply,
    required this.isSeen,
  });

  Message copyWith({
    String? id,
    String? sentToId,
    String? sentById,
    dynamic content,
    String? caption,
    String? type,
    String? createdAt,
    bool? isSeen,
    bool? isReply,
  }) {
    return Message(
      id: id ?? this.id,
      sentToId: sentToId ?? this.sentToId,
      sentById: sentById ?? this.sentById,
      content: content ?? this.content,
      caption: caption ?? this.caption,
      type: type ?? this.type,
      isReply: isReply ?? this.isReply,
      createdAt: createdAt ?? this.createdAt,
      isSeen: isSeen ?? this.isSeen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sentToId': sentToId,
      'sentById': sentById,
      'content': content,
      'caption': caption,
      'type': type,
      'isReply': isReply,
      'createdAt': createdAt,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      isReply: map['isReply'] ?? false,
      sentToId: map['sentToId'] as String,
      sentById: map['sentById'] as String,
      content: map['content'] as dynamic,
      caption: map['caption'] as String,
      type: map['type'] as String,
      createdAt: map['createdAt'] as String,
      isSeen: map['isSeen'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(id: $id, sentToId: $sentToId, sentById: $sentById, content: $content, caption: $caption, type: $type, createdAt: $createdAt, isSeen: $isSeen)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.sentToId == sentToId &&
        other.sentById == sentById &&
        other.content == content &&
        other.caption == caption &&
        other.type == type &&
        other.createdAt == createdAt &&
        other.isSeen == isSeen;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sentToId.hashCode ^
        sentById.hashCode ^
        content.hashCode ^
        caption.hashCode ^
        type.hashCode ^
        createdAt.hashCode ^
        isSeen.hashCode;
  }
}
