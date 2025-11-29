import 'package:flutter/material.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:utilities/utilities.dart';

///Muscle brief info which has a title, subtitle and an image.
///
class MuscleSideEffectInfo extends StatelessWidget {
  ///title text.
  final String title;

  ///subtitle text.
  final String subTitle;

  ///muscle's image path.
  final String imagePath;

  ///muscle's image alignment.
  final AlignmentGeometry? alignment;

  final VoidCallback? onTap;

  const MuscleSideEffectInfo({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    this.alignment,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme(context).textTheme.titleLarge?.copyWith(fontSize: 15),
                ),
                Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: theme(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                ),
                const Space.v10(),
                Expanded(
                  child: ClipRRect(
                    borderRadius: KBorders.bc5,
                    child: ShimmerImage(
                      imageUrl: imagePath,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
