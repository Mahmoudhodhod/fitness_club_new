import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart' hide showSearch, SearchDelegate;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/MainExercises/power_training_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'main_exercises.dart';

class MainExercisesCategoriesScreen extends StatelessWidget {
  const MainExercisesCategoriesScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FetchMainExerciseCategories(
            authRepository: context.read<AuthRepository>(),
            repository: context.read<MainExercisesRepository>(),
          )..fetchCategories(),
        ),
      ],
      child: MainExercisesCategoriesView(),
    );
  }
}

class MainExercisesCategoriesView extends StatefulWidget {
  const MainExercisesCategoriesView({Key? key}) : super(key: key);

  @override
  _MainExercisesCategoriesViewState createState() =>
      _MainExercisesCategoriesViewState();
}

class _MainExercisesCategoriesViewState
    extends State<MainExercisesCategoriesView> {
  void _navigateToCategoryExercises(MainExercisesCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MainExercisesScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CDrawer(),
      body: SafeArea(
        top: !Platform.isIOS,
        child: BlocBuilder<FetchMainExerciseCategories,
            FetchMainExerciseCategoriesState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                CAppBar(
                  header: LocaleKeys.general_titles_app_title.tr(),
                  sliverStyle: const SliverStyle(),
                ),
                if (state is FetchMainExerciseCategoriesSucceeded) ...[
                  _buildBody(state),
                ] else if (state is FetchMainExerciseCategoriesFailed) ...[
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
    return SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()));
  }

  Widget _buildBody(FetchMainExerciseCategoriesSucceeded state) {
    final categories = state.categories;
    if (categories.isEmpty) return SliverFillRemaining(child: NoDataError());

    return SliverPadding(
      padding: KEdgeInsets.h15 + const EdgeInsets.only(bottom: 60),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final category = categories[index];
            return JokerListTile(
              onTap: () => _navigateToCategoryExercises(category),
              imagePath: category.assets.preview,
              titlePosition: TitlePosition.bottomShadowed,
              title: Text(
                category.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: CColors.nullableSwitchable(context,
                          light: Colors.white),
                    ),
              ),
            );
          },
          childCount: categories.length,
        ),
      ),
    );
  }
}
