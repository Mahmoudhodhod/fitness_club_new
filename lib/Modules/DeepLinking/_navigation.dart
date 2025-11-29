import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Articles/articles_module.dart' show ArticlesRepository;
import 'package:the_coach/Modules/MainExercises/power_training_module.dart' show MainExercisesRepository;
import 'package:the_coach/Modules/Muscles/muscles_module.dart' show MusclesRepository;

import 'Blocs/ProcessDeepLinkingOptions/processdeeplinkingoptions_cubit.dart';
import 'Controllers/controllers.dart';
import 'Models/models.dart';
import '_utils.dart';

void handleDeepLinking(PendingDynamicLinkData linkData) {
  final data = linkData.link.extractDeepLinkOptions();

  final context = NavigationService.context;
  if (context == null) return;

  switch (data.type) {
    case ViewType.article:
      context.read<ProcessDeepLinkingOptionsCubit>().executeProcess(
            ArticleProcess(context.read<ArticlesRepository>()),
            options: data,
          );

      break;
    case ViewType.subExercise:
      context.read<ProcessDeepLinkingOptionsCubit>().executeProcess(
            SubExerciseProcess(context.read<MusclesRepository>()),
            options: data,
          );
      break;
    case ViewType.mainExercise:
      context.read<ProcessDeepLinkingOptionsCubit>().executeProcess(
            MainExerciseProcess(context.read<MainExercisesRepository>()),
            options: data,
          );
      break;
    case ViewType.plan:
      // TODO: [Feature] Add plan sharing support.
      break;
  }
}
