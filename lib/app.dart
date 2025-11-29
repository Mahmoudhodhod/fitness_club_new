import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:utilities/utilities.dart';

import 'package:the_coach/Providers/providers.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/splash.dart';

import 'Helpers/theme_notifier.dart';
import 'MainUtilities/main_utilities.dart';

GlobalKey globalKey = GlobalKey();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.locale.isArabic) {
        MediaController.instance.localization = const ArabicPickerLocale();
      } else {
        MediaController.instance.localization = const EnglishPickerLocale();
      }
      setUpSystemChrome();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviders(
      child: Providers(
        child: Builder(
          builder: (context) {
            return Consumer<ThemeNotifier>(
              builder: (context, notifier, child) {
                final themeMode = notifier.mode;
                return MaterialApp(
                  key: globalKey,
                  navigatorKey: NavigationService.navigatorKey,
                  builder: _renderMaterialBuilder,
                  title: 'الكابتن',
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  themeMode: themeMode,
                  darkTheme: notifier.isDarkMode ? darkTheme() : null,
                  theme: !notifier.isDarkMode ? renderAppLightTheme() : null,
                  home: const SplashScreen(),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _renderMaterialBuilder(BuildContext context, Widget? child) {
    final textScaleFactor = FontScaleHandler.get(context).fontScale;
    return MediaQuery(
      child: child!,
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScaleFactor)),
    );
  }
}

/// Wrap your root App widget in this widget and call [Phoenix.rebirth] to restart your app.
class Phoenix extends StatefulWidget {
  final Widget child;

  Phoenix({Key? key, required this.child}) : super(key: key);

  @override
  _PhoenixState createState() => _PhoenixState();

  static rebirth(BuildContext context) {
    context.findAncestorStateOfType<_PhoenixState>()!.restartApp();
  }
}

class _PhoenixState extends State<Phoenix> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}

class RestartAppWidget extends StatefulWidget {
  final Widget child;
  RestartAppWidget({required this.child});
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartAppWidgetState>()?._restartApp();
  }

  @override
  _RestartAppWidgetState createState() => _RestartAppWidgetState();
}

class _RestartAppWidgetState extends State<RestartAppWidget> {
  bool restarting = false;
  void _restartApp() async {
    setState(() => restarting = true);
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      setState(() => restarting = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (restarting) return SizedBox.shrink();
    return widget.child;
  }
}
