import 'dart:io';

import 'package:flutter/material.dart';

import 'package:the_coach/Modules/Plans/Models/models.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:the_coach/Screens/Tabs/Plans/plan_day_exercises.dart';
import 'package:the_coach/Widgets/widgets.dart';

import 'CustomPlans/custom_plans.dart';

enum PlanType { custom, none }

class WeekDaysScreen extends StatelessWidget {
  final PlanWeek week;
  final PlanType planType;
  const WeekDaysScreen({
    Key? key,
    required this.week,
    this.planType = PlanType.none,
  }) : super(key: key);

  Future<void> navigate(BuildContext context) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => this));
  }

  void _navigateToDayExercises(BuildContext context, WeekDay day) {
    if (planType == PlanType.custom) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => DayExercisesScreen(
            day: day,
          ),
        ),
      );
      return;
    }
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => PlanDayExercisesScreen(day: day),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: !Platform.isIOS,
        child: CustomScrollView(
          slivers: [
            CAppBar(sliverStyle: const SliverStyle()),
            SliverFillRemaining(
              child: WeekDaysPreviewer(
                days: week.days,
                onTap: (day) => _navigateToDayExercises(context, day),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
