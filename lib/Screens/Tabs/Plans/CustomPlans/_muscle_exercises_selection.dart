import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart' hide showSearch, SearchDelegate;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Muscles/muscles_module.dart';
import 'package:the_coach/Screens/Tabs/AllMuscles/sub_exercise_details.dart';
import 'package:the_coach/Widgets/widgets.dart';

class MuscleExercisesSelectionScreen extends StatelessWidget {
  final Muscle muscle;
  final int selectedExerciseId;
  final FetchMuscleSubExercisesCubit fetchMuscleSubExercisesCubit;

  const MuscleExercisesSelectionScreen({
    Key? key,
    required this.muscle,
    this.selectedExerciseId = -1,
    required this.fetchMuscleSubExercisesCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SearchMuscleSubExercisesCubit(
            authRepository: context.read<AuthRepository>(),
            repository: context.read<MusclesRepository>(),
            muscleId: selectedExerciseId,
          ),
        ),
      ],
      child: _MuscleExercisesSelectionView(
        muscle: muscle,
        fetchMuscleSubExercisesCubit: fetchMuscleSubExercisesCubit,
        selectedExerciseId: selectedExerciseId,
      ),
    );
  }
}

class _MuscleExercisesSelectionView extends StatefulWidget {
  final Muscle muscle;
  final int selectedExerciseId;
  final FetchMuscleSubExercisesCubit fetchMuscleSubExercisesCubit;

  const _MuscleExercisesSelectionView({
    Key? key,
    required this.muscle,
    required this.selectedExerciseId,
    required this.fetchMuscleSubExercisesCubit,
  }) : super(key: key);

  @override
  __MuscleExercisesSelectionViewState createState() => __MuscleExercisesSelectionViewState();
}

class __MuscleExercisesSelectionViewState extends State<_MuscleExercisesSelectionView> {
  late final ScrollController _scrollController;
  late final SearchCubit<SubExercise> _searchCubit;

  late int _selectedExerciseId;

  FetchMuscleSubExercisesCubit fetchMuscleSubExercisesCubit() => widget.fetchMuscleSubExercisesCubit;

  @override
  void initState() {
    _selectedExerciseId = widget.selectedExerciseId == -1 ? 0 : widget.selectedExerciseId;
    _scrollController = ScrollController()
      ..onScroll(() {
        fetchMuscleSubExercisesCubit().fetchMoreSubExercises();
      });

    _searchCubit = SearchCubit();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final state = fetchMuscleSubExercisesCubit().state;
      if (state is FetchExercisesSucceeded) {
        final selectedIndex = state.exercises.indexWhere((element) => element.id == _selectedExerciseId);
        if (selectedIndex == -1) return;
        _scrollController.animateTo(
          100.0 * selectedIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.decelerate,
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchCubit.close();
    super.dispose();
  }

  void _navigateToSubExerciseDetails(BuildContext context, SubExercise subExercise) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MuscleExerciseDetails(exercise: subExercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(
        header: widget.muscle.name,
        actions: [
          // _buildSearchIconButton(),
        ],
      ),
      body: SafeArea(
        top: !Platform.isIOS,
        child: BlocBuilder<FetchMuscleSubExercisesCubit, FetchSubExercisesState>(
          bloc: widget.fetchMuscleSubExercisesCubit,
          builder: (context, state) {
            if (state is FetchExercisesSucceeded) {
              return _buildBody(state);
            } else if (state is FetchExercisesFailure) {
              return ErrorHappened(
                onRetry: () {
                  fetchMuscleSubExercisesCubit().fetchSubExercises(widget.muscle.id);
                },
              );
            } else {
              return _loadingIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildBody(FetchExercisesSucceeded state) {
    final exercises = state.exercises;
    if (exercises.isEmpty) return NoDataError();

    return ListView.builder(
      controller: _scrollController,
      itemCount: state.hasNextPage ? exercises.length + 1 : exercises.length,
      padding: const EdgeInsets.only(bottom: 50) + const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (context, index) {
        if (index >= exercises.length) return const PaginationLoader();
        final exercise = exercises[index];
        final isSelected = _selectedExerciseId == exercise.id;
        return Container(
          constraints: BoxConstraints(minHeight: 80, maxHeight: 100),
          child: SelectorListTile(
            onTap: () {
              _selectedExerciseId = exercise.id;
              if (mounted) setState(() {});
              Navigator.pop(context, exercise);
            },
            decoration: BoxDecoration(
              color: isSelected ? CColors.darkerBlack : null,
              borderRadius: KBorders.bc20,
            ),
            preview: ExerciseSelectPreview(
              id: exercise.id,
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchIconButton() {
    return BlocListener<SearchMuscleSubExercisesCubit, FetchSubExercisesState>(
      listener: (context, state) {
        if (state is FetchExercisesSucceeded) {
          _searchCubit.showResults(state.exercises, hasNexPageUrl: state.hasNextPage);
        } else if (state is FetchExercisesInProgress) {
          _searchCubit.showLoadingIndicator();
        } else if (state is FetchExercisesFailure) {
          _searchCubit.showError();
        }
      },
      child: IconButton(
        onPressed: () {
          showSearch(
            context: context,
            delegate: Search<SubExercise>(
              cubit: _searchCubit,
              onChanged: context.read<SearchMuscleSubExercisesCubit>().searchSubExercises,
              onSelected: (exercise) => _navigateToSubExerciseDetails(context, exercise),
              fetchMore: context.read<SearchMuscleSubExercisesCubit>().fetchMoreSubExercises,
              itemBuilder: (context, exercise) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: KBorders.bc5,
                    child: SizedBox.fromSize(
                      size: Size.square(70),
                      child: ShimmerImage(
                        imageUrl: exercise.assets.preview,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(exercise.name),
                );
              },
            ),
          );
        },
        icon: Icon(Icons.search),
      ),
    );
  }
}
