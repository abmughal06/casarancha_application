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
  List? storyViews;
  MediaDetails(
      {required this.id,
      required this.name,
      required this.type,
      required this.link,
      this.imageHeight,
      this.storyViews,
      this.videoViews,
      this.imageWidth,
      this.videoAspectRatio});

  MediaDetails copyWith({
    String? id,
    String? name,
    String? type,
    String? link,
    List? storyViews,
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
      imageHeight: imageHeight ?? this.imageHeight,
      imageWidth: imageWidth ?? this.imageWidth,
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
                'videoViews': videoViews,
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
