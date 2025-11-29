import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/constants.dart';
import 'package:the_coach/Modules/Muscles/muscles_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

//TODO: test

///
typedef MuscleButtonBuilder = Widget Function(
    BuildContext context, Muscle muscle, bool selected);

///
///Muscle selector and builder to let the user choose a muscle.
///
class MuscleSelector extends StatelessWidget {
  ///The displayed muscles list.
  ///
  final List<Muscle> muscles;

  ///The muscle button builder.
  ///
  final MuscleButtonBuilder builder;

  ///The current selected muscle.
  ///
  final Muscle? selected;

  ///Triggered when the user taps on the continue button which is activated
  ///when the user chooses a muscle.
  ///
  final VoidCallback? onContinuePressed;

  ///The center main muscle displayed image.
  ///
  final String? centerImagePath;

  ///Muscle selector and builder to let the user choose a muscle.
  ///
  const MuscleSelector({
    Key? key,
    required this.muscles,
    required this.builder,
    this.centerImagePath,
    this.selected,
    this.onContinuePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool _enableGoButton = selected != null;

    List<Muscle> _leftMuscles = [];
    List<Muscle> _rightMuscles = [];
    final mid = muscles.length ~/ 2;
    _leftMuscles = muscles.sublist(0, mid);
    _rightMuscles = muscles.sublist(mid);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_leftMuscles.length, (index) {
              final muscle = _leftMuscles[index];
              return builder(context, muscle, muscle == selected);
            }),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: size.height * .5,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: KBorders.bc5,
                ),
                child: centerImagePath != null
                    ? ShimmerImage(
                        imageUrl: centerImagePath!,
                        boxFit: BoxFit.contain,
                        height: double.infinity,
                        width: double.infinity,
                      )
                    : Image.asset(kMuscleSectionDefaultImage),
              ),
              const Space.v20(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  visualDensity: VisualDensity.comfortable,
                  // backgroundColor: CColors.secondary(context),

                  shape: RoundedRectangleBorder(borderRadius: KBorders.bc15),
                ),
                onPressed: _enableGoButton ? onContinuePressed : null,
                child: Text(
                  LocaleKeys.general_titles_continue.tr(),
                  style: TextStyle(
                    color: CColors.nullableSwitchable(
                      context,
                      dark: Colors.white,
                      light: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              _rightMuscles.length,
              (index) {
                final muscle = _rightMuscles[index];
                return builder(context, muscle, muscle == selected);
              },
            ),
          ),
        ),
      ],
    );
  }
}
