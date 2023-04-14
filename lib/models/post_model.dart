import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:casarancha/models/media_details.dart';
import 'package:casarancha/models/post_creator_details.dart';

class PostModel {
  String id;
  String creatorId;
  CreatorDetails creatorDetails;
  String createdAt;
  String description;
  String locationName;
  String shareLink;
  List<MediaDetails> mediaData;
  List<String> likesIds;
  List<String> commentIds;
  List<String> tagsIds;
  bool showPostTime = true;
  bool isQuotaExpanded = false;
  int? reportCount;
  String? postBlockStatus;
  PostModel({
    required this.id,
    required this.creatorId,
    required this.creatorDetails,
    required this.createdAt,
    required this.description,
    required this.locationName,
    required this.shareLink,
    this.mediaData = const [],
    this.likesIds = const [],
    this.isQuotaExpanded = false,
    this.commentIds = const [],
    this.tagsIds = const [],
    this.showPostTime = true,
    this.reportCount = 0,
    this.postBlockStatus,
  });

  PostModel copyWith(
      {String? id,
      String? creatorId,
      CreatorDetails? creatorDetails,
      String? createdAt,
      String? description,
      String? locationName,
      String? shareLink,
      List<MediaDetails>? mediaData,
      List<String>? likesIds,
      List<String>? commentIds,
      List<String>? tagsIds,
      bool? showPostTime,
      int? reportCount,
      String? postBlockStatus}) {
    return PostModel(
        id: id ?? this.id,
        creatorId: creatorId ?? this.creatorId,
        creatorDetails: creatorDetails ?? this.creatorDetails,
        createdAt: createdAt ?? this.createdAt,
        description: description ?? this.description,
        locationName: locationName ?? this.locationName,
        shareLink: shareLink ?? this.shareLink,
        mediaData: mediaData ?? this.mediaData,
        likesIds: likesIds ?? this.likesIds,
        commentIds: commentIds ?? this.commentIds,
        tagsIds: tagsIds ?? this.tagsIds,
        showPostTime: showPostTime ?? this.showPostTime,
        reportCount: reportCount ?? this.reportCount,
        postBlockStatus: postBlockStatus ?? this.postBlockStatus);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creatorId': creatorId,
      'creatorDetails': creatorDetails.toMap(),
      'createdAt': createdAt,
      'description': description,
      'locationName': locationName,
      'shareLink': shareLink,
      'mediaData': mediaData.map((x) => x.toMap()).toList(),
      'likesIds': likesIds,
      'commentIds': commentIds,
      'tagsIds': tagsIds,
      'showPostTime': showPostTime,
      'reportCount': reportCount,
      'postBlockStatus': postBlockStatus
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
        id: map['id'] ?? '',
        creatorId: map['creatorId'] ?? '',
        creatorDetails: CreatorDetails.fromMap(map['creatorDetails']),
        createdAt: map['createdAt'] ?? '',
        description: map['description'] ?? '',
        locationName: map['locationName'] ?? '',
        shareLink: map['shareLink'] ?? '',
        mediaData: List<MediaDetails>.from(
            map['mediaData']?.map((x) => MediaDetails.fromMap(x))),
        likesIds: List<String>.from(map['likesIds']),
        commentIds: List<String>.from(map['commentIds']),
        tagsIds: List<String>.from(map['tagsIds']),
        showPostTime: map['showPostTime'] ?? true,
        reportCount: map['reportCount'] ?? 0,
        postBlockStatus: map['postBlockStatus'] ?? "");
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PostModel(id: $id, creatorId: $creatorId, creatorDetails: $creatorDetails, createdAt: $createdAt, description: $description, locationName: $locationName, shareLink: $shareLink, mediaData: $mediaData, likesIds: $likesIds, commentIds: $commentIds, tagsIds: $tagsIds,reportCount: $reportCount,postBlockStatus: $postBlockStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostModel &&
        other.id == id &&
        other.creatorId == creatorId &&
        other.creatorDetails == creatorDetails &&
        other.createdAt == createdAt &&
        other.description == description &&
        other.locationName == locationName &&
        other.reportCount == reportCount &&
        other.shareLink == shareLink &&
        other.postBlockStatus == postBlockStatus &&
        listEquals(other.mediaData, mediaData) &&
        listEquals(other.likesIds, likesIds) &&
        listEquals(other.commentIds, commentIds) &&
        listEquals(other.tagsIds, tagsIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        creatorId.hashCode ^
        creatorDetails.hashCode ^
        createdAt.hashCode ^
        description.hashCode ^
        locationName.hashCode ^
        shareLink.hashCode ^
        mediaData.hashCode ^
        likesIds.hashCode ^
        commentIds.hashCode ^
        tagsIds.hashCode ^
        postBlockStatus.hashCode ^
        reportCount.hashCode ^
        showPostTime.hashCode;
  }
}
