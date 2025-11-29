import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:the_coach/Modules/Ads/ads_module.dart';
import 'package:the_coach/Modules/CustomPlans/custom_plans_module.dart';
import 'package:the_coach/Modules/Muscles/muscles_module.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import '../../../screens.dart';
import '../multiple_exercises.dart';
import 'add_multiexercises_to_day_exercise.dart';

class DayExercisesScreen extends StatefulWidget {
  final WeekDay day;
  const DayExercisesScreen({
    Key? key,
    required this.day,
  }) : super(key: key);

  @override
  State<DayExercisesScreen> createState() => _DayExercisesScreenState();
}

class _DayExercisesScreenState extends State<DayExercisesScreen> {
  late Completer<bool?> _deleteCustomDayExerciseDismissibleCompleter;

  @override
  void initState() {
    _deleteCustomDayExerciseDismissibleCompleter = Completer();
    context.read<WeekDayCubit>().fetchExercises(widget.day.id);
    super.initState();
  }

  void _navigateToSubExerciseDetails(BuildContext context, SubExercise subExercise) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MuscleExerciseDetails(exercise: subExercise),
      ),
    );
  }

  void _addNewMultipleExercises() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddMultipleExerciseToDayExerciseScreen(day: widget.day),
      ),
    );
  }

  void _navigateToMultipleExercisesScreen(BuildContext context, DayExercise exercise) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => MultipleExercises(dayExercise: exercise),
      ),
    );
  }

  Future<void> _deleteExercise(DayExercise exercise) async {
    return context.read<WeekDayCubit>().deleteExercise(exercise.id);
  }

  void _completeCustomDayExerciseDismissibleCompleter([bool? result]) {
    _deleteCustomDayExerciseDismissibleCompleter.complete(result);
    _deleteCustomDayExerciseDismissibleCompleter = Completer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeekDayCubit, WeekDayState>(
      listener: (context, state) async {
        if (state.isDeleted) {
          CSnackBar.success(
            messageText: LocaleKeys.success_deleted.tr(),
            avoidNavigationBar: false,
          ).showWithoutContext();
          _completeCustomDayExerciseDismissibleCompleter(true);
        } else if (state.isCreated) {
          CSnackBar.success(
            messageText: LocaleKeys.success_created.tr(),
            avoidNavigationBar: false,
          ).showWithoutContext();
        } else if (state.isGeneralFailure) {
          appLogger.e(state.companion);
          CSnackBar.failure(
            messageText: LocaleKeys.error_error_happened.tr(),
            avoidNavigationBar: false,
          ).showWithoutContext();
          _completeCustomDayExerciseDismissibleCompleter();
        } else if (state.isFailed) {
          appLogger.e(state.companion);
        }
      },
      child: BannerView(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            heroTag: 'add-multiple-exercises',
            onPressed: _addNewMultipleExercises,
            child: Icon(FontAwesomeIcons.plusSquare),
            backgroundColor: CColors.primary(context),
            foregroundColor: CColors.nullableSwitchable(context, dark: CColors.fancyBlack),
          ),
          body: SafeArea(
            top: !Platform.isIOS,
            child: CustomScrollView(
              slivers: [
                CAppBar(
                  sliverStyle: const SliverStyle(
                    pinned: true,
                    floating: false,
                    snap: false,
                  ),
                  header: widget.day.name,
                ),
                BlocBuilder<WeekDayCubit, WeekDayState>(
                  builder: (context, state) {
                    if (state.isFailed) {
                      return ErrorHappened(
                        onRetry: () => context.read<WeekDayCubit>().fetchExercises(widget.day.id),
                        asSliver: true,
                      );
                    } else if (state.isLoaded) {
                      final days = state.exercises;
                      if (days.isEmpty) return SliverFillRemaining(child: NoDataError());
                      return _buildBody(days);
                    }
                    return _loadingIndicator();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return const SliverFillRemaining(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildBody(List<DayExercise> exercises) {
    return SliverList(
      delegate: separatorSliverChildDelegate(
        childCount: exercises.length,
        separatorBuilder: (context, index) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final dayExercise = exercises[index];
          return Dismissible(
            key: ValueKey(dayExercise.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
              await _deleteExercise(dayExercise);
              return _deleteCustomDayExerciseDismissibleCompleter.future;
            },
            onDismissed: (_) => null,
            background: const DismissibleDeleteBG(),
            child: _buildDayExerciseTile(dayExercise),
          );
        },
      ),
    );
  }

  Widget _buildDayExerciseTile(DayExercise dayExercise) {
    if (dayExercise.exercises.length > 1) {
      return _buildMultipleExercisesTile(
        context,
        dayExercise: dayExercise,
      );
    }
    final exercise = dayExercise.exercises.first;
    return DayExerciseTile(
      onTap: () => _navigateToSubExerciseDetails(context, exercise),
      day: dayExercise,
    );
  }

  Widget _buildMultipleExercisesTile(
    BuildContext context, {
    required DayExercise dayExercise,
  }) {
    return MultipleExercisesTile(
      onTap: () => _navigateToMultipleExercisesScreen(context, dayExercise),
      exercise: dayExercise,
    );
  }
}
