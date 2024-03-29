import 'package:flutter/material.dart';

class AssetImageWidget extends StatelessWidget {
  final String? imageName;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? boxFit;

  const AssetImageWidget({
    super.key,
    this.imageName,
    this.width,
    this.height,
    this.color,
    this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageName!,
      width: width,
      height: height,
      color: color,
      fit: boxFit,
    );
  }
}
