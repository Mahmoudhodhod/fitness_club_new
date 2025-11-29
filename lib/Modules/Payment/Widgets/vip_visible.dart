import 'package:flutter/material.dart';

import 'vip_builder.dart';

class VIPVisible extends StatelessWidget {
  final Widget child;
  final Widget? replacement;

  const VIPVisible({
    Key? key,
    required this.child,
    this.replacement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VIPBuilder(
      builder: (context, isVip) {
        if (isVip) {
          return child;
        } else {
          return replacement ?? const SizedBox.shrink();
        }
      },
    );
  }
}
