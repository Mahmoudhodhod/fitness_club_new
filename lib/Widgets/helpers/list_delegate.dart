import 'package:flutter/material.dart';

/// A delegate that supplies children for slivers using a builder callback and a separator builder.
///
class ListDelegate {
  /// The total number of children this delegate can provide.
  ///
  /// this property must not be null.
  final int itemCount;

  /// Called to build children for the [ListView].
  final IndexedWidgetBuilder builder;

  /// Called to build children separatore for the [ListView].
  final IndexedWidgetBuilder? separatorBuilder;

  ///list content padding.
  final EdgeInsetsGeometry? padding;

  /// A delegate that supplies children for slivers using a builder callback.
  ///
  const ListDelegate({
    required this.itemCount,
    required this.builder,
    this.separatorBuilder,
    this.padding,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ListDelegate &&
        other.itemCount == itemCount &&
        other.builder == builder &&
        other.separatorBuilder == separatorBuilder &&
        other.padding == padding;
  }

  @override
  int get hashCode {
    return itemCount.hashCode ^ builder.hashCode ^ separatorBuilder.hashCode ^ padding.hashCode;
  }
}
