import 'dart:convert';

class CreatorDetails {
  String name;
  String imageUrl;
  bool isVerified;
  CreatorDetails({
    required this.name,
    required this.imageUrl,
    required this.isVerified,
  });

  CreatorDetails copyWith({
    String? name,
    String? imageUrl,
    bool? isVerified,
  }) {
    return CreatorDetails(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'isVerified': isVerified,
    };
  }

  factory CreatorDetails.fromMap(Map<String, dynamic> map) {
    return CreatorDetails(
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      isVerified: map['isVerified'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatorDetails.fromJson(String source) =>
      CreatorDetails.fromMap(json.decode(source));

  @override
  String toString() =>
      'CreatorDetails(name: $name, imageUrl: $imageUrl, isVerified: $isVerified)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreatorDetails &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        other.isVerified == isVerified;
  }

  @override
  int get hashCode => name.hashCode ^ imageUrl.hashCode ^ isVerified.hashCode;
}
