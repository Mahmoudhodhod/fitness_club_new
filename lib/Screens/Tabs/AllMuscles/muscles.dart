import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_coach/Modules/Muscles/muscles_module.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';
import 'package:utilities/utilities.dart';

import 'sub_exercises.dart';

class AllMusclesScreen extends StatelessWidget {
  const AllMusclesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const _AllMusclesView();
}

class _AllMusclesView extends StatefulWidget {
  const _AllMusclesView({Key? key}) : super(key: key);

  @override
  _AllMusclesViewState createState() => _AllMusclesViewState();
}

class _AllMusclesViewState extends State<_AllMusclesView> {
  Muscle? _selected;

  void _performMuscleShow() {
    if (_selected == null) return;
    //show muscle screen -> sub exercises
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => MuscleSubExercisesScreen(
          muscle: _selected!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CDrawer(),
      appBar: CAppBar(
        header: LocaleKeys.general_titles_app_title.tr(),
      ),
      body: SafeArea(
        child: BlocBuilder<FetchMusclesCubit, FetchMusclesState>(
          builder: (context, state) {
            if (state is FetchMusclesFailure) {
              return const ErrorHappened();
            } else if (state is FetchMusclesSucceeded) {
              final _state = state;
              final muscles = _state.muscles;
              if (muscles.isEmpty) return const NoDataError();
              return _buildMuscleSelector(muscles);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildMuscleSelector(List<Muscle> muscles) {
    return Center(
      child: Column(
        children: [
          Card(
            color: CColors.switchable(
              context,
              dark: CColors.darkerBlack,
              light: Colors.white,
            ),
            margin: const EdgeInsets.only(top: 20),
            shape: RoundedRectangleBorder(borderRadius: KBorders.bc10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.screens_plans_custom_plans_select_muscle.tr(),
                    style: theme(context).textTheme.titleLarge,
                  ),
                  Text(' 💪', style: theme(context).textTheme.titleLarge),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: MuscleSelector(
                muscles: muscles,
                selected: _selected,
                centerImagePath: _selected?.assets.url,
                onContinuePressed: _performMuscleShow,
                builder: (context, muscle, selected) {
                  var disabledPrimary = CColors.nullableSwitchable(
                    context,
                    dark: Colors.white,
                    light: Colors.grey.shade200,
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      onPressed: () => setState(() => _selected = muscle),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !selected
                            ? disabledPrimary
                            : CColors.secondary(context),
                        foregroundColor:
                            !selected ? CColors.fancyBlack : Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 10),
                        shape: const RoundedRectangleBorder(
                            borderRadius: KBorders.bc5),
                      ),
                      child: Text(muscle.name),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
