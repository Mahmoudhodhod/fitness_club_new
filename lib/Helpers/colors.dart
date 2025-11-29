import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_coach/Helpers/theme_notifier.dart';
import 'package:utilities/utilities.dart';

/// Acts as a color pallette
class CColors {
  CColors._();

  static Color primary(BuildContext? ctx) {
    if (ctx == null) {
      return const Color(0xffffd700);
    }
    return switchable(ctx, dark: Color(0xffffd700), light: Color(0xff0277C4));
  }

  static Color secondary(BuildContext? ctx) {
    if (ctx == null) {
      return const Color(0xffffc200);
    }
    return switchable(ctx, dark: Color(0xffffc200), light: Color(0xff005c99));
  }

  static Color get fancyBlack {
    return Color(0xff1a1a1a);
  }

  static Color get cardDarkModeColor => Color(0xff424242);
  static Color get lightBlack => Color(0xff3b3b3b);
  static Color get darkerBlack => Color(0xff3b3b3b);
  static Color get splashBackground => Color(0xff313031);
  static Color get mainRed => Colors.red.shade300;

  static T? switchableObject<T>({T? dark, T? light}) {
    if (isDarkTheme) return dark;
    return light;
  }

  static Color staticSwitchable(
    BuildContext ctx, {
    required Color dark,
    required Color light,
  }) {
    final p = ctx.read<ThemeNotifier>();
    if (p.isDarkMode) return dark;
    return light;
  }

  static Color switchable(
    BuildContext ctx, {
    required Color dark,
    required Color light,
  }) {
    if (!ctx.mounted) return light;
    final p = ctx.watch<ThemeNotifier>();
    if (p.isDarkMode) return dark;
    return light;
  }

  static Color? nullableSwitchable(BuildContext ctx,
      {Color? dark, Color? light}) {
    final p = ctx.watch<ThemeNotifier>();
    if (p.isDarkMode) return dark;
    if (isDarkTheme) return dark;
    return light;
  }

  static Color get switchableBlackAndWhite {
    final ctx = NavigationService.context!;
    return switchable(ctx, light: Colors.black, dark: Colors.white);
  }

  static Color get switchableFancyBlack {
    final ctx = NavigationService.context!;
    return switchable(ctx,
        dark: CColors.fancyBlack, light: Colors.grey.shade200);
  }

  static bool get isDarkTheme {
    final context = NavigationService.context;
    if (context == null) return false;
    final p = context.watch<ThemeNotifier>();
    return p.isDarkMode;
  }
}
