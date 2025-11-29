import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:the_coach/Helpers/constants.dart';

class WorkoutPlansIcon extends StatelessWidget {
  final Color? color;
  const WorkoutPlansIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      workoutIconSVG,
      width: 20,
      color: color,
    );
  }
}
