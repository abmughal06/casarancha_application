import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common_widgets.dart';

class Skeleton extends StatelessWidget {
  const Skeleton(
      {Key? key,
      required this.height,
      required this.width,
      this.radius,
      this.padding})
      : super(key: key);

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
  const PostSkeleton({Key? key}) : super(key: key);

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
                  widthBox(7),
                  Skeleton(
                      height: 30.h,
                      width: 30.h,
                      radius: 1000,
                      padding: const EdgeInsets.all(8)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton(
                        height: 10.h,
                        width: 130.w,
                      ),
                      heightBox(5.h),
                      Skeleton(
                        height: 10.h,
                        width: 100.w,
                      ),
                    ],
                  ),
                ],
              ),
              const Skeleton(
                height: 400,
                width: double.infinity,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Skeleton(
                          height: 20.h,
                          width: 30.h,
                          padding: const EdgeInsets.all(8)),
                      Skeleton(
                          height: 20.h,
                          width: 30.h,
                          padding: const EdgeInsets.all(8)),
                      Skeleton(
                          height: 20.h,
                          width: 30.h,
                          padding: const EdgeInsets.all(8)),
                    ],
                  ),
                  Row(
                    children: [
                      Skeleton(
                          height: 20.h,
                          width: 30.h,
                          padding: const EdgeInsets.all(8)),
                      Skeleton(
                          height: 20.h,
                          width: 30.h,
                          padding: const EdgeInsets.all(8)),
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
  const StorySkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 15),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Skeleton(
          height: 55.h,
          width: 55.h,
          radius: 1000,
        ),
        separatorBuilder: (context, index) => widthBox(10),
        itemCount: 10,
      ),
    );
  }
}
