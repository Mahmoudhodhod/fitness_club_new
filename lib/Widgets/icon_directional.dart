import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

//TODO: document
class IconDirectional extends StatelessWidget {
  final IconData iconData;
  final double? size;
  final Color? color;
  final ui.TextDirection? textDirection;
  const IconDirectional(
    this.iconData, {
    Key? key,
    this.size,
    this.color,
    this.textDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isArabic = context.locale.isArabic;

    Map<IconData, IconData> _nonArabicMap = {
      Icons.chevron_left: Icons.chevron_right,
      Icons.chevron_right: Icons.chevron_left,
      Icons.arrow_back: Icons.arrow_forward,
      Icons.arrow_forward: Icons.arrow_back,
    };

    IconData _iconData = iconData;
    if (!_isArabic && _nonArabicMap.containsKey(iconData)) {
      _iconData = _nonArabicMap[iconData]!;
    }
    return Directionality(
      textDirection: textDirection ?? ui.TextDirection.ltr,
      child: Icon(
        _iconData,
        color: color,
        size: size,
      ),
    );
  }
}
