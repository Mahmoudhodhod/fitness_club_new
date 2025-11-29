import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:the_coach/Helpers/constants.dart';

class VIPIcon extends StatelessWidget {
  final Color? color;
  final double? size;
  const VIPIcon({
    Key? key,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      vipIconSVG,
      width: size ?? 25,
      color: color ?? Colors.yellow.shade600,
    );
  }
}
