import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';

ThemeData darkTheme() {
  final theme = ThemeData.dark();
  final context = NavigationService.context;
  return ThemeData.dark().copyWith(
    dividerColor: Colors.white38,
    textTheme: GoogleFonts.tajawalTextTheme(
      TextTheme(
        titleLarge: ThemeData.dark().textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
      ),
    ),
    cardColor: CColors.cardDarkModeColor,
    scaffoldBackgroundColor: CColors.splashBackground,
    appBarTheme: theme.appBarTheme.copyWith(
      backgroundColor: CColors.fancyBlack,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    dialogBackgroundColor: CColors.cardDarkModeColor,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          // backgroundColor: CColors.primary(context),
          // primary: CColors.primary(context),
          ),
    ),
    progressIndicatorTheme: ThemeData.dark()
        .progressIndicatorTheme
        .copyWith(color: CColors.secondary(context)),
    inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(
          focusColor: Colors.amber,
          fillColor: CColors.lightBlack,
          errorStyle: TextStyle(color: CColors.mainRed),
        ),
    textSelectionTheme: ThemeData.dark()
        .textSelectionTheme
        .copyWith(cursorColor: CColors.secondary(context)),
    dialogTheme: ThemeData.dark().dialogTheme.copyWith(
          shape: RoundedRectangleBorder(borderRadius: KBorders.bc10),
        ),
    floatingActionButtonTheme:
        ThemeData.dark().floatingActionButtonTheme.copyWith(
              foregroundColor: CColors.primary(context),
              backgroundColor: CColors.fancyBlack,
            ),
    cardTheme: CardThemeData(
      color: CColors.cardDarkModeColor,
      surfaceTintColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: CColors.primary(context),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return CColors.secondary(context);
        }
        return null;
      }),
    ),
    dividerTheme: DividerThemeData(
      thickness: 0.3,
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return CColors.secondary(context);
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return CColors.secondary(context);
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return CColors.secondary(context);
        }
        return null;
      }),
    ),
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(
          secondary: Colors.red,
        )
        .copyWith(background: CColors.lightBlack),
  );
}

ThemeData renderAppLightTheme() {
  final context = NavigationService.context;
  final dialogTheme = ThemeData.light().dialogTheme;
  final textTheme = GoogleFonts.tajawalTextTheme(
    ThemeData.light().textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
  );
  var theme = ThemeData.light();
  return theme.copyWith(
    primaryColorLight: CColors.primary(context),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      secondary: CColors.primary(context),
      primary: CColors.primary(context),
    ),
    cardTheme: CardThemeData(
      color: Colors.grey.shade200,
    ),
    dialogBackgroundColor: Colors.grey.shade200,
    primaryColor: CColors.primary(context),
    dividerColor: Colors.grey.shade400,
    brightness: Brightness.dark,
    appBarTheme: theme.appBarTheme.copyWith(
      backgroundColor: CColors.primary(context),
      titleTextStyle: theme.appBarTheme.titleTextStyle?.copyWith(
        color: Colors.white,
      ),
      toolbarTextStyle: theme.appBarTheme.titleTextStyle?.copyWith(
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: textTheme.apply(displayColor: Colors.white),
    progressIndicatorTheme: ThemeData.light().progressIndicatorTheme.copyWith(
          color: CColors.primary(context),
        ),
    inputDecorationTheme: ThemeData.light().inputDecorationTheme.copyWith(),
    textSelectionTheme: ThemeData.light().textSelectionTheme.copyWith(
          cursorColor: CColors.secondary(context),
        ),
    dividerTheme: DividerThemeData(
      thickness: 0.3,
    ),
    dialogTheme: dialogTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: TextStyle(
          color: CColors.primary(context),
          fontWeight: FontWeight.bold,
          fontSize: 18),
      contentTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
    ),
    tabBarTheme:
        ThemeData.light().tabBarTheme.copyWith(labelColor: Colors.black),
    floatingActionButtonTheme:
        ThemeData.light().floatingActionButtonTheme.copyWith(
              backgroundColor: CColors.primary(context),
              foregroundColor: Colors.white,
            ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          // backgroundColor: CColors.primary(context),
          ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: KBorders.bc10),
        backgroundColor: CColors.primary(context),
        foregroundColor: Colors.white,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: KBorders.bc10),
        backgroundColor: CColors.primary(context),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return CColors.secondary(context);
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return CColors.secondary(context);
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return CColors.secondary(context);
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return CColors.secondary(context);
        }
        return null;
      }),
    ),
  );
}
