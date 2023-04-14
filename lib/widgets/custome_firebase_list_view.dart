import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

class CustomeFirestoreListView<Document>
    extends FirestoreQueryBuilder<Document> {
  /// {@macro flutterfire_ui.firestorelistview}
  CustomeFirestoreListView({
    Key? key,
    required Query<Document> query,
    required FirestoreItemBuilder<Document> itemBuilder,
    int pageSize = 10,
    FirestoreLoadingBuilder? loadingBuilder,
    FirestoreErrorBuilder? errorBuilder,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    Widget? prototypeItem,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) : super(
          key: key,
          query: query,
          pageSize: pageSize,
          builder: (context, snapshot, _) {
            if (snapshot.isFetching) {
              return loadingBuilder?.call(context) ??
                  const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError && errorBuilder != null) {
              return errorBuilder(
                context,
                snapshot.error!,
                snapshot.stackTrace!,
              );
            }

            return InViewNotifierList(
              isInViewPortCondition:
                  ((deltaTop, deltaBottom, viewPortDimension) {
                return deltaTop < (0.5 * viewPortDimension) &&
                    deltaBottom > (0.5 * viewPortDimension);
              }),
              itemCount: snapshot.docs.length,
              builder: (context, index) {
                final isLastItem = index + 1 == snapshot.docs.length;
                if (isLastItem && snapshot.hasMore) snapshot.fetchMore();

                final doc = snapshot.docs[index];
                return itemBuilder(context, doc);
              },
              scrollDirection: scrollDirection,
              reverse: reverse,
              controller: controller,
              primary: primary,
              physics: physics,
              shrinkWrap: shrinkWrap,
              addAutomaticKeepAlives: addAutomaticKeepAlives,
            );
          },
        );
}
