import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart' hide showSearch, SearchDelegate;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/MainExercises/power_training_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'exercise_details.dart';
import 'favorite_exercises.dart';

class MainExercisesScreen extends StatelessWidget {
  final MainExercisesCategory category;
  const MainExercisesScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FetchMainExercisesCubit(
            authRepository: context.read<AuthRepository>(),
            repository: context.read<MainExercisesRepository>(),
          )..fetchMainExercises(category.id),
        ),
        BlocProvider(
          create: (context) => SearchMainExercisesCubit(
            authRepository: context.read<AuthRepository>(),
            repository: context.read<MainExercisesRepository>(),
            categoryID: category.id,
          ),
        ),
      ],
      child: _MainExercisesView(category: category),
    );
  }
}

class _MainExercisesView extends StatefulWidget {
  final MainExercisesCategory category;
  const _MainExercisesView({
    Key? key,
    required this.category,
  }) : super(key: key);

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
        context.read<FetchMainExercisesCubit>().fetchMoreExercises();
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

  void _navigateToFavoriteMuscleExercises() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => FavoriteMainExercisesScreen(
          category: widget.category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: !Platform.isIOS,
        child: BlocBuilder<FetchMainExercisesCubit, FetchMainExercisesState>(
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                CAppBar(
                  header: widget.category.name,
                  sliverStyle: const SliverStyle(),
                  actions: [
                    // _buildSearchButton(),
                    IconButton(
                      onPressed: _navigateToFavoriteMuscleExercises,
                      icon: Icon(FontAwesomeIcons.solidHeart, color: Colors.red),
                    )
                  ],
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
              onTap: () => _navigateToDetails(exercise),
              titlePosition: TitlePosition.bottomShadowed,
              leading: ExercisePower(
                title: LocaleKeys.screens_general_exercise_r_exercise_num.tr(
                  namedArgs: {"num": "${exercise.parts}"},
                ),
                powerLevel: exercise.rating,
              ),
              imagePath: exercise.assets.preview,
              title: exercise.name,
              isFavorite: MainExerciseViewActionsHandler.get(context).isExerciseFavorite(
                exercise.id,
                originalFavorite: exercise.isFavorite,
              ),
            );
          },
          childCount: state.hasNextPage ? exercises.length + 1 : exercises.length,
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return BlocListener<SearchMainExercisesCubit, FetchMainExercisesState>(
      listener: (context, state) {
        if (state is FetchExercisesSucceeded) {
          _searchCubit.showResults(state.exercises, hasNexPageUrl: state.hasNextPage);
        } else if (state is FetchMainExercisesInProgress) {
          _searchCubit.showLoadingIndicator();
        } else if (state is FetchMainExercisesFailed) {
          _searchCubit.showError();
        }
      },
      child: IconButton(
        onPressed: () {
          showSearch(
            context: context,
            delegate: Search<MainExercise>(
              cubit: _searchCubit,
              onChanged: (q) {
                context.read<SearchMainExercisesCubit>().searchMainExercises(q, categoryId: widget.category.id);
              },
              onSelected: (exercise) {
                _navigateToDetails(exercise);
              },
              fetchMore: () {
                context.read<SearchMainExercisesCubit>().fetchMoreExercises();
              },
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
