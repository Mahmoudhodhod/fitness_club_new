import 'package:flutter/material.dart';

import 'navigation.dart';

const kCustomButtonTextStyle = TextStyle(color: Colors.black);

extension GetAppTheme on BuildContext {
  ///Retuns the current app context using [BuildContext].
  ThemeData get theme => Theme.of(this);
}

ThemeData theme(BuildContext context) {
  return Theme.of(context);
}

ThemeData get appTheme {
  final _context = NavigationService.context;
  assert(_context != null);
  return Theme.of(_context!);
}

///Returns current device screen size.
///
Size get screenSize {
  final _context = NavigationService.context;
  assert(_context != null);
  return MediaQuery.of(_context!).size;
}

///[BorderRadius] Wraper, which contains all borderRadiuses used as a const.
///
class KBorders {
  KBorders._();
  static const bc30 = BorderRadius.all(Radius.circular(30));
  static const bc20 = BorderRadius.all(Radius.circular(20));
  static const bc15 = BorderRadius.all(Radius.circular(15));
  static const bc10 = BorderRadius.all(Radius.circular(10));
  static const bc5 = BorderRadius.all(Radius.circular(5));
  static const bcb15 = BorderRadius.vertical(bottom: Radius.circular(15.0));
}

///[EdgeInsets] Wraper, which contains all EdgeInsets used as a const.
///
class KEdgeInsets {
  KEdgeInsets._();
  static const h20 = EdgeInsets.symmetric(horizontal: 20);
  static const v20 = EdgeInsets.symmetric(vertical: 20);
  static const h15 = EdgeInsets.symmetric(horizontal: 15);
  static const v15 = EdgeInsets.symmetric(vertical: 15);
  static const h10 = EdgeInsets.symmetric(horizontal: 10);
  static const v10 = EdgeInsets.symmetric(vertical: 10);
  static const h5 = EdgeInsets.symmetric(horizontal: 5);
  static const v5 = EdgeInsets.symmetric(vertical: 5);
}

///Wraps [SizedBox] and retuns a fixed amount of spacing to use in flixable widget like [Row] and [Column].
///
class Space extends SizedBox {
  const Space.h30() : super(width: 30);
  const Space.v30() : super(height: 30);
  const Space.h20() : super(width: 20);
  const Space.v20() : super(height: 20);
  const Space.h15() : super(width: 15);
  const Space.v15() : super(height: 15);
  const Space.h10() : super(width: 10);
  const Space.v10() : super(height: 10);
  const Space.h5() : super(width: 5);
  const Space.v5() : super(height: 5);

  const Space.dot()
      : super(
          width: 15,
          child: const _DotIcon(),
        );
}

class _DotIcon extends StatelessWidget {
  const _DotIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkThem = Theme.of(context).brightness == Brightness.light;
    return Icon(
      Icons.circle,
      size: 4,
      color: isDarkThem ? Colors.white60 : Colors.grey.shade500,
    );
  }
}
