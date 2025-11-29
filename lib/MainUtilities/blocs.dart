import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:the_coach/Modules/Articles/articles_module.dart';
import 'package:the_coach/Modules/Chat/chat_module.dart';
import 'package:the_coach/Modules/CustomPlans/custom_plans_module.dart';
import 'package:the_coach/Modules/DeepLinking/Blocs/blocs.dart';
import 'package:the_coach/Modules/MainExercises/power_training_module.dart';
import 'package:the_coach/Modules/Muscles/muscles_module.dart';
import 'package:the_coach/Modules/Settings/settings.dart';

class BlocProviders extends StatelessWidget {
  final Widget child;
  const BlocProviders({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  AuthRepository _authRepo = context.read();
    final  ArticlesRepository _articlesRepo = context.read();
    final  MainExercisesRepository _powerTrainingRepo = context.read();
    final  MusclesRepository _musclesRepo = context.read();
    final  CPlansRepository _cPlansRepo = context.read();
    final  CWeeksRepository _cPlanWeeksRepo = context.read();
    final  ExerciseTypesClient _exerciseTypesClient = context.read();
    final _child = IAPBlocProviders(child: child);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UpdateDataCubit(_authRepo)),
        BlocProvider(create: (_) => FetchDataCubit(_authRepo)),
        BlocProvider(create: (_) => UpdatePasswordCubit(_authRepo)),
        BlocProvider(create: (_) => FetchMusclesCubit(authRepository: _authRepo, repository: _musclesRepo)),
        BlocProvider(create: (_) => CustomPlansCubit(authRepository: _authRepo, repository: _cPlansRepo)),
        BlocProvider(create: (_) => PlanWeeksCubit(authRepository: _authRepo, repository: _cPlanWeeksRepo)),
        BlocProvider(create: (context) => LogoutCubit(_authRepo, context.read())),
        BlocProvider(
          create: (_) => WeekDayCubit(
            authRepository: _authRepo,
            repository: context.read<CDaysRepository>(),
          ),
        ),
        BlocProvider(create: (_) => ChatCubit(_authRepo)),
        BlocProvider(
          create: (_) => FetchFavoriteArticlesCubit(
            articlesRepository: _articlesRepo,
            authRepository: _authRepo,
          ),
        ),
        BlocProvider(
          create: (_) => FetchFavoriteMainExercisesCubit(
            repository: _powerTrainingRepo,
            authRepository: _authRepo,
          ),
        ),
        BlocProvider(
          create: (_) => FetchExerciseTypesCubit(
            authRepository: _authRepo,
            exerciseTypesClient: _exerciseTypesClient,
          ),
        ),
        BlocProvider(
          create: (_) => FetchAppSettingsCubit(
            settingsRepository: context.read()
          ),
        ),
        BlocProvider(
          create: (_) => ProcessDeepLinkingOptionsCubit(_authRepo),
        )
      ],
      child: _child,
    );
  }
}
