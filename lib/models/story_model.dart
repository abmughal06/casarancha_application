import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/post_creator_details.dart';

class Story {
  String id;
  String creatorId;
  String createdAt;
  List<MediaDetails> mediaDetailsList;
  CreatorDetails creatorDetails;
  Story({
    required this.id,
    required this.creatorId,
    required this.createdAt,
    required this.mediaDetailsList,
    required this.creatorDetails,
  });

  Story copyWith({
    String? id,
    String? creatorId,
    String? createdAt,
    List<MediaDetails>? mediaDetailsList,
    CreatorDetails? creatorDetails,
  }) {
    return Story(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      mediaDetailsList: mediaDetailsList ?? this.mediaDetailsList,
      creatorDetails: creatorDetails ?? this.creatorDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creatorId': creatorId,
      'createdAt': createdAt,
      'mediaDetailsList': mediaDetailsList.map((x) => x.toMap()).toList(),
      'creatorDetails': creatorDetails.toMap(),
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      id: map['id'] ?? '',
      creatorId: map['creatorId'] ?? '',
      createdAt: map['createdAt'] ?? '',
      mediaDetailsList: List<MediaDetails>.from(
          map['mediaDetailsList']?.map((x) => MediaDetails.fromMap(x))),
      creatorDetails: CreatorDetails.fromMap(map['creatorDetails']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) => Story.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Story(id: $id, creatorId: $creatorId, createdAt: $createdAt, mediaDetailsList: $mediaDetailsList, creatorDetails: $creatorDetails)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Story &&
        other.id == id &&
        other.creatorId == creatorId &&
        other.createdAt == createdAt &&
        listEquals(other.mediaDetailsList, mediaDetailsList) &&
        other.creatorDetails == creatorDetails;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        creatorId.hashCode ^
        createdAt.hashCode ^
        mediaDetailsList.hashCode ^
        creatorDetails.hashCode;
  }
}
