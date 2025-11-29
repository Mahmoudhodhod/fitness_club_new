import 'package:authentication/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:the_coach/Modules/CustomPlans/custom_plans_module.dart';
import 'package:the_coach/Modules/Muscles/muscles_module.dart'
    show FetchMuscleSubExercisesCubit, Muscle, MusclesRepository, SubExercise;
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:the_coach/Screens/Tabs/AllMuscles/sub_exercise_details.dart';
import 'package:the_coach/Screens/Tabs/Plans/CustomPlans/_muscle_exercises_selection.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class AddMultipleExerciseToDayExerciseScreen extends StatelessWidget {
  final WeekDay day;
  const AddMultipleExerciseToDayExerciseScreen({
    Key? key,
    required this.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FetchAllMusclesCubit(
            authRepository: context.read<AuthRepository>(),
            repository: context.read<MusclesRepository>(),
          )..fetchMuscles(),
        ),
        BlocProvider(
          create: (context) => FetchExerciseTypesCubit(
            authRepository: context.read<AuthRepository>(),
            exerciseTypesClient: context.read<ExerciseTypesClient>(),
          )..fetchExerciseTypes(),
        ),
        BlocProvider(
          create: (context) => FetchMuscleSubExercisesCubit(
            authRepository: context.read<AuthRepository>(),
            repository: context.read<MusclesRepository>(),
          ),
        ),
      ],
      child: _AddPlanExerciseView(day: day),
    );
  }
}

class _AddPlanExerciseView extends StatefulWidget {
  final WeekDay day;
  const _AddPlanExerciseView({
    Key? key,
    required this.day,
  }) : super(key: key);

  @override
  _AddPlanExerciseViewState createState() => _AddPlanExerciseViewState();
}

