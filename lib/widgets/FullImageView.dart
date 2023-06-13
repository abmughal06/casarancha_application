import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullImageView extends StatelessWidget {
  const FullImageView({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [],
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: url,
        ),
      ),
    );
  }
}
