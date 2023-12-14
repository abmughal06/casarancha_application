import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common_widgets.dart';

class Skeleton extends StatelessWidget {
  const Skeleton(
      {super.key,
      required this.height,
      required this.width,
      this.radius,
      this.padding});

  final double height, width;
  final double? radius;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding,
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 10),
      ),
    );
  }
}

class PostSkeleton extends StatelessWidget {
  const PostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) => heightBox(10),
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 80.h),
        physics: const NeverScrollableScrollPhysics(),
        addAutomaticKeepAlives: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                children: [
                  widthBox(12),
                  shimmerImg(
                    height: 30.h,
                    width: 30.h,
                    borderRadius: 1000,
                  ),
                  widthBox(12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerImg(
                        height: 10.h,
                        width: 130.w,
                      ),
                      heightBox(5.h),
                      shimmerImg(
                        height: 10.h,
                        width: 100.w,
                      ),
                    ],
                  ),
                ],
              ),
              heightBox(15),
              shimmerImg(
                height: 400,
                width: double.infinity,
              ),
              heightBox(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      widthBox(12),
                      shimmerImg(
                        height: 20.h,
                        width: 30.h,
                      ),
                      widthBox(12),
                      shimmerImg(
                        height: 20.h,
                        width: 30.h,
                      ),
                      widthBox(12),
                      shimmerImg(
                        height: 20.h,
                        width: 30.h,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      shimmerImg(
                        height: 20.h,
                        width: 30.h,
                      ),
                      widthBox(12),
                      shimmerImg(
                        height: 20.h,
                        width: 30.h,
                      ),
                      widthBox(12),
                    ],
                  ),
                ],
              ),
            ],
          );
        });
  }
}

class StorySkeleton extends StatelessWidget {
  const StorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 15),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => shimmerImg(
          height: 55.h,
          width: 55.h,
          borderRadius: 1000,
        ),
        separatorBuilder: (context, index) => widthBox(10),
        itemCount: 10,
      ),
    );
  }
}
