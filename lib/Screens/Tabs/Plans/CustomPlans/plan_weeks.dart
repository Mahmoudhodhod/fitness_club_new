import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/logger.dart';
import 'package:the_coach/Modules/CustomPlans/custom_plans_module.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import '../week_days_previewer.dart';

class CustomPlanWeeks extends StatefulWidget {
  final Plan plan;
  const CustomPlanWeeks({
    Key? key,
    required this.plan,
  }) : super(key: key);

  @override
  State<CustomPlanWeeks> createState() => _CustomPlanWeeksState();
}

class _CustomPlanWeeksState extends State<CustomPlanWeeks> {
  late Completer<bool?> _deleteCustomWeekDismissibleCompleter;

  @override
  void initState() {
    _deleteCustomWeekDismissibleCompleter = Completer();
    context.read<PlanWeeksCubit>().fetchWeeks(widget.plan.id);
    super.initState();
  }

  void _addNewWeek() async {
    final result =
        await showDialog(context: context, builder: (_) => _AddNewWeekDialog());
    if (result == null) return;
    context.read<PlanWeeksCubit>().createWeek();
  }

  Future<void> _deleteWeek(PlanWeek week) async {
    return context.read<PlanWeeksCubit>().deleteWeek(week.id);
  }

  void _navigateToWeekDays(PlanWeek week) {
    WeekDaysScreen(week: week, planType: PlanType.custom).navigate(context);
  }

  void _completeCustomWeekDismissibleCompleter([bool? result]) {
    _deleteCustomWeekDismissibleCompleter.complete(result);
    _deleteCustomWeekDismissibleCompleter = Completer();
  }

  @override
  Widget build(BuildContext context) {
    final weeksCubit = context.read<PlanWeeksCubit>();
    return BlocListener<PlanWeeksCubit, CustomPlanWeeksState>(
      listener: (context, state) async {
        if (state.isDeleted) {
          CSnackBar.success(
            messageText: LocaleKeys.success_deleted.tr(),
            avoidNavigationBar: false,
          ).showWithoutContext();
          _completeCustomWeekDismissibleCompleter(true);
        } else if (state.isCreated) {
          CSnackBar.success(
            messageText: LocaleKeys.success_created.tr(),
            avoidNavigationBar: false,
          ).showWithoutContext();
        } else if (state.isGeneralLoading) {
          await LoadingDialog.view(context);
        } else if (state.isGeneralFailure) {
          appLogger.e(state.companion);
          CSnackBar.failure(
            messageText: LocaleKeys.error_error_happened.tr(),
            avoidNavigationBar: false,
          ).showWithoutContext();
          _completeCustomWeekDismissibleCompleter();
        } else if (state.isFailed) {
          appLogger.e(state.companion);
        }
        LoadingDialog.pop(context);
      },
      child: Scaffold(
        appBar: CAppBar(header: widget.plan.name),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNewWeek,
          child: Icon(Icons.add),
        ),
        body: SafeArea(
          child: Padding(
            padding: KEdgeInsets.h15 + const EdgeInsets.only(bottom: 60),
            child: BlocBuilder<PlanWeeksCubit, CustomPlanWeeksState>(
              builder: (context, state) {
                if (state.isFailed) {
                  return ErrorHappened(
                      onRetry: () => weeksCubit.fetchWeeks(widget.plan.id));
                } else if (state.isLoaded) {
                  final weeks = state.weeks;
                  if (weeks.isEmpty) return NoDataError();
                  return _buildWeeksTableSection(weeks);
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeeksTableSection(List<PlanWeek> weeks) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: weeks.length,
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final week = weeks[index];
        return Dismissible(
          key: ValueKey(week.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => null,
          confirmDismiss: (_) async {
            await _deleteWeek(week);
            return _deleteCustomWeekDismissibleCompleter.future;
          },
          background: const DismissibleDeleteBG(),
          child: TitleListTile(
            onTap: () => _navigateToWeekDays(week),
            trailing: const SizedBox.shrink(),
            // trailing: Text("#${week.id}"),
            title: LocaleKeys.screens_general_week_num.tr(
              namedArgs: {"num": "${index + 1}"},
            ),
          ),
        );
      },
    );
  }
}

class _AddNewWeekDialog extends StatelessWidget {
  const _AddNewWeekDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: Text(LocaleKeys.screens_plans_custom_plans_new_week_title.tr()),
      content:
          Text(LocaleKeys.screens_plans_custom_plans_new_week_content.tr()),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            textStyle: theme(context).textTheme.titleMedium,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            LocaleKeys.general_titles_add.tr(),
            style: theme(context).textTheme.labelLarge,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocaleKeys.general_titles_cancel.tr()),
        ),
      ],
    );
  }
}
