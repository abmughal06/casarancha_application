import 'dart:convert';

class MediaDetails {
  String id;
  String name;
  String type;
  String link;
  String? imageHeight;
  String? imageWidth;
  String? videoAspectRatio;
  String? videoViews;
  String? videoThumbnail;
  List? storyViews;
  String? pollQuestion;
  List<dynamic>? pollOptions;
  List<dynamic>? pollVotedUsers;
  MediaDetails(
      {required this.id,
      required this.name,
      required this.type,
      required this.link,
      this.videoThumbnail,
      this.pollVotedUsers,
      this.imageHeight,
      this.storyViews,
      this.videoViews,
      this.pollOptions,
      this.pollQuestion,
      this.imageWidth,
      this.videoAspectRatio});

  MediaDetails copyWith({
    String? id,
    String? name,
    String? type,
    String? link,
    List? storyViews,
    String? pollQuestion,
    String? videoThumbnail,
    List<dynamic>? pollOptions,
    List<dynamic>? pollVotedUsers,
    String? imageHeight,
    String? imageWidth,
    String? videoAspectRatio,
    String? videoViews,
  }) {
    return MediaDetails(
      id: id ?? this.id,
      storyViews: storyViews ?? this.storyViews,
      name: name ?? this.name,
      type: type ?? this.type,
      link: link ?? this.link,
      videoThumbnail: videoThumbnail ?? this.videoThumbnail,
      pollOptions: pollOptions ?? this.pollOptions,
      pollQuestion: pollQuestion ?? this.pollQuestion,
      imageHeight: imageHeight ?? this.imageHeight,
      imageWidth: imageWidth ?? this.imageWidth,
      pollVotedUsers: pollVotedUsers ?? this.pollVotedUsers,
      videoAspectRatio: videoAspectRatio ?? this.videoAspectRatio,
      videoViews: videoViews ?? this.videoViews,
    );
  }

  Map<String, dynamic> toMap() {
    return type.toLowerCase() == "photo"
        ? {
            'id': id,
            'name': name,
            'type': type,
            'storyViews': storyViews,
            'link': link,
            'imageHeight': imageHeight,
            'imageWidth': imageWidth,
          }
        : type.toLowerCase() == "video"
            ? {
                'id': id,
                'name': name,
                'storyViews': storyViews,
                'type': type,
                'link': link,
                'videoAspectRatio': videoAspectRatio,
                'videoThumbnail': videoThumbnail,
                'videoViews': videoViews,
              }
            : type.toLowerCase() == 'poll'
                ? {
                    'id': id,
                    'name': name,
                    'storyViews': storyViews,
                    'type': type,
                    'link': link,
                    'pollQuestion': pollQuestion,
                    'pollOptions': pollOptions,
                    'pollVotedUsers': pollVotedUsers,
                  }
                : {
                    'id': id,
                    'name': name,
                    'storyViews': storyViews,
                    'type': type,
                    'link': link,
                  };
  }

  factory MediaDetails.fromMap(Map<String, dynamic> map) {
    return MediaDetails(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      storyViews: map['storyViews'] ?? [],
      type: map['type'] ?? '',
      link: map['link'] ?? '',
      videoThumbnail: map['videoThumbnail'] ?? '',
      pollVotedUsers: map['pollVotedUsers'] ?? [],
      pollOptions: map['pollOptions'] ?? [],
      pollQuestion: map['pollQuestion'] ?? '',
      imageHeight: map['imageHeight'] ?? '',
      imageWidth: map['imageWidth'] ?? '',
      videoAspectRatio: map['videoAspectRatio'] ?? '',
      videoViews: map['videoViews'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MediaDetails.fromJson(String source) =>
      MediaDetails.fromMap(json.decode(source));

  @override
  String toString() {
    if (type.toLowerCase() == "photo") {
      return 'MediaDetails(id: $id,storyViews:$storyViews, name: $name, type: $type, link: $link, imageHeight: $imageHeight, imageWidth: $imageWidth)';
    } else if (type.toLowerCase() == "video") {
      return 'MediaDetails(id: $id,,storyViews:$storyViews,, name: $name, type: $type, link: $link, videoAspectRatio: $videoAspectRatio, videoViews: $videoViews)';
    } else {
      return 'MediaDetails(id: $id,,storyViews:$storyViews,, name: $name, type: $type, link: $link)';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (type.toLowerCase() == "photo") {
      return other is MediaDetails &&
          other.id == id &&
          other.storyViews == storyViews &&
          other.name == name &&
          other.type == type &&
          other.link == link &&
          other.imageHeight == imageHeight &&
          other.imageWidth == imageWidth;
    } else if (type.toLowerCase() == "video") {
      return other is MediaDetails &&
          other.id == id &&
          other.name == name &&
          other.storyViews == storyViews &&
          other.type == type &&
          other.link == link &&
          other.videoViews == videoViews &&
          other.videoAspectRatio == videoAspectRatio;
    } else {
      return other is MediaDetails &&
          other.id == id &&
          other.storyViews == storyViews &&
          other.name == name &&
          other.type == type &&
          other.link == link;
    }
  }

  @override
  int get hashCode {
    if (type.toLowerCase() == "photo") {
      return id.hashCode ^
          name.hashCode ^
          storyViews.hashCode ^
          type.hashCode ^
          link.hashCode ^
          imageHeight.hashCode ^
          imageWidth.hashCode;
    } else if (type.toLowerCase() == "video") {
      return id.hashCode ^
          name.hashCode ^
          type.hashCode ^
          storyViews.hashCode ^
          link.hashCode ^
          videoViews.hashCode ^
          videoAspectRatio.hashCode;
    } else {
      return id.hashCode ^
          name.hashCode ^
          type.hashCode ^
          link.hashCode ^
          storyViews.hashCode;
    }
  }
}

class PollOptions {
  final String option;
  final int votes;

  PollOptions({required this.option, required this.votes});

  factory PollOptions.fromMap(Map<String, dynamic> map) {
    return PollOptions(
      option: map['option'] ?? '',
      votes: map['votes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'option': option,
      'votes': votes,
    };
  }

  PollOptions copyWith(
    String? option,
    int? votes,
  ) {
    return PollOptions(
      option: option ?? this.option,
      votes: votes ?? this.votes,
    );
  }
}

class PollVotedUsers {
  final String id;
  final String votedOption;

  PollVotedUsers({required this.id, required this.votedOption});

  factory PollVotedUsers.fromMap(Map<String, dynamic> map) {
    return PollVotedUsers(
      id: map['id'] ?? '',
      votedOption: map['votedOption'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'votedOption': votedOption,
    };
  }

  PollVotedUsers copyWith(
    String? id,
    String? votedOption,
  ) {
    return PollVotedUsers(
      id: id ?? this.id,
      votedOption: votedOption ?? this.votedOption,
    );
  }
}
