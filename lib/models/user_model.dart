import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  String id;
  String email;
  String username;
  String ghostName;
  String dob;
  String name;
  String createdAt;
  String bio;
  String education;
  String work;
  String imageStr;
  List<String> postsIds;
  List<String> storiesIds;
  List<String> followersIds;
  List<String> followingsIds;
  List<String> savedPostsIds;
  List<String> groupIds;
  List<String> blockIds;
  bool isOnline;
  bool isdobShown;
  bool isEmailShown;
  bool isVerified;
  bool isWorkVerified;
  bool isEducationVerified;
  int? reportCount;
  String? fcmToken;
  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.ghostName,
    required this.dob,
    required this.name,
    required this.createdAt,
    required this.bio,
    required this.work,
    required this.education,
    required this.imageStr,
    this.postsIds = const [],
    this.storiesIds = const [],
    this.followersIds = const [],
    this.followingsIds = const [],
    this.savedPostsIds = const [],
    this.blockIds = const [],
    this.groupIds = const [],
    required this.isOnline,
    this.isdobShown = false,
    this.isEmailShown = false,
    this.isVerified = false,
    required this.isWorkVerified,
    required this.isEducationVerified,
    this.reportCount = 0,
    this.fcmToken,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? ghostName,
    String? dob,
    String? name,
    String? createdAt,
    String? bio,
    String? work,
    String? education,
    String? imageStr,
    List<String>? postsIds,
    List<String>? storiesIds,
    List<String>? followersIds,
    List<String>? followingsIds,
    List<String>? savedPostsIds,
    List<String>? groupIds,
    List<String>? blockIds,
    bool? isOnline,
    bool? isdobShown,
    bool? isEmailShown,
    bool? isVerified,
    bool? isWorkVerified,
    bool? isEducationVerified,
    int? reportCount,
    String? fcmToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      blockIds: blockIds ?? this.blockIds,
      email: email ?? this.email,
      username: username ?? this.username,
      ghostName: ghostName ?? this.ghostName,
      dob: dob ?? this.dob,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      bio: bio ?? this.bio,
      work: work ?? this.work,
      education: education ?? this.education,
      isWorkVerified: isWorkVerified ?? this.isWorkVerified,
      isEducationVerified: isEducationVerified ?? this.isEducationVerified,
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
      fcmToken: fcmToken ?? this.fcmToken,
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
      'ghostName': ghostName,
      'blockIds': blockIds,
      'isWorkVerified': isWorkVerified,
      'isEducationVerified': isEducationVerified,
      'dob': dob,
      'name': name,
      'createdAt': createdAt,
      'bio': bio,
      'education': education,
      'work': work,
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
      'fcmToken': fcmToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      blockIds: map['blockIds'] == null
          ? const []
          : List<String>.from(map['blockIds']),
      email: map['email'] ?? '',
      isEducationVerified: map['isEducationVerified'] ?? false,
      isWorkVerified: map['isWorkVerified'] ?? false,
      username: map['username'] ?? '',
      ghostName: map['ghostName'] ?? '',
      dob: map['dob'] ?? '',
      name: map['name'] ?? '',
      createdAt: map['createdAt'] ?? '',
      bio: map['bio'] ?? '',
      work: map['work'] ?? '',
      education: map['education'] ?? '',
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
      reportCount: map['reportCount'] ?? 0,
      fcmToken: map['fcmToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id,blockIds: $blockIds, email: $email, isWorkVerified:$isWorkVerified,isEducationVerified:$isEducationVerified,username: $username, ghosName : $ghostName,dob: $dob, name: $name, createdAt: $createdAt, bio: $bio, education: $education, work: $work, imageStr: $imageStr, postsIds: $postsIds, storiesIds: $storiesIds, followersIds: $followersIds, followingsIds: $followingsIds, savedPostsIds: $savedPostsIds, groupIds: $groupIds, isOnline: $isOnline, isdobShown: $isdobShown, isEmailShown: $isEmailShown, isVerified: $isVerified,reportCount: $reportCount,fcmToken: $fcmToken )';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.isEducationVerified == isEducationVerified &&
        other.isWorkVerified == isWorkVerified &&
        other.email == email &&
        other.ghostName == ghostName &&
        other.username == username &&
        other.dob == dob &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.bio == bio &&
        other.work == work &&
        other.education == education &&
        other.imageStr == imageStr &&
        listEquals(other.blockIds, blockIds) &&
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
        other.reportCount == reportCount &&
        other.fcmToken == fcmToken;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        username.hashCode ^
        isWorkVerified.hashCode ^
        isEducationVerified.hashCode ^
        ghostName.hashCode ^
        dob.hashCode ^
        name.hashCode ^
        createdAt.hashCode ^
        bio.hashCode ^
        work.hashCode ^
        education.hashCode ^
        imageStr.hashCode ^
        postsIds.hashCode ^
        blockIds.hashCode ^
        storiesIds.hashCode ^
        followersIds.hashCode ^
        followingsIds.hashCode ^
        savedPostsIds.hashCode ^
        groupIds.hashCode ^
        isOnline.hashCode ^
        isdobShown.hashCode ^
        isEmailShown.hashCode ^
        reportCount.hashCode ^
        fcmToken.hashCode ^
        isVerified.hashCode;
  }
}
