import 'dart:math' as math;

import 'package:flutter/material.dart';

//TODO: test

/// Retuns [SliverChildDelegate] that supplies children for slivers using a builder callback.
///
///
///* [childCount] The total number of children this delegate can provide.
///this property must not be null.
///
///
/// * [itemBuilder] Called to build children for the sliver.
/// Will be called only for indices greater than or equal to zero and less
/// than [childCount].
///
///
/// * [separatorBuilder] Called to build children separatore for the sliver.
///
SliverChildDelegate separatorSliverChildDelegate({
  required IndexedWidgetBuilder itemBuilder,
  required IndexedWidgetBuilder separatorBuilder,
  required int childCount,
}) {
  // Helper method to compute the actual child count for the separated constructor.
  int _computeActualChildCount(int? itemCount) {
    if (itemCount == null) return 0;
    return math.max(0, itemCount * 2 - 1);
  }

  return SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      final int itemIndex = index ~/ 2;
      final Widget? widget;
      if (index.isEven) {
        widget = itemBuilder(context, itemIndex);
      } else {
        widget = separatorBuilder(context, itemIndex);
        assert(() {
          if (widget == null) {
            throw FlutterError('separatorBuilder cannot return null.');
          }
          return true;
        }());
      }
      return widget;
    },
    childCount: _computeActualChildCount(childCount),
    semanticIndexCallback: (Widget _, int index) {
      return index.isEven ? index ~/ 2 : null;
    },
  );
}
