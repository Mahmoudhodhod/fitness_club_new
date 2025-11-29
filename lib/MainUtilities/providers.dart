import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_coach/Helpers/theme_notifier.dart';

import 'package:the_coach/Modules/Articles/articles_module.dart';
import 'package:the_coach/Modules/MainExercises/power_training_module.dart';
import 'package:the_coach/Providers/providers.dart';

class Providers extends StatelessWidget {
  final Widget child;
  const Providers({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier(), lazy: false),
        ChangeNotifierProvider(create: (_) => ArticleViewActionsHandler()),
        ChangeNotifierProvider(create: (_) => MainExerciseViewActionsHandler()),
        ChangeNotifierProvider(create: (_) => FontScaleHandler()),
      ],
      child: child,
    );
  }
}
