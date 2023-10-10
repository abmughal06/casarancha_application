import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:casarancha/models/post_creator_details.dart';

class GroupModel {
  String id;
  String name;
  String description;
  String imageUrl;
  String creatorId;
  CreatorDetails creatorDetails;
  String createdAt;
  List<String> postIds;
  List<String> memberIds;
  List<String> joinRequestIds;
  bool isPublic;
  bool isVerified;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.creatorId,
    required this.creatorDetails,
    required this.createdAt,
    this.postIds = const [],
    this.memberIds = const [],
    required this.joinRequestIds,
    required this.isVerified,
    required this.isPublic,
  });

  GroupModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    bool? isVerified,
    String? creatorId,
    CreatorDetails? creatorDetails,
    String? createdAt,
    List<String>? postIds,
    List<String>? memberIds,
    List<String>? joinRequestIds,
    bool? isPublic,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      creatorId: creatorId ?? this.creatorId,
      creatorDetails: creatorDetails ?? this.creatorDetails,
      createdAt: createdAt ?? this.createdAt,
      postIds: postIds ?? this.postIds,
      memberIds: memberIds ?? this.memberIds,
      joinRequestIds: joinRequestIds ?? this.joinRequestIds,
      isPublic: isPublic ?? this.isPublic,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'creatorId': creatorId,
      'creatorDetails': creatorDetails.toMap(),
      'createdAt': createdAt,
      'postIds': postIds,
      'memberIds': memberIds,
      'joinRequestIds': joinRequestIds,
      'isPublic': isPublic,
      'isVerified': isVerified,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      creatorId: map['creatorId'] ?? '',
      creatorDetails: CreatorDetails.fromMap(map['creatorDetails']),
      createdAt: map['createdAt'] ?? '',
      postIds: List<String>.from(map['postIds']),
      memberIds: List<String>.from(map['memberIds']),
      joinRequestIds: List<String>.from(map['joinRequestIds']),
      isPublic: map['isPublic'] ?? false,
      isVerified: map['isVerified'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GroupModel(id: $id, name: $name, isVerified: $isVerified,description: $description, imageUrl: $imageUrl, creatorId: $creatorId, creatorDetails: $creatorDetails, createdAt: $createdAt, postIds: $postIds, memberIds: $memberIds, joinRequestIds: $joinRequestIds, isPublic: $isPublic)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.isVerified == isVerified &&
        other.imageUrl == imageUrl &&
        other.creatorId == creatorId &&
        other.creatorDetails == creatorDetails &&
        other.createdAt == createdAt &&
        listEquals(other.postIds, postIds) &&
        listEquals(other.memberIds, memberIds) &&
        listEquals(other.joinRequestIds, joinRequestIds) &&
        other.isPublic == isPublic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        isVerified.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        creatorId.hashCode ^
        creatorDetails.hashCode ^
        createdAt.hashCode ^
        postIds.hashCode ^
        memberIds.hashCode ^
        joinRequestIds.hashCode ^
        isPublic.hashCode;
  }
}
