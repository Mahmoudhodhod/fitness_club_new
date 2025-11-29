import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:the_coach/Modules/Ads/ads_module.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/CustomPlans/custom_plans_module.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import '../../../../Helpers/colors.dart';
import 'plan_general_info.dart';
import 'plan_weeks.dart';

class CustomPlansScreen extends StatelessWidget {
  const CustomPlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _CustomPlansView();
  }
}

class _CustomPlansView extends StatefulWidget {
  const _CustomPlansView({Key? key}) : super(key: key);

  @override
  _CustomPlansViewState createState() => _CustomPlansViewState();
}

class _CustomPlansViewState extends State<_CustomPlansView> {
  late final ScrollController _scrollController;
  late Completer<bool?> _deleteCustomPlanDismissibleCompleter;

  @override
  void initState() {
    _deleteCustomPlanDismissibleCompleter = Completer();
    _scrollController = ScrollController()
      ..onScroll(() {
        context.read<CustomPlansCubit>().fetchMorePlans();
      });

    context.read<CustomPlansCubit>().fetchPlans();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addNewPlan() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => AddCustomPlanScreen(),
      ),
    );
  }

  void _navigateToPlanWeeks(Plan plan) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => CustomPlanWeeks(plan: plan),
      ),
    );
  }

  void _completeCustomPlanDismissibleCompleter([bool? result]) {
    _deleteCustomPlanDismissibleCompleter.complete(result);
    _deleteCustomPlanDismissibleCompleter = Completer();
  }

  @override
  Widget build(BuildContext context) {
    final customPlansCubit = context.read<CustomPlansCubit>();

    return BlocListener<CustomPlansCubit, CustomPlansState>(
      listener: (context, state) {
        if (state.isDeleted) {
          CSnackBar.success(messageText: LocaleKeys.success_deleted.tr())
              .showWithoutContext();
          _completeCustomPlanDismissibleCompleter(true);
        } else if (state.isCreated) {
          CSnackBar.success(messageText: LocaleKeys.success_created.tr())
              .showWithoutContext();
        } else if (state.isGeneralFailure) {
          appLogger.e(state.companion);
          CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
              .showWithoutContext();
          _completeCustomPlanDismissibleCompleter();
        } else if (state.isFailed) {
          appLogger.e(state.companion);
        }
      },
      child: Scaffold(
        appBar: CAppBar(
          header: LocaleKeys.screens_plans_custom_plans_title.tr(),
        ),
        floatingActionButton: Align(
          alignment: context.locale.isEnglish
              ? AlignmentDirectional.bottomStart
              : AlignmentDirectional.bottomEnd,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 20, start: 32),
            child: FloatingActionButton(
              onPressed: _addNewPlan,
              child: Icon(Icons.add),
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<CustomPlansCubit, CustomPlansState>(
            builder: (context, state) {
              if (state.isFailed) {
                return ErrorHappened(
                  onRetry: () {
                    customPlansCubit.fetchPlans();
                  },
                );
              } else if (state.isLoaded) {
                final plans = state.plans;
                if (plans.isEmpty) return NoDataError();

                return ListView.separated(
                  controller: _scrollController,
                  itemCount:
                      state.hasNextPage ? plans.length + 1 : plans.length,
                  padding: const EdgeInsets.only(bottom: 70),
                  separatorBuilder: (context, index) =>
                      Divider(indent: 20, endIndent: 20, height: 0),
                  itemBuilder: (context, index) {
                    if (index >= plans.length) return const PaginationLoader();
                    final plan = plans[index];
                    return _CustomPlanListTile(
                      dismissKey: ValueKey(plan.id),
                      onTap: () => _navigateToPlanWeeks(plan),
                      confirmDismiss: (_) async {
                        await customPlansCubit.deletePlan(plan.id);
                        return _deleteCustomPlanDismissibleCompleter.future;
                      },
                      plan: plan,
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

class _CustomPlanListTile extends StatelessWidget {
  final Key dismissKey;
  final Plan plan;
  final VoidCallback? onTap;

  /// Gives the app an opportunity to confirm or veto a pending dismissal.
  ///
  /// If the returned Future<bool> completes true, then this widget will be
  /// dismissed, otherwise it will be moved back to its original location.
  ///
  /// If the returned Future<bool?> completes to false or null the [onResize]
  /// and [onDismissed] callbacks will not run.
  final ConfirmDismissCallback? confirmDismiss;

  const _CustomPlanListTile({
    Key? key,
    required this.dismissKey,
    required this.plan,
    this.onTap,
    this.confirmDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: dismissKey,
      direction: DismissDirection.endToStart,
      onDismissed: (_) => null,
      background: const DismissibleDeleteBG(),
      confirmDismiss: confirmDismiss,
      child: ListTile(
        leading: Text(
          '#${plan.id}',
          style: TextStyle(
            color: CColors.nullableSwitchable(context,
                light: CColors.darkerBlack, dark: Colors.grey.shade100),
          ),
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        title: Text(
          plan.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: CColors.nullableSwitchable(context,
                light: CColors.darkerBlack, dark: Colors.grey.shade100),
          ),
        ),
        subtitle: Text(
          plan.description,
          style: Theme.of(context).textTheme.titleSmall,
        ).subText(40),
      ),
    );
  }
}
