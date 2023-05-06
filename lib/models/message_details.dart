// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:casarancha/models/post_creator_details.dart';

class MessageDetails {
  String id;
  String lastMessage;
  int unreadMessageCount;
  CreatorDetails creatorDetails;
  String createdAt;
  List<String> searchCharacters;
  MessageDetails({
    required this.id,
    required this.lastMessage,
    required this.unreadMessageCount,
    required this.creatorDetails,
    required this.createdAt,
    required this.searchCharacters,
  });

  MessageDetails copyWith({
    String? id,
    String? lastMessage,
    int? unreadMessageCount,
    CreatorDetails? creatorDetails,
    String? createdAt,
    List<String>? searchCharacters,
  }) {
    return MessageDetails(
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      creatorDetails: creatorDetails ?? this.creatorDetails,
      createdAt: createdAt ?? this.createdAt,
      searchCharacters: searchCharacters ?? this.searchCharacters,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'lastMessage': lastMessage,
      'unreadMessageCount': unreadMessageCount,
      'creatorDetails': creatorDetails.toMap(),
      'createdAt': createdAt,
      'searchCharacters': searchCharacters,
    };
  }

  factory MessageDetails.fromMap(map) {
    return MessageDetails(
      id: map['id'] as String,
      lastMessage: map['lastMessage'] as String,
      unreadMessageCount: map['unreadMessageCount'] as int,
      creatorDetails:
          CreatorDetails.fromMap(map['creatorDetails'] as Map<String, dynamic>),
      createdAt: map['createdAt'] as String,
      searchCharacters: List.from((map['searchCharacters'] as List)),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageDetails.fromJson(String source) =>
      MessageDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageDetails(id: $id, lastMessage: $lastMessage, unreadMessageCount: $unreadMessageCount, creatorDetails: $creatorDetails, createdAt: $createdAt, searchCharacters: $searchCharacters)';
  }

  @override
  bool operator ==(covariant MessageDetails other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.lastMessage == lastMessage &&
        other.unreadMessageCount == unreadMessageCount &&
        other.creatorDetails == creatorDetails &&
        other.createdAt == createdAt &&
        listEquals(other.searchCharacters, searchCharacters);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        lastMessage.hashCode ^
        unreadMessageCount.hashCode ^
        creatorDetails.hashCode ^
        createdAt.hashCode ^
        searchCharacters.hashCode;
  }
}
