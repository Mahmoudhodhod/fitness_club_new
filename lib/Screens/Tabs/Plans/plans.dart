import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart' hide showSearch, SearchDelegate;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Payment/payment.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:the_coach/Modules/auth/auth_module.dart';
import 'package:the_coach/Screens/Tabs/Plans/plan_details.dart';
import 'package:the_coach/Screens/screens.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'CustomPlans/custom_plans.dart';

class PlansMainScreen extends StatelessWidget {
  const PlansMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authRepo = context.read<AuthRepository>();
    final _plansRepo = context.read<PlansRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FetchPlansCategoriesCubit(
            authRepository: _authRepo,
            repository: _plansRepo,
          )..fetchCategories(),
        ),
        BlocProvider(
          create: (context) => SearchPlansCubit(
            authRepository: _authRepo,
            repository: _plansRepo,
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => FetchPlansCubit(
          authRepository: _authRepo,
          repository: _plansRepo,
          plansCategories: context.read<FetchPlansCategoriesCubit>(),
        ),
        child: const _PlansMainView(),
      ),
    );
  }
}

class _PlansMainView extends StatefulWidget {
  const _PlansMainView({Key? key}) : super(key: key);

  @override
  _PlansMainViewState createState() => _PlansMainViewState();
}

class _PlansMainViewState extends State<_PlansMainView> {
  late final ScrollController _scrollController;
  late final SearchCubit<Plan> _searchCubit;

  int _selectedCategoryIndex = 0;
  @override
  void initState() {
    _scrollController = ScrollController()
      ..onScroll(() {
        context.read<FetchPlansCubit>().fetchMorePlans();
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

  void _navigateToCategoryPlans(Plan plan) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlanDetailsScreen(plan: plan),
      ),
    );
  }

  void _navigateToCustomPlans() {
    final currentUser = context.read<FetchDataCubit>().state.user;
    if (!currentUser.isLoggedIn) {
      showDialog(
        context: context,
        builder: (context) => LoginNeededDialog(
          onLoginPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (_) => LogInScreen()),
            );
          },
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomPlansScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CDrawer(),
      body: SafeArea(
        top: !Platform.isIOS,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            CAppBar(
              headerWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VIPBuilder(
                    builder: (context, isVip) {
                      if (isVip) return const SizedBox.shrink();
                      return InkWell(
                        onTap: () {
                          final currentUser =
                              context.read<FetchDataCubit>().state.user;
                          if (!currentUser.isLoggedIn) {
                            showDialog(
                              context: context,
                              builder: (context) => LoginPaymentNeededDialog(
                                onLoginPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    MaterialPageRoute(
                                        builder: (_) => LogInScreen()),
                                  );
                                },
                              ),
                            );
                            return;
                          }
                          VIPDialog().show(context);
                        },
                        child: Row(
                          children: [
                            const VIPIcon(),
                            Space.h5(),
                          ],
                        ),
                      );
                    },
                  ),
                  Text(LocaleKeys.general_titles_app_title.tr()),
                ],
              ),
              sliverStyle: const SliverStyle(floating: false, snap: false),
              actions: [
                // _buildSearchIconButton(),
              ],
            ),
            SliverStickyHeader(
              header: _buildHeaderBody(),
              sliver: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<FetchPlansCubit, FetchPlansState>(
      builder: (context, state) {
        if (state is FetchPlansFailed) {
          return const ErrorHappened(asSliver: true);
        } else if (state is FetchedPlansSuccessfully) {
          final plans = state.plans;
          if (plans.isEmpty)
            return const SliverFillRemaining(child: NoDataError());

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= plans.length) {
                  return SizedBox.fromSize(
                    size: const Size.square(50),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                final plan = plans[index];
                return Padding(
                  padding: KEdgeInsets.h15,
                  child: JokerListTile(
                    imagePath: plan.assets!.preview,
                    onTap: () => _navigateToCategoryPlans(plan),
                    titleText: plan.name,
                  ),
                );
              },
              childCount: state.hasNextPage ? plans.length + 1 : plans.length,
            ),
          );
        }
        return _loadingIndicator();
      },
    );
  }

  Widget _loadingIndicator() {
    return const SliverFillRemaining(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildHeaderBody() {
    return BlocBuilder<FetchPlansCategoriesCubit, FetchPlansCategoriesState>(
      builder: (context, state) {
        if (state is FetchCategoriesSucceeded) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsetsDirectional.only(start: 16),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _navigateToCustomPlans,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: CColors.switchable(
                      context,
                      dark: CColors.fancyBlack,
                      light: CColors.primary(context),
                    ),
                    visualDensity: VisualDensity.comfortable,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                  ),
                  icon: const WorkoutPlansIcon(color: Colors.white),
                  label: Text(LocaleKeys.screens_plans_my_plans).tr(),
                ),
                if (state.categories.isNotEmpty) const Space.dot(),
                Expanded(child: _buildCategoryPicker(state.categories)),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCategoryPicker(List<PlanCategory> categories) {
    if (categories.isEmpty) return const SizedBox.shrink();
    final items = categories
        .map(
          (category) => CategoryPickerItem<PlanCategory>(
            value: category,
            label: category.name,
          ),
        )
        .toList();
    return CategoryPicker<PlanCategory>(
      categoryPickerPadding: const EdgeInsetsDirectional.only(end: 16),
      initialItem: _selectedCategoryIndex,
      items: items,
      onChanged: (item, index) {
        setState(() => _selectedCategoryIndex = index);
        final categoryID = item.value.id;
        context.read<FetchPlansCubit>().fetchPlans(categoryID);
      },
      selectedItemColor: CColors.secondary(context),
      itemBorderRadius: KBorders.bc15,
      itemHeight: 32.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Widget _buildSearchIconButton() {
    return BlocListener<SearchPlansCubit, FetchPlansState>(
      listener: (context, state) {
        if (state is FetchedPlansSuccessfully) {
          _searchCubit.showResults(state.plans,
              hasNexPageUrl: state.hasNextPage);
        } else if (state is FetchPlansInProgress) {
          _searchCubit.showLoadingIndicator();
        } else if (state is FetchPlansFailed) {
          _searchCubit.showError();
        }
      },
      child: IconButton(
        onPressed: () {
          showSearch(
            context: context,
            delegate: Search<Plan>(
              cubit: _searchCubit,
              onChanged: context.read<SearchPlansCubit>().searchPlans,
              onSelected: _navigateToCategoryPlans,
              fetchMore: context.read<SearchPlansCubit>().fetchMorePlans,
              itemBuilder: (context, exercise) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: KBorders.bc5,
                    child: SizedBox.fromSize(
                      size: Size.square(70),
                      child: ShimmerImage(
                        imageUrl: exercise.assets!.preview,
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
