import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart' hide showSearch, SearchDelegate;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/MainExercises/power_training_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'exercise_details.dart';

class FavoriteMainExercisesScreen extends StatelessWidget {
  final MainExercisesCategory category;
  const FavoriteMainExercisesScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FetchFavoriteMainExercisesCubit(
            authRepository: context.read<AuthRepository>(),
            repository: context.read<MainExercisesRepository>(),
          )..fetchExercises(),
        ),
        BlocProvider(
          create: (context) => SearchMainExercisesCubit(
            categoryID: category.id,
            authRepository: context.read<AuthRepository>(),
            repository: context.read<MainExercisesRepository>(),
          ),
        ),
      ],
      child: _MainExercisesView(),
    );
  }
}

class _MainExercisesView extends StatefulWidget {
  const _MainExercisesView({Key? key}) : super(key: key);

  @override
  _MainExercisesViewState createState() => _MainExercisesViewState();
}

class _MainExercisesViewState extends State<_MainExercisesView> {
  late final ScrollController _scrollController;
  late final SearchCubit<MainExercise> _searchCubit;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..onScroll(() {
        context.read<FetchFavoriteMainExercisesCubit>().fetchMoreExercises();
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

  void _navigateToDetails(MainExercise exercise) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => MainExerciseDetails(exercise: exercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: !Platform.isIOS,
        child: BlocBuilder<FetchFavoriteMainExercisesCubit, FetchMainExercisesState>(
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                CAppBar(
                  header: '',
                  sliverStyle: const SliverStyle(),
                  actions: [],
                ),
                if (state is FetchExercisesSucceeded) ...[
                  _buildBody(state),
                ] else if (state is FetchMainExercisesFailed) ...[
                  ErrorHappened(asSliver: true),
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
    return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
  }

  Widget _buildBody(FetchExercisesSucceeded state) {
    final exercises = state.exercises;
    if (exercises.isEmpty) return SliverFillRemaining(child: NoDataError());

    return SliverPadding(
      padding: KEdgeInsets.h15 + const EdgeInsets.only(bottom: 60),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= exercises.length) {
              return SizedBox.fromSize(
                size: Size.square(50),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final exercise = exercises[index];
            return ExerciseListTile(
              leading: ExercisePower(
                title: LocaleKeys.screens_general_exercise_r_exercise_num.tr(
                  namedArgs: {"num": exercise.parts.toString()},
                ),
                powerLevel: exercise.rating,
              ),
              onTap: () => _navigateToDetails(exercise),
              imagePath: exercise.assets.preview,
              title: exercise.name,
              isFavorite: exercise.isFavorite,
            );
          },
          childCount: state.hasNextPage ? exercises.length + 1 : exercises.length,
        ),
      ),
    );
  }
}