class _AddPlanExerciseViewState extends State<_AddPlanExerciseView> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _setsEditingController;
  late final TextEditingController _repsEditingController;
  late final TextEditingController _restDurationEditingController;
  late final TextEditingController _planEditingController;
  late Key _exercisesSelectorKey;

  Map<int, SelectedExercise> _selectedExercises = {};

  ExerciseType? _selectedExerciseType;

  @override
  void initState() {
    _formKey = GlobalKey();
    _setsEditingController = TextEditingController();
    _repsEditingController = TextEditingController();
    _restDurationEditingController = TextEditingController();
    _planEditingController = TextEditingController();
    _exercisesSelectorKey = UniqueKey();
    super.initState();
  }

  @override
  void dispose() {
    _setsEditingController.dispose();
    _repsEditingController.dispose();
    _restDurationEditingController.dispose();
    _planEditingController.dispose();
    super.dispose();
  }

  void _addNewExercise() {
    if (!_formKey.currentState!.validate() && _selectedExerciseType != null) {
      CSnackBar.failure(messageText: LocaleKeys.error_enter_valid.tr())
          .showWithoutContext();
      return;
    }
    final exercisesIds = _validateAndReturnSelectedExercises();
    if (exercisesIds == null) {
      CSnackBar.failure(
        messageText:
            LocaleKeys.screens_plans_custom_plans_enter_valid_exercises.tr(),
      ).showWithoutContext();
      return;
    }

    final sets = int.parse(_setsEditingController.text.trim());
    final reps = _repsEditingController.text.trim();
    final restDuration =
        int.tryParse(_restDurationEditingController.text.trim());
    final _plan = _planEditingController.text.trim();
    final plan = _plan.isEmpty ? null : _plan;

    final newExercise = NewDayExercise(
      exerciseTypeId: _selectedExerciseType!.id,
      subexercisesIds: exercisesIds,
      sets: sets,
      reps: reps,
      restDuration: restDuration,
      plan: plan,
    );
    context.read<WeekDayCubit>().createExercise(newExercise);
  }

  List<int>? _validateAndReturnSelectedExercises() {
    if (_selectedExerciseType == null) return null;
    if (_selectedExercises.length < _selectedExerciseType!.maxExercisesCount)
      return null;
    for (final entry in _selectedExercises.entries) {
      if (entry.value.isNotValid) return null;
    }
    return _selectedExercises.values.map((e) => e.exercise!.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<WeekDayCubit, WeekDayState>(
          listener: (context, state) {
            if (state.isCreated) {
              return Navigator.pop(context);
            }
          },
        ),
        BlocListener<FetchAllMusclesCubit, FetchAllMusclesState>(
          listener: (context, state) async {
            if (state is FetchAllMusclesInProgress) {
              await LoadingDialog.view(context);
            } else if (state is FetchAllMusclesSucceeded) {
              //  Do nothing //
            } else if (state is FetchAllMusclesFailed) {
              appLogger.e(state);
              CSnackBar.failure(
                messageText: LocaleKeys.error_error_happened.tr(),
                avoidNavigationBar: false,
              ).showWithoutContext();
            }
            LoadingDialog.pop(context);
          },
        ),
      ],
      child: KeyboardDismissed(
        child: Scaffold(
          appBar: CAppBar(
            header: LocaleKeys.screens_plans_custom_plans_add_work_out.tr(),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: KEdgeInsets.h10 +
                    EdgeInsets.only(bottom: screenSize.height * 0.1, top: 20),
                children: [
                  Card(
                    color: CColors.switchable(
                      context,
                      dark: CColors.cardDarkModeColor,
                      light: Colors.grey.shade200,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: KBorders.bc5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              LocaleKeys.screens_plans_custom_plans_details
                                  .tr(),
                              style: theme(context).textTheme.titleMedium,
                            ),
                          ),
                          const Space.v20(),
                          BlocBuilder<FetchExerciseTypesCubit,
                              FetchExerciseTypesState>(
                            builder: (context, state) {
                              if (state is FetchExerciseTypesSucceeded) {
                                return TitleListTile(
                                  onTap: () => _pickExerciseType(state.types),
                                  leading: Text(LocaleKeys
                                      .screens_plans_custom_plans_exercise_type
                                      .tr()),
                                  title: _selectedExerciseType?.title ??
                                      LocaleKeys
                                          .screens_plans_custom_plans_select_exercise_type
                                          .tr(),
                                  trailing: Icon(Icons.arrow_drop_down),
                                  style: TextStyle(
                                    color: CColors.primary(context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_selectedExerciseType != null) ...[
                    _buildMultiexerciseSelector(),
                  ],
                  const Space.v10(),
                  _buildStepsAndRept(),
                  const Space.v10(),
                  _restAndPlan(),
                  const Space.v20(),
                  _buildAddButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiexerciseSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ExpansionTile(
        key: _exercisesSelectorKey,
        initiallyExpanded: true,
        collapsedBackgroundColor: Colors.black12,
        collapsedIconColor: CColors.primary(context),
        textColor: CColors.primary(context),
        collapsedTextColor: CColors.primary(context),
        iconColor: Colors.white,
        maintainState: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LocaleKeys.screens_plans_custom_plans_exercises_description
                .tr()),
            Text(
              LocaleKeys.screens_plans_custom_plans_for_more_details.tr(),
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        childrenPadding: const EdgeInsets.all(10.0),
        title: Text(
          LocaleKeys.screens_general_exercises.tr(),
          style: theme(context).textTheme.titleMedium,
        ),
        children: List.generate(
          _selectedExerciseType!.maxExercisesCount,
          (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.screens_general_exercise_r_exercise_with_num.tr(
                      namedArgs: {
                        'num': (index + 1).toString(),
                      },
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Space.v10(),
                  Card(
                    color: CColors.switchable(
                      context,
                      dark: CColors.cardDarkModeColor,
                      light: Colors.grey.shade200,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: KBorders.bc5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: BlocBuilder<FetchAllMusclesCubit,
                          FetchAllMusclesState>(
                        builder: (context, state) {
                          List<Muscle> muscles = [];
                          if (state is FetchAllMusclesSucceeded) {
                            muscles = state.muscles..reversed;
                          }
                          return _MuscleExerciseSelector(
                            dataSource: _MuscleExerciseSelectorDataSource(
                                muscles: muscles),
                            onSelected: (selectedExercise) {
                              _selectedExercises[index] = selectedExercise;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickExerciseType(List<ExerciseType> exercises) async {
    final _initialIndex =
        exercises.indexWhere((e) => e.id == _selectedExerciseType?.id);
    return WheelPicker(
      initialIndex: _initialIndex,
      delegate: ListDelegate(
        itemCount: exercises.length,
        builder: (context, index) {
          final exercise = exercises[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                exercise.title,
                textAlign: TextAlign.center,
                style: theme(context).textTheme.bodyLarge,
              ),
            ),
          );
        },
      ),
      timeDebouncer: TimeDebouncer<int>(
        onChanged: (index) async {
          await _resetExpansionTileExercises();
          final selectedExercise = exercises[index];
          _selectedExerciseType = selectedExercise;
          if (mounted) setState(() {});
        },
        duration: const Duration(milliseconds: 300),
      ),
    ).show(context);
  }

  Future<void> _resetExpansionTileExercises() async {
    _selectedExerciseType = null;
    _exercisesSelectorKey = UniqueKey();
    if (mounted) setState(() {});
  }

  Widget _buildAddButton() {
    return Center(
      child: BlocBuilder<WeekDayCubit, WeekDayState>(
        builder: (context, state) {
          return CustomButton(
            visualDensity: VisualDensity.comfortable,
            isLoading: state.isGeneralLoading,
            onPressed: _addNewExercise,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(LocaleKeys.general_titles_add.tr()),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepsAndRept() {
    return Card(
      color: CColors.switchable(
        context,
        dark: CColors.cardDarkModeColor,
        light: Colors.grey.shade200,
      ),
      shape: const RoundedRectangleBorder(borderRadius: KBorders.bc5),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                LocaleKeys.screens_general_exercise_r_steps_and_reps.tr(),
                style: theme(context).textTheme.titleMedium,
              ),
            ),
            const Space.v20(),
            Row(
              children: [
                Expanded(
                  child: CTextField(
                    controller: _setsEditingController,
                    maxLength: 2,
                    isRequired: true,
                    title: LocaleKeys.screens_general_exercise_r_sets.tr(),
                    validator: _emptyValidator,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    errorTextStyle: _errorTextStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(CupertinoIcons.multiply,
                      color: CColors.secondary(context)),
                ),
                Expanded(
                  child: CTextField(
                    controller: _repsEditingController,
                    isRequired: true,
                    title: LocaleKeys.screens_general_exercise_r_repeats.tr(),
                    validator: _emptyValidator,
                    textInputAction: TextInputAction.next,
                    errorTextStyle: _errorTextStyle(),
                    inputFormatters: [
                      //Only allow [digits] and [-]
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]|-')),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    LocaleKeys.screens_plans_custom_plans_reps_description.tr(),
                    style: theme(context).textTheme.bodySmall,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _restAndPlan() {
    return Card(
      color: CColors.switchable(
        context,
        dark: CColors.cardDarkModeColor,
        light: Colors.grey.shade200,
      ),
      shape: RoundedRectangleBorder(borderRadius: KBorders.bc5),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            CTextField(
              controller: _restDurationEditingController,
              maxLength: 3,
              title: LocaleKeys.screens_general_exercise_r_rest.tr(),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
            ),
            CTextField(
              controller: _planEditingController,
              title: LocaleKeys.screens_general_exercise_r_exer_plan.tr(),
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }

  String? _emptyValidator(String? value) {
    if (value!.isEmpty) return '';
    return null;
  }

  TextStyle _errorTextStyle() {
    return const TextStyle(fontSize: 0);
  }
}

class SelectedExercise {
  Muscle? muscle;
  SubExercise? exercise;

  SelectedExercise({
    this.muscle,
    this.exercise,
  });

  bool get isNotValid => !isValid;

  bool get isValid => muscle != null && exercise != null;

  @override
  String toString() =>
      'SelectedExercise(muscleId: ${muscle?.id}, exercise: ${exercise?.id})';
}

class _MuscleExerciseSelectorDataSource {
  final List<Muscle> muscles;

  const _MuscleExerciseSelectorDataSource({
    required this.muscles,
  });
}

class _MuscleExerciseSelector extends StatefulWidget {
  final _MuscleExerciseSelectorDataSource dataSource;
  final ValueChanged<SelectedExercise> onSelected;

  const _MuscleExerciseSelector({
    Key? key,
    required this.dataSource,
    required this.onSelected,
  }) : super(key: key);

  @override
  _MuscleExerciseSelectorState createState() => _MuscleExerciseSelectorState();
}

class _MuscleExerciseSelectorState extends State<_MuscleExerciseSelector> {
  Muscle? _muscle;
  SubExercise? _exercise;
  SelectedExercise _selectedExercise = SelectedExercise();

  void _updateSelectedExercise({Muscle? muscle, SubExercise? exercise}) {
    if (muscle != null) _selectedExercise.muscle = muscle;
    if (exercise != null) _selectedExercise.exercise = exercise;
    widget.onSelected(_selectedExercise);
  }

  void _navigateToMuscleExercises(
    BuildContext context, {
    required Muscle muscle,
  }) async {
    final fetchExercisesCubit = context.read<FetchMuscleSubExercisesCubit>();
    final exercise = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MuscleExercisesSelectionScreen(
          muscle: muscle,
          fetchMuscleSubExercisesCubit: fetchExercisesCubit,
          selectedExerciseId: _muscle?.id ?? -1,
        ),
      ),
    );
    if (exercise == null) return;
    _exercise = exercise;
    _updateSelectedExercise(exercise: exercise);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            TitleListTile(
              onTap: () => _pickMuscle(context),
              leading: _muscle?.assets != null
                  ? SizedBox.fromSize(
                      size: const Size.square(50),
                      child: NetworkImageView(
                        borderRadius: KBorders.bc10,
                        url: _muscle!.assets.preview,
                        fit: BoxFit.cover,
                      ),
                    )
                  : null,
              title: _muscle?.name ??
                  LocaleKeys.screens_plans_custom_plans_select_muscle.tr(),
              trailing: Icon(Icons.arrow_drop_down),
            ),
            TitleListTile(
              onTap: () {
                if (_muscle == null) {
                  CSnackBar.custom(
                    icon:
                        Text('💪', style: theme(context).textTheme.titleLarge),
                    messageText: LocaleKeys
                        .screens_plans_custom_plans_select_muscle
                        .tr(),
                  ).show(context);
                  return;
                }
                _navigateToMuscleExercises(context, muscle: _muscle!);
              },
              leading: _exercise?.assets != null
                  ? _buildExerciseImageHeaderPlaceHolder()
                  : null,
              title: _exercise?.name ??
                  LocaleKeys.screens_plans_custom_plans_select_exercise.tr(),
              trailing: Icon(Icons.arrow_drop_down),
            ),
          ],
        );
      },
    );
  }

  void _pickMuscle(BuildContext context) async {
    final muscles = widget.dataSource.muscles;
    return await showDialog(
      context: context,
      builder: (_) => SelectDialog<MuscleSelectPreview>(
        title: LocaleKeys.screens_plans_custom_plans_select_muscle.tr(),
        data: List.generate(muscles.length, (index) {
          final muscle = muscles[index];
          return MuscleSelectPreview(
            id: index,
            title: muscle.name,
            imagePath: muscle.assets.preview,
          );
        }),
        onSelect: (value) {
          final muscle = muscles[value.id];
          context
              .read<FetchMuscleSubExercisesCubit>()
              .fetchSubExercises(muscle.id);
          _changeSelectedMuscleName(muscle);
        },
      ),
    );
  }

  void _changeSelectedMuscleName(Muscle muscle) {
    if (mounted) setState(() => _muscle = muscle);
    _updateSelectedExercise(muscle: muscle);
  }

  void _pickSubExercise(List<SubExercise> exercises) async {
    if (_muscle == null) {
      return CSnackBar.custom(
        icon: Text('💪', style: theme(context).textTheme.titleLarge),
        messageText: LocaleKeys.screens_plans_custom_plans_select_muscle.tr(),
      ).show(context);
    }

    return await showDialog(
      context: context,
      builder: (_) => SelectDialog<ExerciseSelectPreview>(
        title: LocaleKeys.screens_plans_custom_plans_select_exercise.tr(),
        data: List.generate(exercises.length, (index) {
          final exercise = exercises[index];
          return ExerciseSelectPreview(
            id: index,
            title: exercise.name,
            imagePath: exercise.assets.preview,
            onImageTapped: () {
              SlideShow(
                images: [NetworkImage(exercise.assets.url)],
              ).show(context);
            },
            trailing: IconButton(
              onPressed: () => _navigateToSubExerciseDetails(context, exercise),
              color: CColors.primary(context),
              iconSize: 17,
              icon: Icon(Icons.open_in_new),
            ),
          );
        }),
        onSelect: (value) {
          final exercise = exercises[value.id];
          _changeSelectedSubExerciseName(exercise);
        },
      ),
    );
  }

  void _navigateToSubExerciseDetails(
      BuildContext context, SubExercise subExercise) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MuscleExerciseDetails(exercise: subExercise),
      ),
    );
  }

  void _changeSelectedSubExerciseName(SubExercise exercise) {
    if (mounted) setState(() => _exercise = exercise);
    _updateSelectedExercise(exercise: _exercise);
  }

  Widget _buildExerciseImageHeaderPlaceHolder() {
    return SizedBox.fromSize(
      size: const Size.square(50),
      child: NetworkImageView(
        borderRadius: KBorders.bc10,
        url: _exercise!.assets.preview,
        fit: BoxFit.cover,
      ),
    );
  }
}
