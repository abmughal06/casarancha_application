import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  String id;
  String email;
  String username;
  String dob;
  String name;
  String createdAt;
  String bio;
  String imageStr;
  List<String> postsIds;
  List<String> storiesIds;
  List<String> followersIds;
  List<String> followingsIds;
  List<String> savedPostsIds;
  List<String> groupIds;
  bool isOnline;
  bool isdobShown;
  bool isEmailShown;
  bool isVerified;
  int? reportCount;
  UserModel(
      {required this.id,
      required this.email,
      required this.username,
      required this.dob,
      required this.name,
      required this.createdAt,
      required this.bio,
      required this.imageStr,
      this.postsIds = const [],
      this.storiesIds = const [],
      this.followersIds = const [],
      this.followingsIds = const [],
      this.savedPostsIds = const [],
      this.groupIds = const [],
      required this.isOnline,
      this.isdobShown = false,
      this.isEmailShown = false,
      this.isVerified = false,
      this.reportCount = 0});

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? dob,
    String? name,
    String? createdAt,
    String? bio,
    String? imageStr,
    List<String>? postsIds,
    List<String>? storiesIds,
    List<String>? followersIds,
    List<String>? followingsIds,
    List<String>? savedPostsIds,
    List<String>? groupIds,
    bool? isOnline,
    bool? isdobShown,
    bool? isEmailShown,
    bool? isVerified,
    int? reportCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      dob: dob ?? this.dob,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      bio: bio ?? this.bio,
      imageStr: imageStr ?? this.imageStr,
      postsIds: postsIds ?? this.postsIds,
      storiesIds: storiesIds ?? this.storiesIds,
      followersIds: followersIds ?? this.followersIds,
      followingsIds: followingsIds ?? this.followingsIds,
      savedPostsIds: savedPostsIds ?? this.savedPostsIds,
      groupIds: groupIds ?? this.groupIds,
      isOnline: isOnline ?? this.isOnline,
      isdobShown: isdobShown ?? this.isdobShown,
      isEmailShown: isEmailShown ?? this.isEmailShown,
      isVerified: isVerified ?? this.isVerified,
      reportCount: reportCount ?? this.reportCount,
    );
  }

  updatePostsIds(List<String> list) {
    postsIds = list;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'dob': dob,
      'name': name,
      'createdAt': createdAt,
      'bio': bio,
      'imageStr': imageStr,
      'postsIds': postsIds,
      'storiesIds': storiesIds,
      'followersIds': followersIds,
      'followingsIds': followingsIds,
      'savedPostsIds': savedPostsIds,
      'groupIds': groupIds,
      'isOnline': isOnline,
      'isdobShown': isdobShown,
      'isEmailShown': isEmailShown,
      'isVerified': isVerified,
      'reportCount': reportCount,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'] ?? '',
        email: map['email'] ?? '',
        username: map['username'] ?? '',
        dob: map['dob'] ?? '',
        name: map['name'] ?? '',
        createdAt: map['createdAt'] ?? '',
        bio: map['bio'] ?? '',
        imageStr: map['imageStr'] ?? '',
        postsIds: List<String>.from(map['postsIds']),
        storiesIds: List<String>.from(map['storiesIds']),
        followersIds: List<String>.from(map['followersIds']),
        followingsIds: List<String>.from(map['followingsIds']),
        savedPostsIds: List<String>.from(map['savedPostsIds']),
        groupIds: List<String>.from(map['groupIds']),
        isOnline: map['isOnline'] ?? false,
        isdobShown: map['isdobShown'] ?? false,
        isEmailShown: map['isEmailShown'] ?? false,
        isVerified: map['isVerified'] ?? false,
        reportCount: map['reportCount'] ?? 0);
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, username: $username, dob: $dob, name: $name, createdAt: $createdAt, bio: $bio, imageStr: $imageStr, postsIds: $postsIds, storiesIds: $storiesIds, followersIds: $followersIds, followingsIds: $followingsIds, savedPostsIds: $savedPostsIds, groupIds: $groupIds, isOnline: $isOnline, isdobShown: $isdobShown, isEmailShown: $isEmailShown, isVerified: $isVerified,reportCount: $reportCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.username == username &&
        other.dob == dob &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.bio == bio &&
        other.imageStr == imageStr &&
        listEquals(other.postsIds, postsIds) &&
        listEquals(other.storiesIds, storiesIds) &&
        listEquals(other.followersIds, followersIds) &&
        listEquals(other.followingsIds, followingsIds) &&
        listEquals(other.savedPostsIds, savedPostsIds) &&
        listEquals(other.groupIds, groupIds) &&
        other.isOnline == isOnline &&
        other.isdobShown == isdobShown &&
        other.isEmailShown == isEmailShown &&
        other.isVerified == isVerified &&
        other.reportCount == reportCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        username.hashCode ^
        dob.hashCode ^
        name.hashCode ^
        createdAt.hashCode ^
        bio.hashCode ^
        imageStr.hashCode ^
        postsIds.hashCode ^
        storiesIds.hashCode ^
        followersIds.hashCode ^
        followingsIds.hashCode ^
        savedPostsIds.hashCode ^
        groupIds.hashCode ^
        isOnline.hashCode ^
        isdobShown.hashCode ^
        isEmailShown.hashCode ^
        reportCount.hashCode ^
        isVerified.hashCode;
  }
}
