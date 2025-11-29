import 'package:easy_logger/easy_logger.dart';
import 'package:flutter/material.dart';

import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/codegen_loader.g.dart';

class SetUpEasyLocalization extends StatefulWidget {
  final Widget child;
  const SetUpEasyLocalization({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<SetUpEasyLocalization> createState() => _SetUpEasyLocalizationState();
}

class _SetUpEasyLocalizationState extends State<SetUpEasyLocalization> {
  @override
  void initState() {
    _initializeLogger();

    super.initState();
  }

  void _initializeLogger() {
    EasyLocalization.logger.enableLevels = <LevelMessages>[
      LevelMessages.error,
      LevelMessages.warning,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: [
        const Locale('ar'),
        const Locale('en'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      assetLoader: CodegenLoader(),
      child: widget.child,
    );
  }
}
