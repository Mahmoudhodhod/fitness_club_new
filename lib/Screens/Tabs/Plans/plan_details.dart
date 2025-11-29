import 'package:authentication/authentication.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';
import 'package:the_coach/Screens/Tabs/Helpers/screens_helpers.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class PlanDetailsScreen extends StatelessWidget {
  final Plan plan;

  const PlanDetailsScreen({
    Key? key,
    required this.plan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchPlanWeeksCubit(
        authRepository: context.read<AuthRepository>(),
        repository: context.read<PlansRepository>(),
      )..fetchPlanWeeks(plan.id),
      child: _PlanDetailsView(plan: plan),
    );
  }
}

class _PlanDetailsView extends StatefulWidget {
  final Plan plan;
  const _PlanDetailsView({
    Key? key,
    required this.plan,
  }) : super(key: key);

  @override
  State<_PlanDetailsView> createState() => _PlanDetailsViewState();
}

class _PlanDetailsViewState extends State<_PlanDetailsView> {
  @override
  void initState() {
    // AdInterstitial().showDelayed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      leading: const BackButton(),
      title: Text(widget.plan.name, style: theme(context).textTheme.bodyLarge),
      headerExpandedHeight: .2,
      headerWidget: _buildPlanHeader(context),
      body: [
        Padding(
          padding: KEdgeInsets.h5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.plan.name,
                  textAlign: TextAlign.center,
                  style: theme(context).textTheme.headlineSmall,
                ),
              ),
              _buildDetailsSection(),
              const Space.v10(),
              _buildWeeksTableSection(),
              const SourcesButton(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildWeeksTableSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: KBorders.bc5),
      color: CColors.nullableSwitchable(context,
          light: Colors.grey.shade100, dark: CColors.darkerBlack),
      child: BlocBuilder<FetchPlanWeeksCubit, FetchPlanWeeksState>(
        builder: (context, state) {
          if (state is FetchPlanWeeksSucceeded) {
            final weeks = state.weeks;
            if (weeks.isEmpty) return NoDataError();
            return ListView.separated(
              padding: KEdgeInsets.h10,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: weeks.length,
              separatorBuilder: (context, index) => Divider(height: 0),
              itemBuilder: (context, index) {
                final week = weeks[index];
                return TitleListTile(
                  onTap: () {
                    WeekDaysScreen(week: week).navigate(context);
                  },
                  title: LocaleKeys.screens_general_week_num.tr(
                    namedArgs: {"num": "${index + 1}"},
                  ),
                );
              },
            );
          }
          return const Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Card(
      color: CColors.nullableSwitchable(
        context,
        light: Colors.grey.shade100,
        dark: CColors.darkerBlack,
      ),
      shape: RoundedRectangleBorder(borderRadius: KBorders.bc10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.plan.description,
              textAlign: TextAlign.start,
            ),
          ),
          InfoTable(
            rows: [
              InfoTableRow(
                title: LocaleKeys.screens_general_duration.tr(),
                detailsText:
                    LocaleKeys.screens_general_duration_weeks.tr(namedArgs: {
                  "num": widget.plan.weeksCount.toString(),
                }),
              ),

              // InfoTableRow(
              //   title: LocaleKeys.screens_plans_goal.tr(),
              //   detailsText: "بناء العضلات للمبتدئين",
              // ),
              // InfoTableRow(
              //   title: LocaleKeys.screens_plans_target_group.tr(),
              //   detailsText: "الرجال والنساء",
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanHeader(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              SlideShow(
                images: [NetworkImage(widget.plan.assets!.url)],
              ).show(context);
            },
            child: ShimmerImage(
              imageUrl: widget.plan.assets!.url,
              boxFit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(-0.9, -0.5),
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: BackButton(),
            ),
          ),
        ),
        TapGestureIcon(),
      ],
    );
  }
}
