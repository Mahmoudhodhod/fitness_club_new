import 'package:flutter/material.dart';

///Drops a shadow behind any `Text` for example.
///
///Recommended to use with [Stack]
///
///Example:
///```
///Positioned.fill(
///       top: null,
///       child: GradientShadower(
///             height: 120.0,
///        ),
///),
///```
///
///Use `GradientShadower.stacked()` dirctly if you want to place it at the buttom of the [Stack].
///
class GradientShadower extends StatelessWidget {
  ///Gradient height, defaults to `100.0`
  final double? height;

  ///Shadow border radius.
  final BorderRadiusGeometry? borderRadius;

  ///Drops a shadow behind any `Text`.
  const GradientShadower({
    Key? key,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  ///Returns [GradientShadower] as with a positioned widget to use with [Stack].
  ///
  ///Default heigh: `100.0`
  static Widget stacked({double? height, BorderRadiusGeometry? border}) {
    return Positioned.fill(
      top: null,
      child: GradientShadower(height: height, borderRadius: border),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 100,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          colors: [Colors.black87, Colors.transparent],
          end: Alignment.topCenter,
          begin: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
