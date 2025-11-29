import 'package:authentication/authentication.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nested/nested.dart';
import 'package:the_coach/Helpers/network.dart';

import 'package:the_coach/Modules/Articles/articles_module.dart';
import 'package:the_coach/Modules/CustomPlans/custom_plans_module.dart';
import 'package:the_coach/Modules/MainExercises/power_training_module.dart';
import 'package:the_coach/Modules/Muscles/muscles_module.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:the_coach/Modules/Settings/settings.dart';

class RepositoryProviders extends StatefulWidget {
  final Widget child;
  const RepositoryProviders({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<RepositoryProviders> createState() => _RepositoryProvidersState();
}

class _RepositoryProvidersState extends State<RepositoryProviders> {
  late final Dio dio;
  late final AuthRepository authRepository;
  late final ArticlesRepository articlesRepository;
  late final MusclesRepository musclesRepository;
  late final MainExercisesRepository mainExercisesRepository;
  late final PlansRepository plansRepository;
  late final CPlansRepository customPlansRepository;
  late final CWeeksRepository customPlanWeeksRepository;
  late final CDaysRepository customPlanWeekDayExercisesRepository;
  late final SettingsRepository settingsRepository;
  late final ExerciseTypesClient exerciseTypesClient;

  @override
  void initState() {
    _initRepositories();
    super.initState();
  }

  void _initRepositories() {
    dio = Dio();
    dio.interceptors.add(languageInterceptor());
    //'Accept-Language': 'ar',
    // dio.interceptors.add(
    //   CertificatePinningInterceptor(
    //     allowedSHAFingerprints: [
    //       "EC:94:68:0E:56:C1:17:35:AC:46:55:04:96:C1:C3:62:15:C6:B4:12:56:87:BE:09:65:5C:A6:75:DA:E4:A1:CA"
    //     ],
    //   ),
    // );
    authRepository = AuthRepository(client: AuthApiClient(client: dio));
    articlesRepository = ArticlesRepository(
      client: ArticlesApiClient(client: dio),
      commentsClient: ArticlesCommentsApiClient(client: dio),
    );
    musclesRepository = MusclesRepository(client: MusclesApiClient(client: dio));
    mainExercisesRepository = MainExercisesRepository(client: PowerTaintingApiClient(client: dio));
    plansRepository = PlansRepository(client: PlansApiClient(client: dio));
    customPlansRepository = CPlansRepository(client: CPlanApiClient(dio: dio));
    customPlanWeeksRepository = CWeeksRepository(client: CPlanWeekApiClient(dio: dio));
    customPlanWeekDayExercisesRepository = CDaysRepository(client: CustomDayExerciseApiClient(dio: dio));
    exerciseTypesClient = ExerciseTypesClient(dio: dio);
    settingsRepository = SettingsRepository(dio);
  }

  @override
  Widget build(BuildContext context) {
    return _RepositoryProviders(
      providers: [
        RepositoryProvider.value(value: dio),
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: articlesRepository),
        RepositoryProvider.value(value: musclesRepository),
        RepositoryProvider.value(value: mainExercisesRepository),
        RepositoryProvider.value(value: plansRepository),
        RepositoryProvider.value(value: customPlansRepository),
        RepositoryProvider.value(value: customPlanWeeksRepository),
        RepositoryProvider.value(value: customPlanWeekDayExercisesRepository),
        RepositoryProvider.value(value: exerciseTypesClient),
        RepositoryProvider.value(value: settingsRepository),
      ],
      child: IAPRepositoryProviders(
        child: widget.child,
      ),
    );
  }
}

class _RepositoryProviders extends Nested {
  _RepositoryProviders({
    Key? key,
    required List<SingleChildWidget> providers,
    required Widget child,
    TransitionBuilder? builder,
  }) : super(
          key: key,
          children: providers,
          child: builder != null ? Builder(builder: (context) => builder(context, child)) : child,
        );
}
