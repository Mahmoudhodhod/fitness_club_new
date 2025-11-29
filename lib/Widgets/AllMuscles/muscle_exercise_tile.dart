import 'package:flutter/material.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:utilities/utilities.dart';
import 'package:the_coach/Widgets/widgets.dart';

///Power training main muscle item.
///
class MuscleExerciseTile extends StatelessWidget {
  ///Muscle center title.
  final String title;

  ///Muscle header image path.
  final String imagePath;

  final VoidCallback? onTap;

  ///Power training main muscle item.
  ///
  const MuscleExerciseTile({
    Key? key,
    required this.title,
    required this.imagePath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenSize.height * 0.2,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: KBorders.bc5),
          // color: Colors.black54,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: KBorders.bc5,
                  child: ShimmerImage(
                    imageUrl: imagePath,
                    boxFit: BoxFit.fitWidth,
                  ),
                ),
              ),
              GradientShadower.stacked(border: KBorders.bcb15),
              ClipPath(
                clipper: _DiagonalPathClipperOne(),
                child: Container(
                  decoration: BoxDecoration(
                    color: CColors.fancyBlack.withOpacity(0.5),
                  ),
                  child: Align(
                    alignment: AlignmentDirectional(0.85, .75),
                    child: Text(
                      title,
                      style: theme(context).textTheme.titleLarge,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// [_DiagonalPathClipperOne], can be used with [ClipPath] widget, and clips the widget diagonally

class _DiagonalPathClipperOne extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height / 2.0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height - 60);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
