import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../../resources/image_resources.dart';
import '../text_widget.dart';

class FullScreenImage extends StatelessWidget {
  const FullScreenImage({
    Key? key,
    required this.image,
    required this.post,
  }) : super(key: key);
  final String image;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Visibility(
            visible: post.creatorId == FirebaseAuth.instance.currentUser!.uid,
            child: InkWell(
              onTap: () {
                Get.bottomSheet(
                  Container(
                    decoration: const BoxDecoration(color: Colors.red),
                    height: 80,
                    child: InkWell(
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection("posts")
                            .doc(post.id)
                            .delete()
                            .then((value) => Get.back())
                            .whenComplete(() => Get.back());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: "Delete Post",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                  isScrollControlled: true,
                );
              },
              child: Container(
                height: 30.h,
                width: 30.h,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                child: SvgPicture.asset(icThreeDots),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: image,
          placeholder: (context, url) => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
