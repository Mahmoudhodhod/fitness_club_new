import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart' hide showSearch, SearchDelegate;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Muscles/muscles_module.dart';
import 'package:the_coach/Screens/Tabs/AllMuscles/sub_exercise_details.dart';
import 'package:the_coach/Widgets/widgets.dart';

class MuscleSubExercisesScreen extends StatelessWidget {
  final Muscle muscle;
  const MuscleSubExercisesScreen({Key? key, required this.muscle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => FetchMuscleSubExercisesCubit(
            authRepository: context.read<AuthRepository>(),
            repository: context.read<MusclesRepository>(),
          )..fetchSubExercises(muscle.id),
        ),
        BlocProvider(
          create: (_) => SearchMuscleSubExercisesCubit(
            authRepository: context.read<AuthRepository>(),
            repository: context.read<MusclesRepository>(),
            muscleId: muscle.id,
          ),
        ),
      ],
      child: _MuscleSubExercisesView(muscle: muscle),
    );
  }
}

class _MuscleSubExercisesView extends StatefulWidget {
  final Muscle muscle;
  const _MuscleSubExercisesView({
    Key? key,
    required this.muscle,
  }) : super(key: key);

  @override
  __MuscleSubExercisesViewState createState() =>
      __MuscleSubExercisesViewState();
}

class __MuscleSubExercisesViewState extends State<_MuscleSubExercisesView> {
  late final ScrollController _scrollController;
  late final SearchCubit<SubExercise> _searchCubit;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..onScroll(() {
        context.read<FetchMuscleSubExercisesCubit>().fetchMoreSubExercises();
      });

    _searchCubit = SearchCubit();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchCubit.close();
    super.dispose();
  }

  void _navigateToSubExerciseDetails(SubExercise subExercise) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => MuscleExerciseDetails(exercise: subExercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: !Platform.isIOS,
        child:
            BlocBuilder<FetchMuscleSubExercisesCubit, FetchSubExercisesState>(
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                CAppBar(
                  header: widget.muscle.name,
                  sliverStyle: const SliverStyle(),
                  // actions: [_buildSearchIconButton()],
                ),
                if (state is FetchExercisesSucceeded) ...[
                  _buildBody(state),
                ] else if (state is FetchExercisesFailure) ...[
                  ErrorHappened(
                    asSliver: true,
                    onRetry: () {
                      context
                          .read<FetchMuscleSubExercisesCubit>()
                          .fetchSubExercises(widget.muscle.id);
                    },
                  ),
                ] else ...[
                  _loadingIndicator()
                ]
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()));
  }

  Widget _buildBody(FetchExercisesSucceeded state) {
    final exercises = state.exercises;
    if (exercises.isEmpty) return SliverFillRemaining(child: NoDataError());
    return SliverPadding(
      padding: KEdgeInsets.h15 + const EdgeInsets.only(bottom: 60),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= exercises.length) return const PaginationLoader();
            final exercise = exercises[index];
            return JokerListTile(
              onTap: () => _navigateToSubExerciseDetails(exercise),
              titleText: exercise.name,
              imagePath: exercise.assets.preview,
            );
          },
          childCount:
              state.hasNextPage ? exercises.length + 1 : exercises.length,
        ),
      ),
    );
  }

  Widget _buildSearchIconButton() {
    return BlocListener<SearchMuscleSubExercisesCubit, FetchSubExercisesState>(
      listener: (context, state) {
        if (state is FetchExercisesSucceeded) {
          _searchCubit.showResults(state.exercises,
              hasNexPageUrl: state.hasNextPage);
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
              onChanged: context
                  .read<SearchMuscleSubExercisesCubit>()
                  .searchSubExercises,
              onSelected: _navigateToSubExerciseDetails,
              fetchMore: context
                  .read<SearchMuscleSubExercisesCubit>()
                  .fetchMoreSubExercises,
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
