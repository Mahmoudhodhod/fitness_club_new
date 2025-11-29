import 'package:flutter/material.dart';
import 'package:the_coach/Helpers/constants.dart';

class TapGestureIcon extends StatelessWidget {
  final Size size;
  final AlignmentGeometry alignment;

  const TapGestureIcon({
    Key? key,
    this.size = const Size.square(30),
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Image.asset(
        tapGestureIcon,
        color: Colors.white,
        height: size.height,
        width: size.width,
      ),
    );
  }
}
